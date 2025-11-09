
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/assets/colors/colors.dart';
import 'package:test/assets/fonts/fonts.dart';
import 'package:test/features/onboarding_question/providers/onboarding_provider.dart';
import 'package:test/features/onboarding_question/screens/onboarding_screen2.dart';
import 'package:test/features/onboarding_question/widgets/experiences_grid_view.dart';
import 'package:test/features/onboarding_question/widgets/navigation_button.dart';
import 'package:test/features/onboarding_question/widgets/progress_indicator.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final TextEditingController _commentController = TextEditingController();
  final int _maxCommentLength = 250;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedExperiences = ref.watch(experienceSelectionProvider);
    return Scaffold(
      backgroundColor: AppColors.base1,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    AppColors.surfaceBlack2.withOpacity(0.7),
                    AppColors.surfaceBlack2.withOpacity(0.4),
                    AppColors.surfaceBlack2.withOpacity(0.9),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                OnboardingProgressBar(
                  currentStep: 1,
                  totalSteps: 3,
                  onBack: () {
                    // Handle back navigation
                    Navigator.of(context).pop();
                  },
                  onClose: () {
                    // Handle close action - navigate to home or exit the flow
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Use Flexible instead of Expanded to allow content to size itself
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 16.0),
                          child: Column(
                            
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'What kind of hotspots do you want to host?',
                                style: AppTextStyles.h2Bold,
                              ),
                              const SizedBox(height: 24),
                              const SizedBox(
                                height: 200,
                                child: ExperiencesListView(),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _commentController,
                                maxLength: 250,
                                maxLines: 5,
                                minLines: 5,
                                style: AppTextStyles.b2Regular.copyWith(
                                  color: AppColors.text1,
                                  height: 1.5,
                             
                                ),
                                onChanged: (_) => setState(() {

                                  ref.read(experienceSelectionProvider.notifier).setNote(_commentController.text);
                                }),
                                decoration: InputDecoration(
                                  hintText: '/Describe your favorite hotspot',
                                  hintStyle: AppTextStyles.b2Regular.copyWith(
                                    color: AppColors.text3,
                                  ),
                                  errorText:
                                      _commentController.text.length > 250
                                          ? 'Maximum 250 characters allowed'
                                          : null,
                                  errorMaxLines: 2,
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
                                        color: AppColors.surfaceWhite1,
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 16.0),
                        child: NextButton(
                          onPressed:
                              selectedExperiences.selectedIds.isNotEmpty &&
                                      _commentController.text.isNotEmpty
                                  ? () {
                                     Navigator.push(context, MaterialPageRoute(builder: (context) => const OnboardingScreen2()));
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
    );
  }
}
