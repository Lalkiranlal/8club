import 'package:flutter/material.dart';
import 'package:test/assets/colors/colors.dart';

class ZigZagEdgePainter extends CustomPainter {
  final Color color;
  final double height;

  const ZigZagEdgePainter({
    required this.color,
    this.height = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const segmentHeight = 4.0;
    final path = Path();
    
    // Start from top-right
    path.moveTo(0, 0);
    
    // Create zigzag pattern
    double y = 0;
    bool goingRight = true;
    
    while (y < size.height) {
      final x = goingRight ? height : 0.0;
      path.lineTo(x, y);
      y += segmentHeight;
      goingRight = !goingRight;
    }
    
    // Close the path
    path.lineTo(0, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class OnboardingProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onBack;
  final VoidCallback? onClose;

  const OnboardingProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.onBack,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onBack,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: onBack != null
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    size: 20,
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite2.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 6,
                        width: MediaQuery.of(context).size.width * (currentStep / totalSteps),
                        decoration: BoxDecoration(
                          color: AppColors.positive,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(3),
                            bottomLeft: Radius.circular(3),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: CustomPaint(
                            size: const Size(8, 6),
                            painter: ZigZagEdgePainter(
                              color: AppColors.positive,
                              height: 8,
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                ),
              ),

              GestureDetector(
                onTap: onClose,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  child: Icon(
                    Icons.close,
                    color: onClose != null
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
