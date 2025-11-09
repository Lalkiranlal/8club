import 'package:flutter/material.dart';
import 'package:test/assets/colors/colors.dart';

class AppTextStyles {
  static const String fontFamily = 'Space Grotesk';

  // Headings
  static const TextStyle h1Bold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.03,
    height: 36 / 28,
    color: AppColors.text1,
  );

  static const TextStyle h1Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.03,
    height: 36 / 28,
    color: AppColors.text1,
  );

  static const TextStyle h2Bold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.02,
    height: 30 / 24,
    color: AppColors.text1,
  );

  static const TextStyle h2Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.02,
    height: 30 / 24,
    color: AppColors.text1,
  );

  static const TextStyle h3Bold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.01,
    height: 26 / 20,
    color: AppColors.text1,
  );

  static const TextStyle h3Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.01,
    height: 26 / 20,
    color: AppColors.text1,
  );

  // Body
  static const TextStyle b1Bold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    height: 24 / 16,
    color: AppColors.text1,
  );

  static const TextStyle b1Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: AppColors.text2,
  );

  static const TextStyle b2Bold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    height: 20 / 14,
    color: AppColors.text1,
  );

  static const TextStyle b2Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: AppColors.text2,
  );

  // Subtext
  static const TextStyle s1Bold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.bold,
    height: 16 / 12,
    color: AppColors.text3,
  );

  static const TextStyle s1Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    color: AppColors.text3,
  );

  static const TextStyle s2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 12 / 10,
    color: AppColors.text4,
  );
}
