import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/app_i18n.dart';

class AdvancedExecutiveDashboard extends StatelessWidget {
  const AdvancedExecutiveDashboard({super.key});

  String _tx(BuildContext context, String key) {
    final code = AppLocaleScope.of(context).languageCode;
    const values = <String, Map<String, String>>{
      'title': {
        'tr': 'Yönetim Komuta Merkezi',
        'en': 'Executive Command Center',
        'ar': 'مركز القيادة التنفيذية',
      },
      'subtitle': {
        'tr':
            'Satış, üretim, sevkiyat ve finans performansını tek ekrandan yönetin.',
        'en':
            'Manage sales, production, shipping and financial performance from one view.',
        'ar': 'أدر المبيعات والإنتاج والشحن والأداء المالي من شاشة واحدة.',
      },
      'live': {
        'tr': 'Canlı yönetim görünümü',
        'en': 'Live executive view',
        'ar': 'عرض تنفيذي مباشر',
      },
      'revenue': {
        'tr': 'Aylık satış',
        'en': 'Monthly revenue',
        'ar': 'المبيعات الشهرية',
      },
      'pipeline': {
        'tr': 'Satış fırsatları',
        'en': 'Sales pipeline',
        'ar': 'فرص المبيعات',
      },
      'factory': {
        'tr': 'Fabrika kullanımı',
        'en': 'Factory utilization',
        'ar': 'تشغيل المعمل',
      },
      'shipments': {
        'tr': 'Aktif sevkiyatlar',
        'en': 'Active shipments',
        'ar': 'الشحنات النشطة',
      },
      'markets': {
        'tr': 'Küresel pazar performansı',
        'en': 'Global market performance',
        'ar': 'أداء الأسواق العالمية',
      },
      'operations': {
        'tr': 'Operasyon durumu',
        'en': 'Operations status',
        'ar': 'حالة العمليات',
      },
      'alerts': {
        'tr': 'Yönetim uyarıları',
        'en': 'Executive alerts',
        'ar': 'تنبيهات الإدارة',
      },
      'insights': {
        'tr': 'Yapay zekâ içgörüleri',
        'en': 'AI insights',
        'ar': 'رؤى الذكاء الاصطناعي',
      },
      'sales': {'tr': 'Satış', 'en': 'Sales', 'ar': 'المبيعات'},
      'production': {'tr': 'Üretim', 'en': 'Production', 'ar': 'الإنتاج'},
      'quality': {'tr': 'Kalite', 'en': 'Quality', 'ar': 'الجودة'},
      'inventory': {'tr': 'Stok', 'en': 'Inventory', 'ar': 'المخزون'},
      'shipping': {'tr': 'Sevkiyat', 'en': 'Shipping', 'ar': 'الشحن'},
      'finance': {'tr': 'Finans', 'en': 'Finance', 'ar': 'المالية'},
      'good': {'tr': 'İyi', 'en': 'Good', 'ar': 'جيد'},
      'attention': {'tr': 'Dikkat', 'en': 'Attention', 'ar': 'يحتاج انتباه'},
      'critical': {'tr': 'Kritik', 'en': 'Critical', 'ar': 'حرج'},
      'middleEast': {
        'tr': 'Orta Doğu',
        'en': 'Middle East',
        'ar': 'الشرق الأوسط',
      },
      'europe': {'tr': 'Avrupa', 'en': 'Europe', 'ar': 'أوروبا'},
      'africa': {'tr': 'Afrika', 'en': 'Africa', 'ar': 'أفريقيا'},
      'latam': {
        'tr': 'Latin Amerika',
        'en': 'Latin America',
        'ar': 'أمريكا اللاتينية',
      },
      'alert1': {
        'tr': 'İki büyük teklif yönetim onayı bekliyor.',
        'en': 'Two major quotations are awaiting management approval.',
        'ar': 'عرضا سعر كبيران بانتظار موافقة الإدارة.',
      },
      'alert2': {
        'tr': 'Sitrik asit stoku güvenlik seviyesinin altında.',
        'en': 'Citric acid inventory is below safety level.',
        'ar': 'مخزون حمض الستريك دون مستوى الأمان.',
      },
      'alert3': {
        'tr': 'Dört konteyner için belge onayı gerekiyor.',
        'en': 'Four containers require document approval.',
        'ar': 'أربع حاويات تحتاج اعتماد المستندات.',
      },
      'insight1': {
        'tr':
            'Körfez bölgesinde portakal ve mango ürünlerine talep yükseliyor.',
        'en':
            'Demand for orange and mango products is rising in the Gulf region.',
        'ar': 'الطلب على منتجات البرتقال والمانجو يرتفع في منطقة الخليج.',
      },
      'insight2': {
        'tr': 'Avrupa satışlarında özel marka fırsatları önceliklendirilmeli.',
        'en':
            'Private-label opportunities should be prioritized in European sales.',
        'ar': 'يُنصح بإعطاء أولوية لفرص العلامة الخاصة في المبيعات الأوروبية.',
      },
      'insight3': {
        'tr':
            'Hat B için planlı bakım, gelecek haftaki kapasite riskini azaltır.',
        'en':
            'Planned maintenance for Line B will reduce next week’s capacity risk.',
        'ar':
            'الصيانة المخططة للخط B ستخفّض مخاطر الطاقة الإنتاجية الأسبوع المقبل.',
      },
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
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 760,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _tx(context, 'title'),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                      color: EmanExperienceApp.navy,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _tx(context, 'subtitle'),
                    style: const TextStyle(
                      fontSize: 17,
                      height: 1.5,
                      color: Color(0xFF617684),
                    ),
                  ),
                ],
              ),
            ),
            Chip(
              avatar: const Icon(
                Icons.circle,
                size: 12,
                color: Color(0xFF16A36A),
              ),
              label: Text(_tx(context, 'live')),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _metrics(context),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < 950;
            final markets = _markets(context);
            final operations = _operations(context);
            return stacked
                ? Column(
                    children: [markets, const SizedBox(height: 18), operations],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: markets),
                      const SizedBox(width: 18),
                      Expanded(flex: 2, child: operations),
                    ],
                  );
          },
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < 950;
            final alerts = _alerts(context);
            final insights = _insights(context);
            return stacked
                ? Column(
                    children: [alerts, const SizedBox(height: 18), insights],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: alerts),
                      const SizedBox(width: 18),
                      Expanded(child: insights),
                    ],
                  );
          },
        ),
      ],
    );
  }

  Widget _metrics(BuildContext context) {
    final items = [
      (_tx(context, 'revenue'), '\$4.82M', '+18.4%', Icons.payments_outlined),
      (_tx(context, 'pipeline'), '\$12.6M', '37 RFQ', Icons.trending_up),
      (_tx(context, 'factory'), '86%', '+7%', Icons.factory_outlined),
      (
        _tx(context, 'shipments'),
        '24',
        '11 countries',
        Icons.local_shipping_outlined,
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1100
            ? 4
            : constraints.maxWidth >= 620
            ? 2
            : 1;
        final width = (constraints.maxWidth - ((columns - 1) * 18)) / columns;
        return Wrap(
          spacing: 18,
          runSpacing: 18,
          children: items
              .map(
                (item) => SizedBox(
                  width: width,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFFEAF6FF),
                            child: Icon(item.$4, color: EmanExperienceApp.blue),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            item.$1,
                            style: const TextStyle(color: Color(0xFF677A86)),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.$2,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                              color: EmanExperienceApp.navy,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.$3,
                            style: const TextStyle(
                              color: Color(0xFF168A61),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _markets(BuildContext context) {
    final markets = [
      (_tx(context, 'middleEast'), 0.92, '\$2.1M'),
      (_tx(context, 'europe'), 0.71, '\$1.3M'),
      (_tx(context, 'africa'), 0.58, '\$860K'),
      (_tx(context, 'latam'), 0.43, '\$560K'),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _tx(context, 'markets'),
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            ...markets.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.$1,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(item.$3),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: item.$2,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _operations(BuildContext context) {
    final items = [
      (
        _tx(context, 'sales'),
        _tx(context, 'good'),
        Icons.handshake_outlined,
        const Color(0xFF168A61),
      ),
      (
        _tx(context, 'production'),
        _tx(context, 'good'),
        Icons.precision_manufacturing_outlined,
        const Color(0xFF168A61),
      ),
      (
        _tx(context, 'quality'),
        _tx(context, 'good'),
        Icons.verified_outlined,
        const Color(0xFF168A61),
      ),
      (
        _tx(context, 'inventory'),
        _tx(context, 'attention'),
        Icons.inventory_2_outlined,
        const Color(0xFFE09A24),
      ),
      (
        _tx(context, 'shipping'),
        _tx(context, 'attention'),
        Icons.local_shipping_outlined,
        const Color(0xFFE09A24),
      ),
      (
        _tx(context, 'finance'),
        _tx(context, 'good'),
        Icons.account_balance_outlined,
        const Color(0xFF168A61),
      ),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _tx(context, 'operations'),
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 14),
            ...items.map(
              (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: item.$4.withValues(alpha: .12),
                  child: Icon(item.$3, color: item.$4),
                ),
                title: Text(
                  item.$1,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: Text(
                  item.$2,
                  style: TextStyle(color: item.$4, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _alerts(BuildContext context) {
    final items = [
      (Icons.request_quote_outlined, _tx(context, 'alert1')),
      (Icons.inventory_2_outlined, _tx(context, 'alert2')),
      (Icons.description_outlined, _tx(context, 'alert3')),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _tx(context, 'alerts'),
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 14),
            ...items.map(
              (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFFECE8),
                  child: Icon(Icons.priority_high, color: Color(0xFFD74B33)),
                ),
                title: Text(
                  item.$2,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _insights(BuildContext context) {
    final items = [
      _tx(context, 'insight1'),
      _tx(context, 'insight2'),
      _tx(context, 'insight3'),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: EmanExperienceApp.blue),
                const SizedBox(width: 10),
                Text(
                  _tx(context, 'insights'),
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...items.map(
              (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.arrow_circle_right_outlined,
                  color: EmanExperienceApp.blue,
                ),
                title: Text(item),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
