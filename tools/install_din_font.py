from __future__ import annotations

import argparse
import re
import shutil
import sys
import zipfile
from pathlib import Path

FONT_FAMILY = "DINNextLTArabic"
FONT_DIR = Path("assets/fonts")
PUBSPEC = Path("pubspec.yaml")
MAIN = Path("lib/main.dart")

FONT_MATCHES = {
    "DINNextLTArabic-Light.ttf": ("LIGHT", 300),
    "DINNextLTArabic-Regular.ttf": ("REGULAR", 400),
    "DINNextLTArabic-Medium.ttf": ("MEDIUM", 500),
    "DINNextLTArabic-Bold.ttf": ("BOLD", 700),
    "DINNextLTArabic-Heavy.ttf": ("HEAVY", 800),
    "DINNextLTArabic-Black.ttf": ("BLACK", 900),
}


def _pick_font(names: list[str], token: str) -> str:
    candidates = [
        name
        for name in names
        if name.lower().endswith(".ttf") and token.lower() in Path(name).name.lower()
    ]
    if not candidates:
        raise RuntimeError(f"Could not find the {token} font inside the ZIP archive.")

    # Prefer the shortest filename because the archive contains duplicate copies.
    return sorted(candidates, key=lambda value: (len(Path(value).name), value))[0]


def extract_fonts(zip_path: Path) -> None:
    FONT_DIR.mkdir(parents=True, exist_ok=True)

    with zipfile.ZipFile(zip_path) as archive:
        names = archive.namelist()
        for output_name, (token, _) in FONT_MATCHES.items():
            source_name = _pick_font(names, token)
            output_path = FONT_DIR / output_name
            with archive.open(source_name) as source, output_path.open("wb") as target:
                shutil.copyfileobj(source, target)
            print(f"Installed {output_path}")


def update_pubspec() -> None:
    text = PUBSPEC.read_text(encoding="utf-8")

    font_block = """

  fonts:
    - family: DINNextLTArabic
      fonts:
        - asset: assets/fonts/DINNextLTArabic-Light.ttf
          weight: 300
        - asset: assets/fonts/DINNextLTArabic-Regular.ttf
          weight: 400
        - asset: assets/fonts/DINNextLTArabic-Medium.ttf
          weight: 500
        - asset: assets/fonts/DINNextLTArabic-Bold.ttf
          weight: 700
        - asset: assets/fonts/DINNextLTArabic-Heavy.ttf
          weight: 800
        - asset: assets/fonts/DINNextLTArabic-Black.ttf
          weight: 900
""".rstrip() + "\n"

    if "family: DINNextLTArabic" in text:
        print("pubspec.yaml already contains DIN Next LT Arabic.")
        return

    if not text.endswith("\n"):
        text += "\n"
    PUBSPEC.write_text(text.rstrip() + font_block, encoding="utf-8")
    print("Updated pubspec.yaml")


def update_main_theme() -> None:
    text = MAIN.read_text(encoding="utf-8")

    old_patterns = [
        r"fontFamily:\s*'Arial',",
        r'fontFamily:\s*"Arial",',
        r"fontFamily:\s*_language\.rtl\s*\?\s*'DINNextLTArabic'\s*:\s*'Arial',",
    ]
    replacement = "fontFamily: _language.rtl ? 'DINNextLTArabic' : 'Arial',"

    updated = text
    for pattern in old_patterns:
        updated, count = re.subn(pattern, replacement, updated, count=1)
        if count:
            break

    if updated == text and replacement not in text:
        raise RuntimeError("Could not locate ThemeData fontFamily in lib/main.dart.")

    MAIN.write_text(updated, encoding="utf-8")
    print("Updated lib/main.dart")


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Install DIN Next LT Arabic into the EMAN Flutter project."
    )
    parser.add_argument("zip_file", type=Path, help="Path to the DIN font ZIP file")
    args = parser.parse_args()

    if not args.zip_file.is_file():
        print(f"ZIP file not found: {args.zip_file}", file=sys.stderr)
        return 1
    if not PUBSPEC.is_file() or not MAIN.is_file():
        print("Run this script from the project root.", file=sys.stderr)
        return 1

    extract_fonts(args.zip_file)
    update_pubspec()
    update_main_theme()

    print("\nDIN Next LT Arabic installation completed.")
    print("Next run: flutter pub get && dart format lib/main.dart && flutter analyze")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
