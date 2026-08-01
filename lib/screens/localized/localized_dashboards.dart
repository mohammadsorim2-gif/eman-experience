import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/app_i18n.dart';

String _l(BuildContext context, String tr, String en, String ar) {
  final code = AppLocaleScope.of(context).languageCode;
  return switch (code) {
    'en' => en,
    'ar' => ar,
    _ => tr,
  };
}

class LocalizedPartnerDashboard extends StatelessWidget {
  const LocalizedPartnerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = [
      (_l(context, 'Toplam Potansiyel Müşteri', 'Total Leads', 'إجمالي العملاء المحتملين'), '27', Icons.groups_outlined),
      (_l(context, 'Açık Fırsatlar', 'Open Deals', 'الصفقات المفتوحة'), '9', Icons.handshake_outlined),
      (_l(context, 'Kapanan Fırsatlar', 'Closed Deals', 'الصفقات المكتملة'), '4', Icons.verified_outlined),
      (_l(context, 'Komisyon', 'Commission', 'العمولة'), r'$3,850', Icons.payments_outlined),
    ];
    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        Text(_l(context, 'Satış Ortağı Paneli', 'Partner Dashboard', 'لوحة شريك المبيعات'), style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: EmanExperienceApp.navy)),
        const SizedBox(height: 8),
        Text(_l(context, 'Hoş geldiniz, sertifikalı EMAN satış ortağı.', 'Welcome, certified EMAN sales partner.', 'مرحبًا بك، شريك مبيعات EMAN المعتمد.'), style: const TextStyle(fontSize: 17, color: Color(0xFF627684))),
        const SizedBox(height: 28),
        LayoutBuilder(builder: (context, c) {
          final w = c.maxWidth >= 900 ? (c.maxWidth - 54) / 4 : c.maxWidth >= 520 ? (c.maxWidth - 18) / 2 : c.maxWidth;
          return Wrap(spacing: 18, runSpacing: 18, children: stats.map((s) => SizedBox(width: w, child: _Metric(title: s.$1, value: s.$2, icon: s.$3))).toList());
        }),
        const SizedBox(height: 24),
        Card(child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_l(context, 'Kişisel Referans Bağlantınız', 'Your Referral Link', 'رابط الإحالة الخاص بك'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 14),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFF1F7FC), borderRadius: BorderRadius.circular(16)), child: Row(children: [
            const Expanded(child: SelectableText('https://emanagro.com/partner/EMAN-MH-2026', style: TextStyle(fontWeight: FontWeight.w700))),
            IconButton(onPressed: () {}, icon: const Icon(Icons.copy)),
            FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.share), label: Text(_l(context, 'Paylaş', 'Share', 'مشاركة'))),
          ])),
        ]))),
        const SizedBox(height: 24),
        Card(child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_l(context, 'Son Potansiyel Müşteriler', 'Recent Leads', 'أحدث العملاء المحتملين'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          _Lead(company: 'Atlas Distribution', country: 'Morocco', stage: _l(context, 'Teklif', 'Quotation', 'عرض سعر'), value: r'$24,000'),
          const Divider(),
          _Lead(company: 'Nova Market Group', country: 'Brazil', stage: _l(context, 'Görüşme', 'Negotiation', 'تفاوض'), value: r'$41,500'),
          const Divider(),
          _Lead(company: 'Golden Foods', country: 'Saudi Arabia', stage: _l(context, 'Yeni', 'New lead', 'جديد'), value: _l(context, 'Bekliyor', 'Pending', 'قيد الانتظار')),
        ]))),
      ],
    );
  }
}

