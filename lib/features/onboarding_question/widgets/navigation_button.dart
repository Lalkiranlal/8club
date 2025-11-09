import 'package:flutter/material.dart';
import 'package:test/assets/colors/colors.dart';
import 'package:test/assets/fonts/fonts.dart';

class NextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const NextButton({
    super.key,
    this.onPressed,
    this.text = 'Next',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: onPressed != null
            ? const LinearGradient(
                colors: [
                  Color(0xFF101010),
                  Color(0xFFFFFFFF),
                ],
                stops: [0.0, 1.0],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : const LinearGradient(
                colors: [
                  Color(0xFF101010),
                  Color(0xFF222222),
                  Color(0xFF101010),
                ],
                stops: [0.0, 0.5, 1.0],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: onPressed != null
              ? const Color(0xFF999999)
              : const Color(0xFF222222),
          width: 1.0,
        ),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor:
              onPressed != null ? AppColors.text1 : const Color(0xFF999999),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          minimumSize: const Size.fromHeight(56),
          shadowColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: AppTextStyles.b1Bold.copyWith(
                color: onPressed != null
                    ? AppColors.text1
                    : const Color(0xFF999999),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_rounded,
              size: 24,
              color:
                  onPressed != null ? AppColors.text1 : const Color(0xFF999999),
            ),
          ],
        ),
      ),
    );
  }
}
