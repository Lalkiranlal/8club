import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart' as record;

class MediaRecorderService {
  final record.AudioRecorder _recorder = record.AudioRecorder();

  bool _isRecording = false;
  String? _recordedFilePath;
  Duration _duration = Duration.zero;
  Timer? _timer;

  final StreamController<Duration> _durationController =
      StreamController.broadcast();
  Stream<Duration> get durationStream => _durationController.stream;

  bool get isRecording => _isRecording;
  String? get recordedFilePath => _recordedFilePath;

  Future<bool> _checkPermission() async {
    final status = await Permission.microphone.status;
    if (!status.isGranted) {
      final result = await Permission.microphone.request();
      return result.isGranted;
    }
    return true;
  }

  Future<void> startRecording() async {
    if (_isRecording) return;
    final hasPermission = await _checkPermission();
    if (!hasPermission) throw Exception('Microphone permission not granted');

    final dir = await getTemporaryDirectory();
    _recordedFilePath =
        '${dir.path}/record_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(
      const record.RecordConfig(
        encoder: record.AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: _recordedFilePath ?? '',
    );

    _isRecording = true;
    _duration = Duration.zero;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _duration += const Duration(seconds: 1);
      _durationController.add(_duration);
    });
  }

  Future<String?> stopRecording() async {
    if (!_isRecording) return null;
    final path = await _recorder.stop();
    _timer?.cancel();
    _isRecording = false;
    return path;
  }

  Future<void> dispose() async {
    _timer?.cancel();
    await _recorder.dispose();
    await _durationController.close();
  }
}
