import 'package:flutter/material.dart';

/// Livith 디자인 시스템 타이포그래피 토큰.
///
/// iOS `LivithDesignSystem`의 `Font.Notosans`와 동일한 크기/굵기/행간을 사용한다.
/// 자간(letterSpacing)은 iOS와 동일하게 `fontSize * -0.05`로 계산한다.
abstract final class LivithTextStyles {
  const LivithTextStyles._();

  static const String fontFamily = 'NotoSansKR';

  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 26,
    height: 1.38,
    letterSpacing: 26 * -0.05,
  );

  static const TextStyle headSemibold = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 22,
    height: 1.38,
    letterSpacing: 22 * -0.05,
  );

  static const TextStyle headMedium = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 22,
    height: 1.38,
    letterSpacing: 22 * -0.05,
  );

  static const TextStyle headRegular = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 22,
    height: 1.38,
    letterSpacing: 22 * -0.05,
  );

  static const TextStyle body1Semibold = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 18,
    height: 1.38,
    letterSpacing: 18 * -0.05,
  );

  static const TextStyle body2Semibold = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 1.38,
    letterSpacing: 16 * -0.05,
  );

  static const TextStyle body2Medium = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.38,
    letterSpacing: 16 * -0.05,
  );

  static const TextStyle body2Regular = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.38,
    letterSpacing: 16 * -0.05,
  );

  static const TextStyle body3Semibold = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 15,
    height: 1.38,
    letterSpacing: 15 * -0.05,
  );

  static const TextStyle body3Medium = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 15,
    height: 1.38,
    letterSpacing: 15 * -0.05,
  );

  static const TextStyle body3Regular = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 15,
    height: 1.38,
    letterSpacing: 15 * -0.05,
  );

  static const TextStyle body4Semibold = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 1.38,
    letterSpacing: 14 * -0.05,
  );

  static const TextStyle body4Medium = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.38,
    letterSpacing: 14 * -0.05,
  );

  static const TextStyle body4Regular = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.38,
    letterSpacing: 14 * -0.05,
  );

  static const TextStyle caption1Bold = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 12,
    height: 1.28,
    letterSpacing: 12 * -0.05,
  );

  static const TextStyle caption1Semibold = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 12,
    height: 1.28,
    letterSpacing: 12 * -0.05,
  );

  static const TextStyle caption1Regular = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.18,
    letterSpacing: 12 * -0.05,
  );

  static const TextStyle caption2Semibold = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 10,
    height: 1.18,
    letterSpacing: 10 * -0.05,
  );

  static const TextStyle caption2Regular = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 10,
    height: 1.18,
    letterSpacing: 10 * -0.05,
  );
}
