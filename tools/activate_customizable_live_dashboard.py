#!/usr/bin/env python3
from pathlib import Path

DASHBOARD = Path('lib/screens/analytics/live_analytics_dashboard.dart')

if not DASHBOARD.exists():
    raise SystemExit(f'Missing {DASHBOARD}')

text = DASHBOARD.read_text(encoding='utf-8')

import_line = "import '../../core/dashboard/dashboard_layout_controller.dart';\n"
if import_line not in text:
    marker = "import 'package:flutter/material.dart';\n"
    text = text.replace(marker, marker + '\n' + import_line, 1)

old_init = """  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
"""
new_init = """  @override
  void initState() {
    super.initState();
    DashboardLayoutController.instance.initialize();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
"""
if old_init in text:
    text = text.replace(old_init, new_init, 1)

old_metrics = """    final metrics = <_Metric>[
"""
new_metrics = """    final layoutController = DashboardLayoutController.instance;
    final metricsById = <String, _Metric>{
"""
if old_metrics in text:
    text = text.replace(old_metrics, new_metrics, 1)

text = text.replace(
    """      _Metric(
        title: _tx(tr: 'Günlük satış', ar: 'مبيعات اليوم', en: 'Today sales'),
""",
    """      'sales': _Metric(
        title: _tx(tr: 'Günlük satış', ar: 'مبيعات اليوم', en: 'Today sales'),
""",
    1,
)
text = text.replace(
    """      _Metric(
        title: _tx(tr: 'Üretim verimi', ar: 'كفاءة الإنتاج', en: 'Production efficiency'),
""",
    """      'production': _Metric(
        title: _tx(tr: 'Üretim verimi', ar: 'كفاءة الإنتاج', en: 'Production efficiency'),
""",
    1,
)
text = text.replace(
    """      _Metric(
        title: _tx(tr: 'Aktif sipariş', ar: 'الطلبات النشطة', en: 'Active orders'),
""",
    """      'orders': _Metric(
        title: _tx(tr: 'Aktif sipariş', ar: 'الطلبات النشطة', en: 'Active orders'),
""",
    1,
)
text = text.replace(
    """      _Metric(
        title: _tx(tr: 'Stok uyarısı', ar: 'تنبيهات المخزون', en: 'Stock alerts'),
""",
    """      'inventory': _Metric(
        title: _tx(tr: 'Stok uyarısı', ar: 'تنبيهات المخزون', en: 'Stock alerts'),
""",
    1,
)

closing = """    ];

    return Scaffold(
"""
replacement = """    };

    return AnimatedBuilder(
      animation: layoutController,
      builder: (context, _) {
        final metrics = <_Metric>[
          for (final id in layoutController.visibleWidgetIds)
            if (metricsById[id] case final metric?) metric,
        ];
        return Scaffold(
"""
if closing in text:
    text = text.replace(closing, replacement, 1)

end_marker = """      ),
    );
  }
}

class _Header"""
end_replacement = """      ),
        );
      },
    );
  }
}

class _Header"""
if end_marker in text:
    text = text.replace(end_marker, end_replacement, 1)

DASHBOARD.write_text(text, encoding='utf-8')
print('Activated persistent dashboard layout in live analytics dashboard')
