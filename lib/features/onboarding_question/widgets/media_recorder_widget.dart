import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/media_recorder_service.dart';

final mediaRecorderProvider = Provider((ref) => MediaRecorderService());

class MediaRecorderWidget extends ConsumerStatefulWidget {
  final Function(String?)? onAudioRecorded;
  final VoidCallback? onStartRecording;
  final VoidCallback? onStopRecording;
  final VoidCallback? onDeleteRecording;

  const MediaRecorderWidget({
    super.key,
    this.onAudioRecorded,
    this.onStartRecording,
    this.onStopRecording,
    this.onDeleteRecording,
  });

  @override
  ConsumerState<MediaRecorderWidget> createState() =>
      _MediaRecorderWidgetState();
}

class _MediaRecorderWidgetState extends ConsumerState<MediaRecorderWidget> {
  bool _isRecording = false;
  String? _currentAudioPath;

  @override
  void initState() {
    super.initState();
    _currentAudioPath = ref.read(mediaRecorderProvider).currentAudioPath;
  }

  Future<void> _startRecording() async {
    try {
      // Check and request microphone permission
      final status = await Permission.microphone.request();

      if (status != PermissionStatus.granted) {
        if (mounted) {
          _showErrorSnackbar(
            status.isPermanentlyDenied
                ? 'Microphone permission is required for recording. Please enable it in app settings.'
                : 'Microphone permission denied',
          );

          if (status.isPermanentlyDenied) {
            await openAppSettings();
          }
        }
        return;
      }

      setState(() {
        _isRecording = true;
      });

      widget.onStartRecording?.call();

      final mediaService = ref.read(mediaRecorderProvider);
      final audioPath = await mediaService.startRecording();

      if (!mounted) return;

      setState(() {
        _currentAudioPath = audioPath;
      });

      widget.onAudioRecorded?.call(audioPath);
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Failed to start recording: $e');
        setState(() {
          _isRecording = false;
        });
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      final mediaService = ref.read(mediaRecorderProvider);
      await mediaService.stopRecording();

      setState(() {
        _isRecording = false;
      });

      widget.onStopRecording?.call();
    } catch (e) {
      _showErrorSnackbar('Failed to stop recording: $e');
    }
  }

  void _deleteRecording() {
    setState(() {
      _currentAudioPath = null;
      _isRecording = false;
    });

    widget.onDeleteRecording?.call();
    widget.onAudioRecorded?.call(null);
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasRecording = _currentAudioPath != null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Tooltip(
            message: _isRecording ? 'Stop Recording' : 'Start Recording',
            child: IconButton(
              icon: Icon(
                _isRecording ? Icons.stop_circle : Icons.mic_none_rounded,
                color: _isRecording
                    ? Colors.red
                    : Colors.white.withOpacity(0.75),
                size: 24,
              ),
              onPressed: _isRecording ? _stopRecording : _startRecording,
            ),
          ),

          CustomPaint(
            painter: _DashedLinePainter(color: Colors.white.withOpacity(0.4)),
            child: const SizedBox(height: 28, width: 1),
          ),

          // 📹 Video Icon
          Tooltip(
            message: 'Record Video',
            child: IconButton(
              icon: Icon(
                Icons.videocam_outlined,
                color: Colors.white.withOpacity(0.75),
                size: 24,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Video recording coming soon!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashLength;
  final double dashGap;
  final double strokeWidth;

  _DashedLinePainter({
    required this.color,
    this.dashLength = 5.0,
    this.dashGap = 3.0,
    this.strokeWidth = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashLength),
        paint,
      );
      startY += dashLength + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
