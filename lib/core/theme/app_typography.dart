import 'package:flutter/material.dart';

/// Central typography for the EMAN platform.
/// Arabic uses DIN Next LT Arabic; all other languages use Noto Sans.
abstract final class AppTypography {
  static const arabicFamily = 'DINNextLTArabic';
  static const globalFamily = 'NotoSans';

  static String familyFor(String languageCode) {
    return const {'ar', 'fa', 'ur'}.contains(languageCode)
        ? arabicFamily
        : globalFamily;
  }

  static TextTheme textTheme({required bool arabic}) {
    final family = arabic ? arabicFamily : globalFamily;
    final base = Typography.material2021().black;

    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontFamily: family,
        fontWeight: FontWeight.w500,
        height: arabic ? 1.18 : 1.08,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontFamily: family,
        fontWeight: FontWeight.w500,
        height: arabic ? 1.20 : 1.10,
      ),
      displaySmall: base.displaySmall?.copyWith(
        fontFamily: family,
        fontWeight: FontWeight.w500,
        height: arabic ? 1.22 : 1.12,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        fontFamily: family,
        fontWeight: FontWeight.w500,
        height: arabic ? 1.28 : 1.16,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontFamily: family,
        fontWeight: FontWeight.w500,
        height: arabic ? 1.30 : 1.18,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontFamily: family,
        fontWeight: FontWeight.w500,
        height: arabic ? 1.32 : 1.20,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontFamily: family,
        fontWeight: FontWeight.w500,
        height: arabic ? 1.35 : 1.22,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontFamily: family,
        fontWeight: FontWeight.w500,
        height: arabic ? 1.38 : 1.24,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontFamily: family,
        fontWeight: FontWeight.w400,
        height: arabic ? 1.40 : 1.26,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontFamily: family,
        fontWeight: FontWeight.w400,
        height: arabic ? 1.55 : 1.42,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontFamily: family,
        fontWeight: FontWeight.w400,
        height: arabic ? 1.52 : 1.40,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontFamily: family,
        fontWeight: FontWeight.w300,
        height: arabic ? 1.48 : 1.36,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontFamily: family,
        fontWeight: FontWeight.w500,
        height: arabic ? 1.35 : 1.20,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontFamily: family,
        fontWeight: FontWeight.w400,
        height: arabic ? 1.35 : 1.20,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontFamily: family,
        fontWeight: FontWeight.w400,
        height: arabic ? 1.35 : 1.20,
      ),
    );
  }

  static TextStyle navigation({
    required String languageCode,
    bool selected = false,
  }) {
    final arabic = const {'ar', 'fa', 'ur'}.contains(languageCode);
    return TextStyle(
      fontFamily: familyFor(languageCode),
      fontSize: 14,
      fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
      height: arabic ? 1.42 : 1.25,
      color: selected ? const Color(0xFF052A45) : const Color(0xFF607480),
    );
  }
}
