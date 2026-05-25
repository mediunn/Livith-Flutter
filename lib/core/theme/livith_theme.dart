import 'package:flutter/material.dart';

import 'package:livith/core/theme/livith_colors.dart';
import 'package:livith/core/theme/livith_typography.dart';

/// Livith 앱 테마.
///
/// iOS와 동일하게 Black100 배경의 다크 단일 테마를 사용한다.
abstract final class LivithTheme {
  const LivithTheme._();

  static ThemeData get dark {
    const colorScheme = ColorScheme.dark(
      primary: LivithColors.yellow60,
      onPrimary: LivithColors.black100,
      secondary: LivithColors.yellow30,
      surface: LivithColors.black90,
      onSurface: LivithColors.white100,
      error: LivithColors.caution100,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: LivithTextStyles.fontFamily,
      scaffoldBackgroundColor: LivithColors.black100,
      colorScheme: colorScheme,
      textTheme: const TextTheme(
        titleLarge: LivithTextStyles.title,
        titleMedium: LivithTextStyles.headSemibold,
        bodyLarge: LivithTextStyles.body1Semibold,
        bodyMedium: LivithTextStyles.body2Regular,
        bodySmall: LivithTextStyles.body4Regular,
        labelSmall: LivithTextStyles.caption1Regular,
      ).apply(
        bodyColor: LivithColors.white100,
        displayColor: LivithColors.white100,
      ),
    );
  }
}
