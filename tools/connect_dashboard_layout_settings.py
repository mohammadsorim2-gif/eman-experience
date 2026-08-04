from pathlib import Path

ADMIN_FILE = Path("lib/screens/admin/admin_control_center.dart")
IMPORT_LINE = "import 'dashboard_layout_settings_screen.dart';\n"


def main() -> None:
    source = ADMIN_FILE.read_text(encoding="utf-8")

    if IMPORT_LINE not in source:
        marker = "import 'theme_settings_screen.dart';\n"
        if marker in source:
            source = source.replace(marker, marker + IMPORT_LINE, 1)
        else:
            source = IMPORT_LINE + source

    route_code = """
  void _openDashboardLayoutSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DashboardLayoutSettingsScreen(
          languageCode: languageCode,
        ),
      ),
    );
  }
"""

    if "_openDashboardLayoutSettings" not in source:
        class_marker = "class _AdminControlCenterState extends State<AdminControlCenter> {\n"
        if class_marker in source:
            source = source.replace(class_marker, class_marker + route_code, 1)
        else:
            raise SystemExit("Admin control center state class not found")

    if "Icons.dashboard_customize_rounded" not in source:
        tool_marker = "final tools = <_AdminTool>[\n"
        tool_entry = """      _AdminTool(
        icon: Icons.dashboard_customize_rounded,
        color: const Color(0xFF7657D9),
        title: _tx(
          tr: 'Panel düzeni',
          ar: 'تخصيص لوحة التحكم',
          en: 'Dashboard layout',
        ),
        subtitle: _tx(
          tr: 'Kartları sıralayın ve görünürlüğü yönetin',
          ar: 'رتّب البطاقات وتحكم بإظهارها',
          en: 'Reorder cards and manage visibility',
        ),
        onTap: () => _openDashboardLayoutSettings(context),
      ),
"""
        if tool_marker in source:
            source = source.replace(tool_marker, tool_marker + tool_entry, 1)
        else:
            raise SystemExit("Admin tools list not found")

    ADMIN_FILE.write_text(source, encoding="utf-8")
    print("Dashboard layout settings connected to admin control center")


if __name__ == "__main__":
    main()
