from pathlib import Path

TARGET = Path("lib/screens/admin/admin_control_center.dart")


def main() -> None:
    source = TARGET.read_text(encoding="utf-8")

    import_line = "import 'theme_settings_screen.dart';"
    anchor_import = "import 'role_permission_matrix_screen.dart';"
    if import_line not in source:
        if anchor_import not in source:
            raise SystemExit("Admin import anchor not found")
        source = source.replace(
            anchor_import,
            f"{anchor_import}\n{import_line}",
            1,
        )

    if "ThemeSettingsScreen(languageCode: languageCode)" not in source:
        anchor = """      _AdminSection(
        title: _tx(tr: 'Modüller', ar: 'الوحدات', en: 'Modules'),
"""
        card = """      _AdminSection(
        title: _tx(
          tr: 'Görünüm',
          ar: 'المظهر والثيم',
          en: 'Appearance',
        ),
        subtitle: _tx(
          tr: 'Tema, vurgu rengi ve arayüz yoğunluğunu ayarlayın',
          ar: 'تخصيص الثيم واللون الرئيسي وكثافة الواجهة',
          en: 'Customize theme, accent color and interface density',
        ),
        icon: Icons.palette_rounded,
        accent: const Color(0xFF7657D9),
        onTap: () => _open(
          context,
          ThemeSettingsScreen(languageCode: languageCode),
        ),
      ),
"""
        if anchor not in source:
            raise SystemExit("Module card anchor not found")
        source = source.replace(anchor, card + anchor, 1)

    TARGET.write_text(source, encoding="utf-8")
    print("Appearance settings connected to admin control center")


if __name__ == "__main__":
    main()
