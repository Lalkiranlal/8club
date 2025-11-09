import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/assets/colors/colors.dart';
import 'package:test/assets/fonts/fonts.dart';
import 'package:test/features/onboarding_question/widgets/audio_record_preview.dart';
import 'package:test/features/onboarding_question/widgets/media_recorder_widget.dart';
import 'package:test/features/onboarding_question/widgets/navigation_button.dart';
import 'package:test/features/onboarding_question/widgets/progress_indicator.dart';

class OnboardingScreen2 extends ConsumerStatefulWidget {
  const OnboardingScreen2({super.key});

  @override
  ConsumerState<OnboardingScreen2> createState() => _OnboardingScreenState2();
}

class _OnboardingScreenState2 extends ConsumerState<OnboardingScreen2> {
  final TextEditingController _commentController = TextEditingController();
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _audioPath;
  String _recordingDuration = '00:00';
  int _recordingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _audioPath = null;
      _recordingSeconds = 0;
      _recordingDuration = '00:00';
    });
    
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
      _audioPath = 'recorded_audio_path';
      _recordingDuration = '00:59';
    });
  }

  void _togglePlayback() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _deleteRecording() {
    setState(() {
      _audioPath = null;
      _isPlaying = false;
      _isRecording = false;
    });
  }

  void _confirmRecording() {
    print('Recording confirmed: $_audioPath');
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasRecording = _audioPath != null;
    final showRecordingCard = _isRecording || hasRecording;

    return Scaffold(
      backgroundColor: AppColors.base1,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
                color: AppColors.surfaceBlack2,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const OnboardingProgressBar(currentStep: 2, totalSteps: 3),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Why do you want to host with us?',
                                  style: AppTextStyles.h2Bold),
                              const SizedBox(height: 24),
                              const Text(
                                'Tell us about your intent and what motivates you to create experiences.',
                                style: AppTextStyles.b2Regular,
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _commentController,
                                maxLines: 15,
                                minLines: 15,
                                style: AppTextStyles.b2Regular.copyWith(
                                  color: AppColors.text1,
                                  height: 1.5,
                                ),
                                decoration: InputDecoration(
                                  hintText: '/Start typing here',
                                  hintStyle: AppTextStyles.b2Regular
                                      .copyWith(color: AppColors.text3),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  filled: true,
                                  fillColor:
                                      AppColors.surfaceWhite2.withOpacity(0.3),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColors.border2, width: 1.0),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColors.primaryAccent,
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              
                          
                              if (_isRecording || _audioPath != null)
                                RecordingCardWidget(
                                  isRecording: _isRecording,
                                  audioPath: _audioPath,
                                  duration: _recordingDuration,
                                  onStopRecording: _stopRecording,
                                  onDelete: _deleteRecording,
                                  onConfirm: _confirmRecording,
                                ),
                              
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 16.0),
                        child: Row(
                          children: [
                            MediaRecorderWidget(
                              onAudioRecorded: (path) {
                                setState(() => _audioPath = path);
                              },
                              onStartRecording: _startRecording,
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 120,
                              child: NextButton(
                                onPressed: _commentController.text.isNotEmpty || hasRecording
                                    ? () {
                                      }
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
