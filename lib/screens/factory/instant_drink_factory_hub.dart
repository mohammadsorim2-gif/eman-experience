import 'package:flutter/material.dart';

import '../admin/access_control_screen.dart';
import '../admin/admin_tools_hub.dart';
import '../distribution/sales_representatives_screen.dart';
import '../executive/executive_factory_dashboard.dart';
import '../intelligence/demand_forecast_screen.dart';
import '../inventory/instant_drink_materials_screen.dart';
import '../maintenance/preventive_maintenance_screen.dart';
import '../operations/department_hub_screen.dart';
import '../operations/finished_goods_shipping_screen.dart';
import '../operations/instant_drink_recipe_screen.dart';
import '../operations/machine_fleet_screen.dart';
import '../operations/sales_orders_screen.dart';
import '../production/instant_drink_batch_screen.dart';
import '../quality/instant_drink_quality_screen.dart';
import '../traceability/batch_traceability_screen.dart';
import '../warehouse/barcode_warehouse_screen.dart';

class InstantDrinkFactoryHub extends StatelessWidget {
  const InstantDrinkFactoryHub({required this.languageCode, super.key});

  final String languageCode;

  String tx(String ar, String tr, String en) =>
      switch (languageCode) {'ar' => ar, 'tr' => tr, _ => en};

