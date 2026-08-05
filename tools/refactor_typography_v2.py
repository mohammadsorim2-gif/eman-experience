from __future__ import annotations

from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
LIB = ROOT / "lib"
MAIN = LIB / "main.dart"
THEME_DIR = LIB / "core" / "theme"
TYPOGRAPHY = THEME_DIR / "app_typography.dart"

TYPOGRAPHY_SOURCE = r'''import 'package:flutter/material.dart';

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

  static TextStyle navigation({required String languageCode, bool selected = false}) {
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
'''


def ensure_import(text: str) -> str:
    import_line = "import 'core/theme/app_typography.dart';\n"
    if import_line in text:
        return text
    marker = "import 'core/app_language.dart';\n"
    if marker not in text:
        raise RuntimeError('Could not locate app_language import in lib/main.dart')
    return text.replace(marker, marker + import_line, 1)


def update_theme(text: str) -> str:
    text = text.replace(
        "fontFamily: arabic ? 'DINNextLTArabic' : 'NotoSans',",
        "fontFamily: AppTypography.familyFor(_language.code),",
    )

    old_return = re.compile(
        r"return base\.copyWith\(\s*textTheme:\s*base\.textTheme\.apply\(.*?\),\s*\);",
        re.DOTALL,
    )
    replacement = "return base.copyWith(textTheme: AppTypography.textTheme(arabic: arabic));"
    text, count = old_return.subn(replacement, text, count=1)
    if count == 0 and replacement not in text:
        raise RuntimeError('Could not replace the global text theme in lib/main.dart')

    rail_pattern = re.compile(
        r"navigationRailTheme:\s*const NavigationRailThemeData\(.*?\n\s*\),\n\s*\);",
        re.DOTALL,
    )
    rail_replacement = """navigationRailTheme: NavigationRailThemeData(
        useIndicator: true,
        indicatorColor: const Color(0xFFE8F4FA),
        selectedIconTheme: const IconThemeData(
          size: 21,
          color: EmanExperienceApp.blue,
        ),
        unselectedIconTheme: const IconThemeData(
          size: 20,
          color: Color(0xFF6B7E89),
        ),
        selectedLabelTextStyle: AppTypography.navigation(
          languageCode: _language.code,
          selected: true,
        ),
        unselectedLabelTextStyle: AppTypography.navigation(
          languageCode: _language.code,
        ),
      ),
    );"""
    text, count = rail_pattern.subn(rail_replacement, text, count=1)
    if count == 0 and "selectedLabelTextStyle: AppTypography.navigation" not in text:
        raise RuntimeError('Could not replace NavigationRailThemeData in lib/main.dart')
    return text


def force_navigation_labels(text: str) -> str:
    text = text.replace(
        "label: Text(_label(item.$2)),",
        """label: Text(
                        _label(item.$2),
                        style: AppTypography.navigation(
                          languageCode: widget.language.code,
                        ),
                      ),""",
        1,
    )

    drawer_old = "label: Text(_label(item.$2)),"
    if drawer_old in text:
        text = text.replace(
            drawer_old,
            """label: Text(
                _label(item.$2),
                style: AppTypography.navigation(
                  languageCode: widget.language.code,
                ),
              ),""",
            1,
        )
    return text


def soften_weights() -> int:
    changed = 0
    for path in LIB.rglob('*.dart'):
        if path.name.startswith('app_backup_') or path.name == 'app_remote.dart':
            continue
        text = path.read_text(encoding='utf-8')
        updated = text
        for weight in ('w900', 'w800', 'w700', 'w600'):
            updated = updated.replace(f'FontWeight.{weight}', 'FontWeight.w500')
        if updated != text:
            path.write_text(updated, encoding='utf-8')
            changed += 1
    return changed


def main() -> None:
    if not MAIN.exists():
        raise SystemExit('Run this script from the EMAN project repository.')

    THEME_DIR.mkdir(parents=True, exist_ok=True)
    TYPOGRAPHY.write_text(TYPOGRAPHY_SOURCE, encoding='utf-8')

    text = MAIN.read_text(encoding='utf-8')
    text = ensure_import(text)
    text = update_theme(text)
    text = force_navigation_labels(text)
    MAIN.write_text(text, encoding='utf-8')

    files_changed = soften_weights()
    print('Typography refactor completed.')
    print(f'Normalized heavy weights in {files_changed} Dart files.')
    print('Arabic: DIN Next LT Arabic (300-500).')
    print('Other languages: Noto Sans (300-500).')


if __name__ == '__main__':
    main()
