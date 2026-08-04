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
        "import 'screens/admin/guided_admin_control_center.dart';",
        "import 'screens/executive/advanced_executive_dashboard.dart';",
    )

    source = source.replace(
        "import 'screens/admin/admin_control_center.dart';\n",
        "",
    )

    old_pages = (
        "    LocalizedAdminDashboard(),",
        "    AdminControlCenter(languageCode: 'en'),",
        "    AdminControlCenter(languageCode: widget.language.code),",
    )
    replacement = (
        "    GuidedAdminControlCenter(languageCode: widget.language.code),"
    )

    replaced = False
    for old_page in old_pages:
        if old_page in source:
            source = source.replace(old_page, replacement, 1)
            replaced = True
            break

    if not replaced and "GuidedAdminControlCenter(" not in source:
        raise SystemExit("Admin dashboard entry was not found in lib/main.dart")

    source = source.replace(
        "  static const pages = [",
        "  List<Widget> get pages => [",
        1,
    )

    MAIN.write_text(source, encoding="utf-8")
    print("Guided admin control center activated in lib/main.dart")


if __name__ == "__main__":
    main()
