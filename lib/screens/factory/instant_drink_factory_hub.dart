import 'package:flutter/material.dart';

import '../executive/executive_factory_dashboard.dart';
import '../inventory/instant_drink_materials_screen.dart';
import '../maintenance/preventive_maintenance_screen.dart';
import '../operations/finished_goods_shipping_screen.dart';
import '../operations/instant_drink_recipe_screen.dart';
import '../operations/machine_fleet_screen.dart';
import '../operations/sales_orders_screen.dart';
import '../production/instant_drink_batch_screen.dart';
import '../quality/instant_drink_quality_screen.dart';
import '../warehouse/barcode_warehouse_screen.dart';

class InstantDrinkFactoryHub extends StatelessWidget {
  const InstantDrinkFactoryHub({required this.languageCode, super.key});

  final String languageCode;

  String _tx(String ar, String tr, String en) => switch (languageCode) {
        'ar' => ar,
        'tr' => tr,
        _ => en,
      };

  @override
  Widget build(BuildContext context) {
    final modules = <_FactoryModule>[
      _FactoryModule(
        title: _tx('لوحة المدير التنفيذي', 'Yönetici paneli', 'Executive dashboard'),
        subtitle: _tx('الإنتاج والكفاءة والمبيعات والتنبيهات المباشرة', 'Üretim, verimlilik, satış ve canlı uyarılar', 'Production, efficiency, sales and live alerts'),
        icon: Icons.insights_rounded,
        builder: () => ExecutiveFactoryDashboard(languageCode: languageCode),
      ),
      _FactoryModule(
        title: _tx('خطوط ومحطات الإنتاج', 'Üretim hatları', 'Production lines'),
        subtitle: _tx('الخلط والتعبئة والتغليف وحالة التشغيل', 'Karıştırma, dolum ve paketleme', 'Mixing, filling, packing and line status'),
        icon: Icons.precision_manufacturing_rounded,
        builder: () => MachineFleetScreen(languageCode: languageCode),
      ),
      _FactoryModule(
        title: _tx('دفعات الإنتاج', 'Üretim partileri', 'Production batches'),
        subtitle: _tx('متابعة الدفعات ونسب الإنجاز ومراحل التشغيل', 'Parti ve üretim aşamalarını takip edin', 'Track batches, progress and production stages'),
        icon: Icons.factory_rounded,
        builder: () => InstantDrinkBatchScreen(languageCode: languageCode),
      ),
      _FactoryModule(
        title: _tx('الوصفات والتركيبات', 'Reçeteler', 'Recipes and formulas'),
        subtitle: _tx('إدارة النكهات والأوزان وتركيبة كل دفعة', 'Aroma, gramaj ve formül yönetimi', 'Manage flavors, weights and batch formulas'),
        icon: Icons.science_rounded,
        builder: () => InstantDrinkRecipeScreen(languageCode: languageCode),
      ),
      _FactoryModule(
        title: _tx('الجودة والمختبر', 'Kalite ve laboratuvar', 'Quality and laboratory'),
        subtitle: _tx('فحص الطعم واللون والوزن والإغلاق والذوبان', 'Tat, renk, ağırlık ve çözünürlük kontrolleri', 'Taste, color, weight, seal and solubility checks'),
        icon: Icons.verified_rounded,
        builder: () => InstantDrinkQualityScreen(languageCode: languageCode),
      ),
      _FactoryModule(
        title: _tx('مخزون المواد', 'Malzeme stoğu', 'Materials inventory'),
        subtitle: _tx('المواد الخام والنكهات ومواد التغليف والتنبيهات', 'Hammadde, aroma ve ambalaj stokları', 'Raw materials, flavors, packaging and alerts'),
        icon: Icons.inventory_2_rounded,
        builder: () => InstantDrinkMaterialsScreen(languageCode: languageCode),
      ),
      _FactoryModule(
        title: _tx('مستودع الباركود', 'Barkod deposu', 'Barcode warehouse'),
        subtitle: _tx('الاستلام والصرف والجرد والشحن بالباركود وQR', 'Barkod ve QR ile giriş, çıkış, sayım ve sevkiyat', 'Receive, issue, count and ship with barcode and QR'),
        icon: Icons.qr_code_scanner_rounded,
        builder: () => BarcodeWarehouseScreen(languageCode: languageCode),
      ),
      _FactoryModule(
        title: _tx('طلبات المبيعات', 'Satış siparişleri', 'Sales orders'),
        subtitle: _tx('ربط طلبات العملاء بالإنتاج والجاهزية', 'Siparişleri üretim ve hazırlıkla bağlayın', 'Connect customer orders to production and readiness'),
        icon: Icons.receipt_long_rounded,
        builder: () => SalesOrdersScreen(languageCode: languageCode),
      ),
      _FactoryModule(
        title: _tx('المنتج النهائي والشحن', 'Bitmiş ürün ve sevkiyat', 'Finished goods and shipping'),
        subtitle: _tx('اللوطات والكراتين والطبليات والتحميل', 'Lot, koli, palet ve yükleme', 'Lots, cartons, pallets and loading'),
        icon: Icons.local_shipping_rounded,
        builder: () => FinishedGoodsShippingScreen(languageCode: languageCode),
      ),
      _FactoryModule(
        title: _tx('الصيانة الوقائية', 'Önleyici bakım', 'Preventive maintenance'),
        subtitle: _tx('مهام الصيانة والاستحقاقات والأولويات وحالة الإنجاز', 'Bakım görevleri, tarihler, öncelikler ve durum', 'Maintenance tasks, due dates, priorities and completion'),
        icon: Icons.build_circle_rounded,
        builder: () => PreventiveMaintenanceScreen(languageCode: languageCode),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_tx('نظام إدارة معمل العصير', 'İçecek fabrikası yönetimi', 'Instant drink factory management')),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 1200
              ? 3
              : constraints.maxWidth >= 760
                  ? 2
                  : 1;
          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: columns == 1 ? 2.3 : 1.35,
            ),
            itemCount: modules.length,
            itemBuilder: (context, index) {
              final module = modules[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => module.builder()),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(radius: 25, child: Icon(module.icon)),
                        const Spacer(),
                        Text(module.title, style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(module.subtitle, maxLines: 3, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Text(_tx('فتح القسم', 'Bölümü aç', 'Open module')),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_rounded),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _FactoryModule {
  const _FactoryModule({required this.title, required this.subtitle, required this.icon, required this.builder});

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget Function() builder;
}