class LocalizedFactoryDashboard extends StatelessWidget {
  const LocalizedFactoryDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final modules = [
      (_l(context, 'Üretim Planlama', 'Production Planning', 'تخطيط الإنتاج'), Icons.calendar_month_outlined),
      (_l(context, 'Hammadde', 'Raw Materials', 'المواد الخام'), Icons.inventory_outlined),
      (_l(context, 'Kalite ve Laboratuvar', 'Quality & Laboratory', 'الجودة والمختبر'), Icons.science_outlined),
      (_l(context, 'Paketleme', 'Packaging', 'التعبئة والتغليف'), Icons.all_inbox_outlined),
      (_l(context, 'Depo', 'Warehouse', 'المستودع'), Icons.warehouse_outlined),
      (_l(context, 'Bakım', 'Maintenance', 'الصيانة'), Icons.handyman_outlined),
      (_l(context, 'Çalışanlar', 'Employees', 'الموظفون'), Icons.badge_outlined),
      (_l(context, 'Sevkiyat', 'Shipping', 'الشحن'), Icons.local_shipping_outlined),
    ];
    return ListView(padding: const EdgeInsets.all(28), children: [
      Text(_l(context, 'EMAN Fabrika Komuta Merkezi', 'EMAN Factory Command Center', 'مركز قيادة معمل EMAN'), style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: EmanExperienceApp.navy)),
      const SizedBox(height: 10),
      Text(_l(context, 'Üretim, kalite, stok, bakım ve sevkiyatın canlı görünümü.', 'Live production, quality, inventory, maintenance and shipment overview.', 'نظرة مباشرة على الإنتاج والجودة والمخزون والصيانة والشحن.'), style: const TextStyle(fontSize: 17, color: Color(0xFF617684))),
      const SizedBox(height: 28),
      Wrap(spacing: 18, runSpacing: 18, children: [
        _Metric(title: _l(context, 'Aktif Üretim Emirleri', 'Active Production Orders', 'أوامر الإنتاج النشطة'), value: '18', icon: Icons.precision_manufacturing_outlined),
        _Metric(title: _l(context, 'Bugünkü Üretim', 'Output Today', 'إنتاج اليوم'), value: '42.8 t', icon: Icons.insights_outlined),
        _Metric(title: _l(context, 'Kalite Başarı Oranı', 'Quality Pass Rate', 'نسبة نجاح الجودة'), value: '98.7%', icon: Icons.verified_outlined),
        _Metric(title: _l(context, 'Sevkiyata Hazır', 'Ready to Ship', 'جاهز للشحن'), value: '11', icon: Icons.local_shipping_outlined),
      ]),
      const SizedBox(height: 26),
      Card(child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(_l(context, 'Canlı Üretim Hatları', 'Live Production Lines', 'خطوط الإنتاج المباشرة'), style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
        const SizedBox(height: 18),
        _ProgressLine(name: 'Powder Line A', order: 'Valore Orange 10 g', value: .78, status: _l(context, 'Çalışıyor', 'Running', 'قيد التشغيل')),
        const Divider(),
        _ProgressLine(name: 'Powder Line B', order: 'Frio Cups Mango 9 g', value: .51, status: _l(context, 'Çalışıyor', 'Running', 'قيد التشغيل')),
        const Divider(),
        _ProgressLine(name: 'Bulk Line', order: 'Roya C Cocktail 2.5 kg', value: .33, status: _l(context, 'Kurulum', 'Setup', 'إعداد')),
      ]))),
      const SizedBox(height: 26),
      LayoutBuilder(builder: (context, c) {
        final cols = c.maxWidth >= 1100 ? 4 : c.maxWidth >= 650 ? 2 : 1;
        final w = (c.maxWidth - (cols - 1) * 18) / cols;
        return Wrap(spacing: 18, runSpacing: 18, children: modules.map((m) => SizedBox(width: w, child: Card(child: Padding(padding: const EdgeInsets.all(22), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(m.$2, color: EmanExperienceApp.blue, size: 32), const SizedBox(height: 16), Text(m.$1, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900))]))))).toList());
      }),
    ]);
  }
}

class LocalizedExecutiveDashboard extends StatelessWidget {
  const LocalizedExecutiveDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(28), children: [
      Text(_l(context, 'EMAN Yönetim Merkezi', 'EMAN Executive Center', 'مركز إدارة EMAN'), style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: EmanExperienceApp.navy)),
      const SizedBox(height: 10),
      Text(_l(context, 'Satış, üretim, sevkiyat ve partner performansını tek ekrandan yönetin.', 'Manage sales, production, shipping and partner performance from one view.', 'أدر المبيعات والإنتاج والشحن وأداء الشركاء من شاشة واحدة.'), style: const TextStyle(fontSize: 17, color: Color(0xFF617684))),
      const SizedBox(height: 28),
      Wrap(spacing: 18, runSpacing: 18, children: [
        _Metric(title: _l(context, 'Aktif Fırsat Değeri', 'Active Pipeline', 'قيمة الصفقات النشطة'), value: r'$2.4M', icon: Icons.trending_up),
        _Metric(title: _l(context, 'Onaylı Siparişler', 'Confirmed Orders', 'الطلبات المؤكدة'), value: '34', icon: Icons.shopping_bag_outlined),
        _Metric(title: _l(context, 'Fabrika Kullanımı', 'Factory Utilization', 'تشغيل المعمل'), value: '87%', icon: Icons.factory_outlined),
        _Metric(title: _l(context, 'Hazır Sevkiyat', 'Ready Shipments', 'الشحنات الجاهزة'), value: '11', icon: Icons.local_shipping_outlined),
      ]),
      const SizedBox(height: 26),
      Card(child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(_l(context, 'Yönetim Öncelikleri', 'Executive Priorities', 'أولويات الإدارة'), style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
        const SizedBox(height: 16),
        _Alert(text: _l(context, 'Sitrik asit stoku güvenlik seviyesinin altında.', 'Citric acid stock is below safety level.', 'مخزون حمض الليمون أقل من مستوى الأمان.')),
        _Alert(text: _l(context, 'Üç parti laboratuvar onayı bekliyor.', 'Three lots are awaiting laboratory approval.', 'ثلاث دفعات تنتظر موافقة المختبر.')),
        _Alert(text: _l(context, 'İki partner komisyonu onay bekliyor.', 'Two partner commissions await approval.', 'عمولتا شريكين بانتظار الموافقة.')),
      ]))),
    ]);
  }
}

