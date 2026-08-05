import 'dart:async';

import 'package:flutter/material.dart';

class LiveAnalyticsDashboard extends StatefulWidget {
  const LiveAnalyticsDashboard({required this.languageCode, super.key});

  final String languageCode;

  @override
  State<LiveAnalyticsDashboard> createState() =>
      _LiveAnalyticsDashboardState();
}

class _LiveAnalyticsDashboardState extends State<LiveAnalyticsDashboard> {
  Timer? _timer;
  DateTime _lastUpdated = DateTime.now();

  String _tx({required String tr, required String ar, required String en}) {
    return switch (widget.languageCode) {
      'tr' => tr,
      'ar' => ar,
      _ => en,
    };
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() => _lastUpdated = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metrics = <_Metric>[
      _Metric(
        title: _tx(tr: 'Günlük satış', ar: 'مبيعات اليوم', en: 'Today sales'),
        value: r'$84,250',
        change: '+12.4%',
        icon: Icons.trending_up_rounded,
        color: const Color(0xFF159776),
      ),
      _Metric(
        title: _tx(tr: 'Üretim verimi', ar: 'كفاءة الإنتاج', en: 'Production efficiency'),
        value: '91.8%',
        change: '+3.1%',
        icon: Icons.precision_manufacturing_rounded,
        color: const Color(0xFF0879B8),
      ),
      _Metric(
        title: _tx(tr: 'Aktif sipariş', ar: 'الطلبات النشطة', en: 'Active orders'),
        value: '128',
        change: '9 urgent',
        icon: Icons.receipt_long_rounded,
        color: const Color(0xFFE87A35),
      ),
      _Metric(
        title: _tx(tr: 'Stok uyarısı', ar: 'تنبيهات المخزون', en: 'Stock alerts'),
        value: '14',
        change: '4 critical',
        icon: Icons.inventory_2_rounded,
        color: const Color(0xFFD94F70),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tx(
            tr: 'Canlı analizler',
            ar: 'التحليلات المباشرة',
            en: 'Live analytics',
          ),
        ),
        actions: [
          IconButton(
            tooltip: _tx(tr: 'Yenile', ar: 'تحديث', en: 'Refresh'),
            onPressed: () => setState(() => _lastUpdated = DateTime.now()),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(() => _lastUpdated = DateTime.now()),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _Header(languageCode: widget.languageCode, updated: _lastUpdated),
            const SizedBox(height: 22),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 1100
                    ? 4
                    : constraints.maxWidth >= 650
                        ? 2
                        : 1;
                const gap = 16.0;
                final width =
                    (constraints.maxWidth - gap * (columns - 1)) / columns;
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    for (final metric in metrics)
                      SizedBox(width: width, child: _MetricCard(metric: metric)),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 900;
                final production = _TrendPanel(
                  title: _tx(
                    tr: 'Üretim performansı',
                    ar: 'أداء الإنتاج',
                    en: 'Production performance',
                  ),
                  values: const [62, 74, 71, 82, 88, 84, 92],
                  color: const Color(0xFF0879B8),
                );
                final sales = _TrendPanel(
                  title: _tx(
                    tr: 'Satış trendi',
                    ar: 'اتجاه المبيعات',
                    en: 'Sales trend',
                  ),
                  values: const [44, 58, 53, 68, 76, 83, 90],
                  color: const Color(0xFF159776),
                );
                return wide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: production),
                          const SizedBox(width: 16),
                          Expanded(child: sales),
                        ],
                      )
                    : Column(
                        children: [production, const SizedBox(height: 16), sales],
                      );
              },
            ),
            const SizedBox(height: 24),
            _OperationsPanel(languageCode: widget.languageCode),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.languageCode, required this.updated});

  final String languageCode;
  final DateTime updated;

  String _tx({required String tr, required String ar, required String en}) {
    return switch (languageCode) {
      'tr' => tr,
      'ar' => ar,
      _ => en,
    };
  }

  @override
  Widget build(BuildContext context) {
    final time = '${updated.hour.toString().padLeft(2, '0')}:${updated.minute.toString().padLeft(2, '0')}';
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF062A44), Color(0xFF0879B8)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 14,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _tx(
                  tr: 'EMAN ONE operasyon görünümü',
                  ar: 'نظرة تشغيلية شاملة لـ EMAN ONE',
                  en: 'EMAN ONE operational overview',
                ),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                _tx(
                  tr: 'Satış, üretim, stok ve siparişleri tek ekrandan izleyin.',
                  ar: 'تابع المبيعات والإنتاج والمخزون والطلبات من شاشة واحدة.',
                  en: 'Monitor sales, production, stock and orders in one view.',
                ),
                style: TextStyle(color: Colors.white.withValues(alpha: .82)),
              ),
            ],
          ),
          Chip(
            avatar: const Icon(Icons.sync_rounded, size: 18),
            label: Text(
              '${_tx(tr: 'Güncellendi', ar: 'آخر تحديث', en: 'Updated')} $time',
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric {
  const _Metric({
    required this.title,
    required this.value,
    required this.change,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final String change;
  final IconData icon;
  final Color color;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});
  final _Metric metric;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: metric.color.withValues(alpha: .13),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(metric.icon, color: metric.color),
                ),
                const Spacer(),
                Text(
                  metric.change,
                  style: TextStyle(
                    color: metric.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(metric.value, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 6),
            Text(metric.title),
          ],
        ),
      ),
    );
  }
}

class _TrendPanel extends StatelessWidget {
  const _TrendPanel({
    required this.title,
    required this.values,
    required this.color,
  });

  final String title;
  final List<int> values;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final maxValue = values.reduce((a, b) => a > b ? a : b).toDouble();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 22),
            SizedBox(
              height: 190,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final value in values)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          height: 28 + 145 * value / maxValue,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: .86),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OperationsPanel extends StatelessWidget {
  const _OperationsPanel({required this.languageCode});
  final String languageCode;

  String _tx({required String tr, required String ar, required String en}) {
    return switch (languageCode) {
      'tr' => tr,
      'ar' => ar,
      _ => en,
    };
  }

  @override
  Widget build(BuildContext context) {
    final rows = [
      (Icons.precision_manufacturing_rounded, _tx(tr: 'Makineler çalışıyor', ar: 'الآلات قيد التشغيل', en: 'Machines running'), '7 / 8', const Color(0xFF159776)),
      (Icons.groups_rounded, _tx(tr: 'Aktif çalışanlar', ar: 'الموظفون الموجودون', en: 'Employees present'), '84', const Color(0xFF0879B8)),
      (Icons.local_shipping_rounded, _tx(tr: 'Sevkiyat bekleyen', ar: 'بانتظار الشحن', en: 'Awaiting shipment'), '21', const Color(0xFFE87A35)),
      (Icons.warning_amber_rounded, _tx(tr: 'Geciken işler', ar: 'الأعمال المتأخرة', en: 'Delayed jobs'), '6', const Color(0xFFD94F70)),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _tx(tr: 'Operasyon durumu', ar: 'حالة التشغيل', en: 'Operations status'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 14),
            for (final row in rows)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: row.$4.withValues(alpha: .13),
                  child: Icon(row.$1, color: row.$4),
                ),
                title: Text(row.$2),
                trailing: Text(
                  row.$3,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
