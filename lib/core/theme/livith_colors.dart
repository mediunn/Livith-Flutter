import 'package:flutter/material.dart';

/// Livith 디자인 시스템 색상 토큰.
///
/// iOS `LivithDesignSystem`의 `LivithColor`(Asset Catalog)와 동일한 HEX 값을 사용한다.
abstract final class LivithColors {
  const LivithColors._();

  static const Color black100 = Color(0xFF14171B);
  static const Color black90 = Color(0xFF222831);
  static const Color black80 = Color(0xFF2F3745);
  static const Color black50 = Color(0xFF808794);
  static const Color black30 = Color(0xFFDBDCDF);
  static const Color black5 = Color(0xFFF2F4F6);
  static const Color white100 = Color(0xFFFFFFFF);
  static const Color yellow30 = Color(0xFFFFFF97);
  static const Color yellow60 = Color(0xFFFFEB56);
  static const Color caution100 = Color(0xFFE11936);
  static const Color original = Color(0xFFCAD0FF);
  static const Color translation = Color(0xFFFFBAB4);
}
