from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TYPOGRAPHY = ROOT / "lib/core/theme/app_typography.dart"
MAIN = ROOT / "lib/main.dart"


def update_typography() -> None:
    text = TYPOGRAPHY.read_text(encoding="utf-8")

    text = text.replace("fontWeight: FontWeight.w500,", "fontWeight: FontWeight.w400,")
    text = text.replace(
        "fontWeight: selected ? FontWeight.w500 : FontWeight.w400,",
        "fontWeight: selected ? FontWeight.w400 : FontWeight.w300,",
    )

    # Restore body hierarchy after the broad replacement above.
    text = text.replace(
        "bodyLarge: base.bodyLarge?.copyWith(\n        fontFamily: family,\n        fontWeight: FontWeight.w400,",
        "bodyLarge: base.bodyLarge?.copyWith(\n        fontFamily: family,\n        fontWeight: FontWeight.w400,",
    )
    text = text.replace(
        "bodyMedium: base.bodyMedium?.copyWith(\n        fontFamily: family,\n        fontWeight: FontWeight.w400,",
        "bodyMedium: base.bodyMedium?.copyWith(\n        fontFamily: family,\n        fontWeight: FontWeight.w400,",
    )
    text = text.replace(
        "labelLarge: base.labelLarge?.copyWith(\n        fontFamily: family,\n        fontWeight: FontWeight.w400,",
        "labelLarge: base.labelLarge?.copyWith(\n        fontFamily: family,\n        fontWeight: FontWeight.w400,",
    )

    TYPOGRAPHY.write_text(text, encoding="utf-8")


def update_main() -> None:
    text = MAIN.read_text(encoding="utf-8")

    text = text.replace(
        "textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),",
        "textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),",
    )

    desktop_old = """label: Text(\n                        _label(item.$2),\n                        style: AppTypography.navigation(\n                          languageCode: widget.language.code,\n                        ),\n                      ),"""
    desktop_new = "label: Text(_label(item.$2)),"
    text = text.replace(desktop_old, desktop_new)

    drawer_old = """label: Text(\n                _label(item.$2),\n                style: AppTypography.navigation(\n                  languageCode: widget.language.code,\n                ),\n              ),"""
    drawer_new = "label: Text(_label(item.$2)),"
    text = text.replace(drawer_old, drawer_new)

    if "navigationDrawerTheme:" not in text:
        marker = "      navigationRailTheme: NavigationRailThemeData("
        drawer_theme = """      navigationDrawerTheme: NavigationDrawerThemeData(\n        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {\n          return AppTypography.navigation(\n            languageCode: _language.code,\n            selected: states.contains(WidgetState.selected),\n          );\n        }),\n      ),\n"""
        text = text.replace(marker, drawer_theme + marker, 1)

    MAIN.write_text(text, encoding="utf-8")


def main() -> None:
    update_typography()
    update_main()
    print("Soft typography refinement completed.")
    print("Arabic: DIN Next LT Arabic 300-400.")
    print("Other languages: Noto Sans 300-400.")
    print("Navigation selected state now comes from the theme correctly.")


if __name__ == "__main__":
    main()
