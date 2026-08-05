from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LIB = ROOT / "lib"
MAIN = LIB / "main.dart"

WEIGHT_REPLACEMENTS = {
    "FontWeight.w900": "FontWeight.w600",
    "FontWeight.w800": "FontWeight.w600",
    "FontWeight.w700": "FontWeight.w600",
}


def update_main_theme() -> None:
    text = MAIN.read_text(encoding="utf-8")

    replacements = {
        "fontFamily: arabic ? 'DINNextLTArabic' : 'NotoSans',":
            "fontFamily: arabic ? 'DINNextLTArabic' : 'NotoSans',",
        "fontFamily: arabic ? 'DINNextLTArabic' : 'NotoSans'":
            "fontFamily: arabic ? 'DINNextLTArabic' : 'NotoSans'",
        "selectedLabelTextStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w800,":
            "selectedLabelTextStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,",
        "unselectedLabelTextStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,":
            "unselectedLabelTextStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,",
    }

    for old, new in replacements.items():
        text = text.replace(old, new)

    # Keep Arabic elegant and lighter, while Latin languages use Noto Sans.
    text = text.replace(
        "fontFamilyFallback: arabic\n",
        "fontFamilyFallback: arabic\n",
    )

    MAIN.write_text(text, encoding="utf-8")


def soften_all_weights() -> tuple[int, int]:
    changed_files = 0
    changed_weights = 0

    for path in LIB.rglob("*.dart"):
        text = path.read_text(encoding="utf-8")
        updated = text

        for old, new in WEIGHT_REPLACEMENTS.items():
            count = updated.count(old)
            if count:
                changed_weights += count
                updated = updated.replace(old, new)

        if updated != text:
            path.write_text(updated, encoding="utf-8")
            changed_files += 1

    return changed_files, changed_weights


def main() -> None:
    if not MAIN.exists():
        raise SystemExit("Run this script from the EMAN project root.")

    update_main_theme()
    changed_files, changed_weights = soften_all_weights()

    print("Global typography applied.")
    print("Arabic: DIN Next LT Arabic")
    print("All other languages: Noto Sans")
    print("Maximum interface weight: 600")
    print(f"Updated {changed_weights} heavy weights across {changed_files} Dart files.")


if __name__ == "__main__":
    main()