class LocalizedAdminDashboard extends StatelessWidget {
  const LocalizedAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(28), children: [
      Text(_l(context, 'Yönetici Paneli', 'Administration', 'لوحة الإدارة'), style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: EmanExperienceApp.navy)),
      const SizedBox(height: 10),
      Text(_l(context, 'Kullanıcılar, roller, partnerler, ürünler ve platform ayarları.', 'Users, roles, partners, products and platform settings.', 'المستخدمون والصلاحيات والشركاء والمنتجات وإعدادات المنصة.'), style: const TextStyle(fontSize: 17, color: Color(0xFF617684))),
      const SizedBox(height: 28),
      Wrap(spacing: 18, runSpacing: 18, children: [
        _Metric(title: _l(context, 'Aktif Kullanıcılar', 'Active Users', 'المستخدمون النشطون'), value: '1,284', icon: Icons.people_outline),
        _Metric(title: _l(context, 'Onay Bekleyen Partnerler', 'Pending Partners', 'الشركاء بانتظار الموافقة'), value: '46', icon: Icons.person_add_alt),
        _Metric(title: _l(context, 'Yönetilen Ürünler', 'Managed Products', 'المنتجات المدارة'), value: '128', icon: Icons.inventory_2_outlined),
      ]),
      const SizedBox(height: 26),
      Card(child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(_l(context, 'Hızlı Yönetim', 'Quick Administration', 'الإدارة السريعة'), style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
        const SizedBox(height: 16),
        ListTile(leading: const Icon(Icons.manage_accounts_outlined), title: Text(_l(context, 'Kullanıcı ve Yetki Yönetimi', 'Users & Permissions', 'إدارة المستخدمين والصلاحيات'))),
        ListTile(leading: const Icon(Icons.inventory_2_outlined), title: Text(_l(context, 'Ürün ve Marka Yönetimi', 'Products & Brands', 'إدارة المنتجات والعلامات'))),
        ListTile(leading: const Icon(Icons.translate), title: Text(_l(context, 'Dil ve İçerik Yönetimi', 'Languages & Content', 'إدارة اللغات والمحتوى'))),
        ListTile(leading: const Icon(Icons.payments_outlined), title: Text(_l(context, 'Komisyon Onayları', 'Commission Approvals', 'موافقات العمولات'))),
      ]))),
    ]);
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.title, required this.value, required this.icon});
  final String title;
  final String value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => SizedBox(width: 250, child: Card(child: Padding(padding: const EdgeInsets.all(22), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: EmanExperienceApp.blue, size: 30), const SizedBox(height: 18), Text(title, style: const TextStyle(color: Color(0xFF677A86))), const SizedBox(height: 6), Text(value, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: EmanExperienceApp.navy))]))));
}

class _Lead extends StatelessWidget {
  const _Lead({required this.company, required this.country, required this.stage, required this.value});
  final String company;
  final String country;
  final String stage;
  final String value;
  @override
  Widget build(BuildContext context) => ListTile(contentPadding: EdgeInsets.zero, leading: const CircleAvatar(child: Icon(Icons.business)), title: Text(company, style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: Text(country), trailing: Wrap(spacing: 12, children: [Chip(label: Text(stage)), Text(value, style: const TextStyle(fontWeight: FontWeight.w900))]));
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({required this.name, required this.order, required this.value, required this.status});
  final String name;
  final String order;
  final double value;
  final String status;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w900))), Chip(label: Text(status))]), Text(order), const SizedBox(height: 8), LinearProgressIndicator(value: value, minHeight: 9, borderRadius: BorderRadius.circular(20)), const SizedBox(height: 5), Text('${(value * 100).round()}%')]);
}

class _Alert extends StatelessWidget {
  const _Alert({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => ListTile(contentPadding: EdgeInsets.zero, leading: const CircleAvatar(backgroundColor: Color(0xFFFFECE8), child: Icon(Icons.priority_high, color: Color(0xFFD74B33))), title: Text(text, style: const TextStyle(fontWeight: FontWeight.w800)));
}