  @override
  Widget build(BuildContext context) {
    final modules = <_FactoryModule>[
      _FactoryModule(tx('لوحة المدير التنفيذي', 'Yönetici paneli', 'Executive dashboard'), tx('الإنتاج والكفاءة والمبيعات والتنبيهات', 'Üretim, verimlilik, satış ve uyarılar', 'Production, efficiency, sales and alerts'), Icons.insights_outlined, const Color(0xFF0F9D78), () => ExecutiveFactoryDashboard(languageCode: languageCode)),
      _FactoryModule(tx('المستخدمون والصلاحيات', 'Kullanıcılar ve yetkiler', 'Users & permissions'), tx('إدارة المستخدمين والأدوار والصلاحيات', 'Kullanıcıları, rolleri ve yetkileri yönetin', 'Manage users, roles and permissions'), Icons.group_outlined, const Color(0xFF2563EB), () => AccessControlScreen(languageCode: languageCode)),
      _FactoryModule(tx('مركز إدارة النظام', 'Sistem yönetim merkezi', 'System administration'), tx('حالة النظام والسجلات والنسخ الاحتياطية', 'Sistem durumu, kayıtlar ve yedekler', 'System status, audit and backups'), Icons.tune_rounded, const Color(0xFF4F46E5), () => AdminToolsHub(languageCode: languageCode)),
      _FactoryModule(tx('مركز الأقسام', 'Bölüm merkezi', 'Department hub'), tx('وصول موحد إلى جميع الأقسام', 'Tüm bölümlere birleşik erişim', 'Unified access to all departments'), Icons.grid_view_rounded, const Color(0xFF0891B2), () => DepartmentHubScreen(languageCode: languageCode)),
      _FactoryModule(tx('خطوط ومحطات الإنتاج', 'Üretim hatları', 'Production lines'), tx('الخلط والتعبئة والتغليف وحالة التشغيل', 'Karıştırma, dolum ve paketleme', 'Mixing, filling, packing and status'), Icons.precision_manufacturing_outlined, const Color(0xFF9333EA), () => MachineFleetScreen(languageCode: languageCode)),
      _FactoryModule(tx('دفعات الإنتاج', 'Üretim partileri', 'Production batches'), tx('متابعة نسب الإنجاز ومراحل التشغيل', 'İlerleme ve üretim aşamaları', 'Progress and production stages'), Icons.inventory_2_outlined, const Color(0xFFF97316), () => InstantDrinkBatchScreen(languageCode: languageCode)),
      _FactoryModule(tx('تتبع الدفعة واللوط', 'Parti ve lot takibi', 'Batch & lot traceability'), tx('من المواد الخام حتى العميل والشحن', 'Hammaddeden müşteriye ve sevkiyata', 'From raw materials to shipping'), Icons.hub_outlined, const Color(0xFF7C3AED), () => BatchTraceabilityScreen(languageCode: languageCode)),
      _FactoryModule(tx('الوصفات والتركيبات', 'Reçeteler', 'Recipes and formulas'), tx('النكهات والأوزان وتركيبة كل دفعة', 'Aroma, gramaj ve parti formülleri', 'Flavors, weights and formulas'), Icons.science_outlined, const Color(0xFFDB2777), () => InstantDrinkRecipeScreen(languageCode: languageCode)),
      _FactoryModule(tx('الجودة والمختبر', 'Kalite ve laboratuvar', 'Quality and laboratory'), tx('فحص الطعم واللون والوزن والذوبان', 'Tat, renk, ağırlık ve çözünürlük', 'Taste, color, weight and solubility'), Icons.verified_outlined, const Color(0xFF16A34A), () => InstantDrinkQualityScreen(languageCode: languageCode)),
      _FactoryModule(tx('مخزون المواد', 'Malzeme stoğu', 'Materials inventory'), tx('المواد الخام والتغليف والتنبيهات', 'Hammadde, ambalaj ve uyarılar', 'Raw materials, packaging and alerts'), Icons.warehouse_outlined, const Color(0xFF0D9488), () => InstantDrinkMaterialsScreen(languageCode: languageCode)),
      _FactoryModule(tx('مستودع الباركود', 'Barkod deposu', 'Barcode warehouse'), tx('الاستلام والصرف والجرد والشحن', 'Giriş, çıkış, sayım ve sevkiyat', 'Receive, issue, count and ship'), Icons.qr_code_scanner_rounded, const Color(0xFF0284C7), () => BarcodeWarehouseScreen(languageCode: languageCode)),
      _FactoryModule(tx('طلبات المبيعات', 'Satış siparişleri', 'Sales orders'), tx('ربط طلبات العملاء بالإنتاج والجاهزية', 'Siparişleri üretimle bağlayın', 'Connect orders to production'), Icons.receipt_long_outlined, const Color(0xFFEA580C), () => SalesOrdersScreen(languageCode: languageCode)),
      _FactoryModule(tx('المندوبون وخطوط السير', 'Satış temsilcileri', 'Sales representatives'), tx('الأهداف والزيارات والتحصيل والمسارات', 'Hedefler, ziyaretler ve rotalar', 'Targets, visits and routes'), Icons.route_outlined, const Color(0xFF059669), () => SalesRepresentativesScreen(languageCode: languageCode)),
      _FactoryModule(tx('المنتج النهائي والشحن', 'Bitmiş ürün ve sevkiyat', 'Finished goods & shipping'), tx('اللوطات والكراتين والطبليات والتحميل', 'Lotlar, koliler, paletler ve yükleme', 'Lots, cartons, pallets and loading'), Icons.local_shipping_outlined, const Color(0xFF2563EB), () => FinishedGoodsShippingScreen(languageCode: languageCode)),
      _FactoryModule(tx('الصيانة الوقائية', 'Önleyici bakım', 'Preventive maintenance'), tx('المهام والاستحقاقات والأولويات', 'Görevler, tarihler ve öncelikler', 'Tasks, due dates and priorities'), Icons.build_outlined, const Color(0xFF64748B), () => PreventiveMaintenanceScreen(languageCode: languageCode)),
      _FactoryModule(tx('التنبؤ بالطلب وخطة الإنتاج', 'Talep tahmini', 'Demand forecast'), tx('توقع الطلب واقتراح الدفعات والشراء', 'Talep, parti ve satın alma önerileri', 'Demand, batch and purchase suggestions'), Icons.auto_graph_rounded, const Color(0xFF7C3AED), () => DemandForecastScreen(languageCode: languageCode)),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(tx('نظام إدارة معمل العصير', 'İçecek fabrikası yönetimi', 'Instant drink factory management')),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 360,
          mainAxisExtent: 156,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: modules.length,
        itemBuilder: (context, index) {
          final item = modules[index];
          return _ModuleCard(
            item: item,
            openLabel: tx('فتح', 'Aç', 'Open'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => item.builder()),
            ),
          );
        },
      ),
    );
  }
}

class _ModuleCard extends StatefulWidget {
  const _ModuleCard({required this.item, required this.openLabel, required this.onTap});
  final _FactoryModule item;
  final String openLabel;
  final VoidCallback onTap;

  @override
  State<_ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<_ModuleCard> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 170),
        transform: Matrix4.translationValues(0, hovered ? -3 : 0, 0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hovered
                ? item.color.withValues(alpha: .38)
                : Theme.of(context).colorScheme.outlineVariant,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: hovered ? .06 : .025),
              blurRadius: hovered ? 16 : 8,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(item.icon, size: 19, color: item.color),
                      ),
                      const Spacer(),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 170),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: hovered ? item.color.withValues(alpha: .11) : Colors.transparent,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: 17,
                          color: hovered ? item.color : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      item.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            height: 1.35,
                          ),
                    ),
                  ),
                  Text(
                    widget.openLabel,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: item.color,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FactoryModule {
  const _FactoryModule(this.title, this.subtitle, this.icon, this.color, this.builder);
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget Function() builder;
}
