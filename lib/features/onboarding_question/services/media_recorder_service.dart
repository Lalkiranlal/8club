// services/media_recorder_service.dart
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class MediaRecorderService with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _currentAudioPath;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<Duration>? _positionSubscription;

  bool get isRecording => _isRecording;
  bool get isPlaying => _isPlaying;
  String? get currentAudioPath => _currentAudioPath;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;

  MediaRecorderService() {
    _initPlayer();
  }

  Future<bool> _checkPermissions() async {
    // Check and request microphone permission
    final micStatus = await Permission.microphone.status;
    if (!micStatus.isGranted) {
      final result = await Permission.microphone.request();
      if (!result.isGranted) {
        if (result.isPermanentlyDenied) {
          // If permission is permanently denied, open app settings
          await openAppSettings();
        }
        return false;
      }
    }
    return true;
  }

  Future<String?> startRecording() async {
    if (_isRecording) return _currentAudioPath;
    
    if (!await _checkPermissions()) {
      throw Exception('Microphone permission denied');
    }

    try {
      // Stop any ongoing playback
      if (_isPlaying) {
        await stopPlayback();
      }

      final directory = await getTemporaryDirectory();
      final fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
      _currentAudioPath = '${directory.path}/$fileName';

      await _audioRecorder.start(
        RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: _currentAudioPath!,
      );
      
      _isRecording = true;
      notifyListeners();
      return _currentAudioPath;
    } catch (e) {
      _isRecording = false;
      _currentAudioPath = null;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> stopRecording() async {
    if (!_isRecording) return;

    try {
      await _audioRecorder.stop();
    } catch (e) {
      rethrow;
    } finally {
      _isRecording = false;
      notifyListeners();
    }
  }

  void _initPlayer() {
    _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      if (state.processingState == ProcessingState.completed) {
        _isPlaying = false;
      }
      notifyListeners();
    });
  }

  Future<void> playRecording(String? filePath) async {
    if (filePath == null) {
      debugPrint('No recording file path provided');
      return;
    }

    if (_isPlaying) {
      await stopPlayback();
      return;
    }

    try {
      await _audioPlayer.setFilePath(filePath);
      await _audioPlayer.play();
      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      _isPlaying = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> stopPlayback() async {
    await _audioPlayer.stop();
    _isPlaying = false;
  }

  @override
  Future<void> dispose() async {
    await _playerStateSubscription?.cancel();
    await _durationSubscription?.cancel();
    await _positionSubscription?.cancel();
    await _audioPlayer.dispose();
    await _audioRecorder.dispose();
    super.dispose();
  }
}
