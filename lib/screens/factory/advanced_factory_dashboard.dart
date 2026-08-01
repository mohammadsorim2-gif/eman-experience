import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/app_i18n.dart';

class AdvancedFactoryDashboard extends StatefulWidget {
  const AdvancedFactoryDashboard({super.key});

  @override
  State<AdvancedFactoryDashboard> createState() => _AdvancedFactoryDashboardState();
}

class _AdvancedFactoryDashboardState extends State<AdvancedFactoryDashboard> {
  String selectedView = 'overview';

  String tx(BuildContext context, String key) {
    final code = AppLocaleScope.of(context).languageCode;
    const values = <String, Map<String, String>>{
      'title': {'tr': 'EMAN Fabrika Komuta Merkezi', 'en': 'EMAN Factory Command Center', 'ar': 'مركز قيادة معمل EMAN'},
      'subtitle': {'tr': 'Üretim, kalite, stok, bakım ve sevkiyat tek ekranda.', 'en': 'Production, quality, inventory, maintenance and shipping in one view.', 'ar': 'الإنتاج والجودة والمخزون والصيانة والشحن في شاشة واحدة.'},
      'online': {'tr': 'Fabrika çevrimiçi', 'en': 'Factory online', 'ar': 'المعمل متصل'},
      'overview': {'tr': 'Genel Bakış', 'en': 'Overview', 'ar': 'نظرة عامة'},
      'production': {'tr': 'Üretim', 'en': 'Production', 'ar': 'الإنتاج'},
      'quality': {'tr': 'Kalite', 'en': 'Quality', 'ar': 'الجودة'},
      'warehouse': {'tr': 'Depo', 'en': 'Warehouse', 'ar': 'المستودع'},
      'maintenance': {'tr': 'Bakım', 'en': 'Maintenance', 'ar': 'الصيانة'},
      'activeOrders': {'tr': 'Aktif üretim emirleri', 'en': 'Active production orders', 'ar': 'أوامر الإنتاج النشطة'},
      'todayOutput': {'tr': 'Bugünkü üretim', 'en': 'Output today', 'ar': 'إنتاج اليوم'},
      'qualityRate': {'tr': 'Kalite başarı oranı', 'en': 'Quality pass rate', 'ar': 'نسبة نجاح الجودة'},
      'readyShip': {'tr': 'Sevkiyata hazır', 'en': 'Ready to ship', 'ar': 'جاهز للشحن'},
      'dueToday': {'tr': '6 sipariş bugün', 'en': '6 due today', 'ar': '6 طلبات اليوم'},
      'plan': {'tr': 'Planın %94’ü', 'en': '94% of plan', 'ar': '94% من الخطة'},
      'hold': {'tr': '3 parti beklemede', 'en': '3 lots on hold', 'ar': '3 دفعات معلّقة'},
      'containers': {'tr': '4 konteyner rezerve', 'en': '4 containers booked', 'ar': '4 حاويات محجوزة'},
      'liveLines': {'tr': 'Canlı üretim hatları', 'en': 'Live production lines', 'ar': 'خطوط الإنتاج المباشرة'},
      'priorityAlerts': {'tr': 'Öncelikli uyarılar', 'en': 'Priority alerts', 'ar': 'تنبيهات ذات أولوية'},
      'operations': {'tr': 'Fabrika modülleri', 'en': 'Factory modules', 'ar': 'وحدات المعمل'},
      'orderFlow': {'tr': 'Bağlantılı sipariş yaşam döngüsü', 'en': 'Connected order lifecycle', 'ar': 'دورة الطلب المترابطة'},
      'running': {'tr': 'Çalışıyor', 'en': 'Running', 'ar': 'يعمل'},
      'setup': {'tr': 'Hazırlık', 'en': 'Setup', 'ar': 'تجهيز'},
      'finishing': {'tr': 'Tamamlanıyor', 'en': 'Finishing', 'ar': 'مرحلة نهائية'},
      'complete': {'tr': 'tamamlandı', 'en': 'complete', 'ar': 'مكتمل'},
      'materials': {'tr': 'Hammadde', 'en': 'Raw materials', 'ar': 'المواد الخام'},
      'packaging': {'tr': 'Paketleme', 'en': 'Packaging', 'ar': 'التعبئة'},
      'employees': {'tr': 'Çalışanlar', 'en': 'Employees', 'ar': 'الموظفون'},
      'shipping': {'tr': 'Sevkiyat', 'en': 'Shipping', 'ar': 'الشحن'},
      'planning': {'tr': 'Üretim planlama', 'en': 'Production planning', 'ar': 'تخطيط الإنتاج'},
      'lab': {'tr': 'Kalite ve laboratuvar', 'en': 'Quality & laboratory', 'ar': 'الجودة والمختبر'},
      'deal': {'tr': 'Satış onayı', 'en': 'Deal won', 'ar': 'اعتماد الصفقة'},
      'manufacturing': {'tr': 'Üretim emri', 'en': 'Manufacturing order', 'ar': 'أمر تصنيع'},
      'reserved': {'tr': 'Malzeme rezervasyonu', 'en': 'Materials reserved', 'ar': 'حجز المواد'},
      'release': {'tr': 'Kalite onayı', 'en': 'Quality release', 'ar': 'اعتماد الجودة'},
      'shipment': {'tr': 'Sevkiyat', 'en': 'Shipment', 'ar': 'الشحن'},
      'commission': {'tr': 'Partner komisyonu', 'en': 'Partner commission', 'ar': 'عمولة الشريك'},
    };
    final item = values[key];
    return item?[code] ?? item?['tr'] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        Wrap(
          spacing: 18,
          runSpacing: 18,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 680,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tx(context, 'title'), style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: EmanExperienceApp.navy)),
                  const SizedBox(height: 10),
                  Text(tx(context, 'subtitle'), style: const TextStyle(fontSize: 17, color: Color(0xFF617684))),
                ],
              ),
            ),
            Chip(avatar: const Icon(Icons.circle, size: 12, color: Color(0xFF16A36A)), label: Text(tx(context, 'online'))),
          ],
        ),
        const SizedBox(height: 22),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'overview', icon: const Icon(Icons.dashboard_outlined), label: Text(tx(context, 'overview'))),
              ButtonSegment(value: 'production', icon: const Icon(Icons.precision_manufacturing_outlined), label: Text(tx(context, 'production'))),
              ButtonSegment(value: 'quality', icon: const Icon(Icons.verified_outlined), label: Text(tx(context, 'quality'))),
              ButtonSegment(value: 'warehouse', icon: const Icon(Icons.warehouse_outlined), label: Text(tx(context, 'warehouse'))),
              ButtonSegment(value: 'maintenance', icon: const Icon(Icons.handyman_outlined), label: Text(tx(context, 'maintenance'))),
            ],
            selected: {selectedView},
            onSelectionChanged: (value) => setState(() => selectedView = value.first),
          ),
        ),
        const SizedBox(height: 24),
        _metrics(context),
        const SizedBox(height: 24),
        LayoutBuilder(builder: (context, constraints) {
          final stacked = constraints.maxWidth < 980;
          final lines = _productionLines(context);
          final alerts = _alerts(context);
          return stacked
              ? Column(children: [lines, const SizedBox(height: 18), alerts])
              : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 3, child: lines), const SizedBox(width: 18), Expanded(flex: 2, child: alerts)]);
        }),
        const SizedBox(height: 24),
        _modules(context),
        const SizedBox(height: 24),
        _flow(context),
      ],
    );
  }

  Widget _metrics(BuildContext context) {
    final items = [
      (tx(context, 'activeOrders'), '18', tx(context, 'dueToday'), Icons.assignment_outlined),
      (tx(context, 'todayOutput'), '42.8 t', tx(context, 'plan'), Icons.insights_outlined),
      (tx(context, 'qualityRate'), '98.7%', tx(context, 'hold'), Icons.verified_outlined),
      (tx(context, 'readyShip'), '11', tx(context, 'containers'), Icons.local_shipping_outlined),
    ];
    return LayoutBuilder(builder: (context, constraints) {
      final columns = constraints.maxWidth >= 1100 ? 4 : constraints.maxWidth >= 620 ? 2 : 1;
      final width = (constraints.maxWidth - (columns - 1) * 18) / columns;
      return Wrap(spacing: 18, runSpacing: 18, children: items.map((item) => SizedBox(width: width, child: Card(child: Padding(padding: const EdgeInsets.all(22), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CircleAvatar(backgroundColor: const Color(0xFFE9F6FF), child: Icon(item.$4, color: EmanExperienceApp.blue)),
        const SizedBox(height: 18), Text(item.$1, style: const TextStyle(color: Color(0xFF677A86))),
        const SizedBox(height: 6), Text(item.$2, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: EmanExperienceApp.navy)),
        const SizedBox(height: 6), Text(item.$3, style: const TextStyle(color: Color(0xFF168A61), fontWeight: FontWeight.w700)),
      ]))))).toList());
    });
  }

  Widget _productionLines(BuildContext context) {
    final lines = [
      ('Powder Line A', 'Valore Orange 10 g', .78, tx(context, 'running')),
      ('Powder Line B', 'Frio Cups Mango 9 g', .51, tx(context, 'running')),
      ('Bulk Line', 'Roya C Cocktail 2.5 kg', .33, tx(context, 'setup')),
      ('Packing Line C', 'Full Fresh Strawberry', .92, tx(context, 'finishing')),
    ];
    return Card(child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(tx(context, 'liveLines'), style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
      const SizedBox(height: 18),
      ...lines.map((line) => Padding(padding: const EdgeInsets.symmetric(vertical: 9), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Expanded(child: Text(line.$1, style: const TextStyle(fontWeight: FontWeight.w900))), Chip(label: Text(line.$4))]),
        Text(line.$2, style: const TextStyle(color: Color(0xFF667985))),
        const SizedBox(height: 9), LinearProgressIndicator(value: line.$3, minHeight: 9, borderRadius: BorderRadius.circular(20)),
        const SizedBox(height: 5), Text('${(line.$3 * 100).round()}% ${tx(context, 'complete')}'),
        const Divider(height: 24),
      ])),
    ])));
  }

  Widget _alerts(BuildContext context) {
    final alerts = [
      (Icons.inventory_2_outlined, 'Citric acid below safety stock', '3.5 days', true),
      (Icons.science_outlined, 'Three lots awaiting laboratory release', 'Quality team notified', false),
      (Icons.build_outlined, 'Packing Line B maintenance due', '18:00', false),
      (Icons.local_shipping_outlined, 'Container confirmation required', 'EX-2048', true),
    ];
    return Card(child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(tx(context, 'priorityAlerts'), style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
      const SizedBox(height: 14),
      ...alerts.map((item) => ListTile(contentPadding: EdgeInsets.zero, leading: CircleAvatar(backgroundColor: item.$4 ? const Color(0xFFFFECE8) : const Color(0xFFEAF6FF), child: Icon(item.$1, color: item.$4 ? const Color(0xFFD74B33) : EmanExperienceApp.blue)), title: Text(item.$2, style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: Text(item.$3))),
    ])));
  }

  Widget _modules(BuildContext context) {
    final items = [
      (tx(context, 'planning'), Icons.calendar_month_outlined),
      (tx(context, 'materials'), Icons.inventory_outlined),
      (tx(context, 'lab'), Icons.science_outlined),
      (tx(context, 'packaging'), Icons.all_inbox_outlined),
      (tx(context, 'warehouse'), Icons.warehouse_outlined),
      (tx(context, 'maintenance'), Icons.handyman_outlined),
      (tx(context, 'employees'), Icons.badge_outlined),
      (tx(context, 'shipping'), Icons.local_shipping_outlined),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(tx(context, 'operations'), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
      const SizedBox(height: 16),
      LayoutBuilder(builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1100 ? 4 : constraints.maxWidth >= 650 ? 2 : 1;
        final width = (constraints.maxWidth - (columns - 1) * 18) / columns;
        return Wrap(spacing: 18, runSpacing: 18, children: items.map((item) => SizedBox(width: width, child: Card(child: InkWell(onTap: () {}, borderRadius: BorderRadius.circular(24), child: Padding(padding: const EdgeInsets.all(22), child: Row(children: [Icon(item.$2, size: 30, color: EmanExperienceApp.blue), const SizedBox(width: 14), Expanded(child: Text(item.$1, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900))), const Icon(Icons.chevron_right)]))))).toList());
      }),
    ]);
  }

  Widget _flow(BuildContext context) {
    final steps = [
      (tx(context, 'deal'), Icons.handshake_outlined),
      (tx(context, 'manufacturing'), Icons.assignment_outlined),
      (tx(context, 'reserved'), Icons.inventory_2_outlined),
      (tx(context, 'production'), Icons.precision_manufacturing_outlined),
      (tx(context, 'release'), Icons.verified_outlined),
      (tx(context, 'warehouse'), Icons.warehouse_outlined),
      (tx(context, 'shipment'), Icons.local_shipping_outlined),
      (tx(context, 'commission'), Icons.payments_outlined),
    ];
    return Card(child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(tx(context, 'orderFlow'), style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
      const SizedBox(height: 18),
      Wrap(spacing: 10, runSpacing: 10, crossAxisAlignment: WrapCrossAlignment.center, children: [for (var i = 0; i < steps.length; i++) ...[Chip(avatar: Icon(steps[i].$2, size: 18), label: Text(steps[i].$1)), if (i != steps.length - 1) const Icon(Icons.arrow_forward, color: Color(0xFF8FA0AA))]]),
    ])));
  }
}
