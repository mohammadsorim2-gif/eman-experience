from pathlib import Path
import re

ROOT = Path("lib")


def clean_underscores(path: Path) -> bool:
    text = path.read_text(encoding="utf-8")
    updated = re.sub(r"\(_,\s*__,\s*___\)", "(_, _, _)", text)
    updated = re.sub(r"\(_,\s*__\)", "(_, _)", updated)
    if updated != text:
        path.write_text(updated, encoding="utf-8")
        return True
    return False


def replace_exact(path: Path, old: str, new: str) -> None:
    text = path.read_text(encoding="utf-8")
    if old not in text:
        raise RuntimeError(f"Expected block not found in {path}")
    path.write_text(text.replace(old, new, 1), encoding="utf-8")


changed = []
for relative in ["app.dart", "app_remote.dart"]:
    path = ROOT / relative
    if path.exists() and clean_underscores(path):
        changed.append(str(path))

replace_exact(
    ROOT / "screens/partner/advanced_partner_dashboard.dart",
    """            if (stacked)\n              return Column(\n                children: [pipeline, const SizedBox(height: 18), side],\n              );\n""",
    """            if (stacked) {\n              return Column(\n                children: [pipeline, const SizedBox(height: 18), side],\n              );\n            }\n""",
)
changed.append("lib/screens/partner/advanced_partner_dashboard.dart")

replace_exact(
    ROOT / "screens/public/localized_commerce_pages.dart",
    """                            onChanged: (value) {\n                              if (value != null)\n                                setState(() => country = value);\n                            },\n""",
    """                            onChanged: (value) {\n                              if (value != null) {\n                                setState(() => country = value);\n                              }\n                            },\n""",
)
changed.append("lib/screens/public/localized_commerce_pages.dart")

print("Lint cleanup completed.")
for item in changed:
    print(f"Updated {item}")
