from pathlib import Path

MAIN = Path("lib/main.dart")


def ensure_import(source: str, import_line: str, anchor: str) -> str:
    if import_line in source:
        return source
    if anchor not in source:
        raise SystemExit(f"Import anchor not found: {anchor}")
    return source.replace(anchor, f"{anchor}\n{import_line}", 1)


def main() -> None:
    source = MAIN.read_text(encoding="utf-8")

    source = ensure_import(
        source,
        "import 'screens/admin/admin_control_center.dart';",
        "import 'screens/executive/advanced_executive_dashboard.dart';",
    )

    old_page = "    LocalizedAdminDashboard(),"
    new_page = "    AdminControlCenter(languageCode: 'en'),"

    if old_page in source:
        source = source.replace(old_page, new_page, 1)
    elif "AdminControlCenter(" not in source:
        raise SystemExit("Admin dashboard entry was not found in lib/main.dart")

    # Make the admin page language-aware instead of using a static const page list.
    source = source.replace(
        "  static const pages = [",
        "  List<Widget> get pages => [",
        1,
    )
    source = source.replace(
        "    AdminControlCenter(languageCode: 'en'),",
        "    AdminControlCenter(languageCode: widget.language.code),",
        1,
    )

    MAIN.write_text(source, encoding="utf-8")
    print("Admin control center activated in lib/main.dart")


if __name__ == "__main__":
    main()
