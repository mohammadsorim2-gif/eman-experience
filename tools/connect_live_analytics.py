from pathlib import Path

TARGET = Path("lib/screens/admin/admin_control_center.dart")


def ensure_import(source: str, import_line: str) -> str:
    if import_line in source:
        return source
    anchor = "import 'package:flutter/material.dart';"
    if anchor not in source:
        raise SystemExit("Material import not found")
    return source.replace(anchor, f"{anchor}\n\n{import_line}", 1)


def main() -> None:
    source = TARGET.read_text(encoding="utf-8")
    source = ensure_import(
        source,
        "import '../analytics/live_analytics_dashboard.dart';",
    )

    if "LiveAnalyticsDashboard(" in source:
        print("Live analytics is already connected")
        return

    marker = "final tools = ["
    if marker not in source:
        raise SystemExit("Admin tool list was not found")

    entry = """      _AdminTool(
        title: _tx(
          tr: 'Canlı analizler',
          ar: 'التحليلات المباشرة',
          en: 'Live analytics',
        ),
        subtitle: _tx(
          tr: 'Satış, üretim, stok ve operasyon göstergeleri',
          ar: 'مؤشرات المبيعات والإنتاج والمخزون والتشغيل',
          en: 'Sales, production, stock and operations indicators',
        ),
        icon: Icons.analytics_rounded,
        color: const Color(0xFF0879B8),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => LiveAnalyticsDashboard(
              languageCode: languageCode,
            ),
          ),
        ),
      ),
"""
    source = source.replace(marker, marker + "\n" + entry, 1)
    TARGET.write_text(source, encoding="utf-8")
    print("Live analytics connected to admin control center")


if __name__ == "__main__":
    main()
