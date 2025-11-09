// widgets/recording_card_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/assets/colors/colors.dart';
import 'package:test/assets/fonts/fonts.dart';
import 'package:test/features/onboarding_question/widgets/media_recorder_widget.dart';
import '../services/media_recorder_service.dart';

class RecordingCardWidget extends ConsumerStatefulWidget {
  final bool isRecording;
  final String? audioPath;
  final String? duration;
  final VoidCallback? onStopRecording;
  final VoidCallback? onDelete;
  final VoidCallback? onConfirm;

  const RecordingCardWidget({
    super.key,
    required this.isRecording,
    this.audioPath,
    this.duration,
    this.onStopRecording,
    this.onDelete,
    this.onConfirm,
  });

  @override
  ConsumerState<RecordingCardWidget> createState() =>
      _RecordingCardWidgetState();
}

class _RecordingCardWidgetState extends ConsumerState<RecordingCardWidget> {
  bool _isPlaying = false;
  bool _isLoading = false;

  Future<void> _togglePlayback() async {
    if (widget.audioPath == null) return;

    try {
      setState(() {
        _isLoading = true;
      });

      final mediaService = ref.read(mediaRecorderProvider);

      if (_isPlaying) {
        await mediaService.stopPlayback();
        setState(() {
          _isPlaying = false;
          _isLoading = false;
        });
      } else {
        await mediaService.playRecording(widget.audioPath!);
        setState(() {
          _isPlaying = true;
          _isLoading = false;
        });

        Future.delayed(const Duration(seconds: 3), () {
          if (mounted && _isPlaying) {
            setState(() {
              _isPlaying = false;
            });
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Playback failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleDelete() {
    setState(() {
      _isPlaying = false;
    });
    widget.onDelete?.call();
  }

  void _handleConfirm() {
    setState(() {
      _isPlaying = false;
    });
    widget.onConfirm?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite2.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border2.withOpacity(0.5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.isRecording
                          ? Colors.red
                          : AppColors.positive,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.isRecording
                        ? 'Recording Audio...'
                        : 'Audio Recorded',
                    style: AppTextStyles.b1Regular.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              if (widget.duration != null)
                Text(
                  widget.duration!,
                  style: AppTextStyles.b2Regular.copyWith(
                    color: AppColors.text3,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          Container(
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.surfaceBlack2.withOpacity(0.5),
            ),
            child: Row(
              children: [
                if (!widget.isRecording)
                  _isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                        )
                      : IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: _togglePlayback,
                        ),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(20, (index) {
                      final baseHeight = (index % 3 + 1) * 4.0;
                      final animatedHeight = _isPlaying
                          ? baseHeight + (DateTime.now().millisecond % 8)
                          : baseHeight;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 2,
                        height: animatedHeight,
                        decoration: BoxDecoration(
                          color: widget.isRecording
                              ? Colors.red
                              : _isPlaying
                              ? AppColors.primaryAccent
                              : AppColors.primaryAccent.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      );
                    }),
                  ),
                ),

                if (widget.isRecording)
                  IconButton(
                    icon: const Icon(Icons.stop, color: Colors.red, size: 20),
                    onPressed: widget.onStopRecording,
                  )
                else
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: _handleDelete,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.check_circle,
                          color: AppColors.positive,
                          size: 20,
                        ),
                        onPressed: _handleConfirm,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
