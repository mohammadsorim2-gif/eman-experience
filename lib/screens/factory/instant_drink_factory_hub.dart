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
      _module(tx('لوحة المدير التنفيذي', 'Yönetici paneli', 'Executive dashboard'), tx('الإنتاج والكفاءة والمبيعات والتنبيهات المباشرة', 'Üretim, verimlilik, satış ve canlı uyarılar', 'Production, efficiency, sales and live alerts'), Icons.insights_outlined, const Color(0xFF0F9D78), () => ExecutiveFactoryDashboard(languageCode: languageCode)),
      _module(tx('المستخدمون والصلاحيات', 'Kullanıcılar ve yetkiler', 'Users & permissions'), tx('إدارة المستخدمين والأدوار والتفعيل ومصفوفة الصلاحيات', 'Kullanıcıları, rolleri, durumu ve yetki matrisini yönetin', 'Manage users, roles, activation and the permission matrix'), Icons.group_outlined, const Color(0xFF2563EB), () => AccessControlScreen(languageCode: languageCode)),
      _module(tx('مركز إدارة النظام', 'Sistem yönetim merkezi', 'System administration center'), tx('حالة النظام وسجل الدخول والنسخ الاحتياطية وتخصيص اللوحة', 'Sistem durumu, giriş kayıtları, yedekler ve panel düzeni', 'System status, login audit, backups and dashboard layout'), Icons.tune_rounded, const Color(0xFF4F46E5), () => AdminToolsHub(languageCode: languageCode)),
      _module(tx('مركز الأقسام', 'Bölüm merkezi', 'Department hub'), tx('لوحات موحدة لكل أقسام الشركة', 'Tüm şirket bölümleri için birleşik paneller', 'Unified workspaces for all company departments'), Icons.grid_view_rounded, const Color(0xFF0891B2), () => DepartmentHubScreen(languageCode: languageCode)),
      _module(tx('خطوط ومحطات الإنتاج', 'Üretim hatları', 'Production lines'), tx('الخلط والتعبئة والتغليف وحالة التشغيل', 'Karıştırma, dolum, paketleme ve hat durumu', 'Mixing, filling, packing and line status'), Icons.precision_manufacturing_outlined, const Color(0xFF9333EA), () => MachineFleetScreen(languageCode: languageCode)),
      _module(tx('دفعات الإنتاج', 'Üretim partileri', 'Production batches'), tx('متابعة الدفعات ونسب الإنجاز ومراحل التشغيل', 'Partiler, ilerleme ve üretim aşamaları', 'Track batches, progress and production stages'), Icons.inventory_2_outlined, const Color(0xFFF97316), () => InstantDrinkBatchScreen(languageCode: languageCode)),
      _module(tx('تتبع الدفعة واللوط', 'Parti ve lot izlenebilirliği', 'Batch & lot traceability'), tx('من المواد الخام حتى العميل والشحن', 'Hammaddeden müşteriye ve sevkiyata', 'From raw materials through customer and shipping'), Icons.hub_outlined, const Color(0xFF7C3AED), () => BatchTraceabilityScreen(languageCode: languageCode)),
      _module(tx('الوصفات والتركيبات', 'Reçeteler', 'Recipes and formulas'), tx('إدارة النكهات والأوزان وتركيبة كل دفعة', 'Aroma, gramaj ve parti formülleri', 'Manage flavors, weights and batch formulas'), Icons.science_outlined, const Color(0xFFDB2777), () => InstantDrinkRecipeScreen(languageCode: languageCode)),
      _module(tx('الجودة والمختبر', 'Kalite ve laboratuvar', 'Quality and laboratory'), tx('فحص الطعم واللون والوزن والإغلاق والذوبان', 'Tat, renk, ağırlık, sızdırmazlık ve çözünürlük', 'Taste, color, weight, seal and solubility checks'), Icons.verified_outlined, const Color(0xFF16A34A), () => InstantDrinkQualityScreen(languageCode: languageCode)),
      _module(tx('مخزون المواد', 'Malzeme stoğu', 'Materials inventory'), tx('المواد الخام والنكهات ومواد التغليف والتنبيهات', 'Hammadde, aroma, ambalaj ve uyarılar', 'Raw materials, flavors, packaging and alerts'), Icons.warehouse_outlined, const Color(0xFF0D9488), () => InstantDrinkMaterialsScreen(languageCode: languageCode)),
      _module(tx('مستودع الباركود', 'Barkod deposu', 'Barcode warehouse'), tx('الاستلام والصرف والجرد والشحن بالباركود وQR', 'Barkod ve QR ile giriş, çıkış, sayım ve sevkiyat', 'Receive, issue, count and ship with barcode and QR'), Icons.qr_code_scanner_rounded, const Color(0xFF0284C7), () => BarcodeWarehouseScreen(languageCode: languageCode)),
      _module(tx('طلبات المبيعات', 'Satış siparişleri', 'Sales orders'), tx('ربط طلبات العملاء بالإنتاج والجاهزية', 'Siparişleri üretim ve hazırlıkla bağlayın', 'Connect customer orders to production and readiness'), Icons.receipt_long_outlined, const Color(0xFFEA580C), () => SalesOrdersScreen(languageCode: languageCode)),
      _module(tx('المندوبون وخطوط السير', 'Satış temsilcileri ve rotalar', 'Sales representatives & routes'), tx('الأهداف والزيارات والتحصيل والمناطق والمسارات', 'Hedefler, ziyaretler, tahsilat ve rotalar', 'Targets, visits, collections, territories and routes'), Icons.route_outlined, const Color(0xFF059669), () => SalesRepresentativesScreen(languageCode: languageCode)),
      _module(tx('المنتج النهائي والشحن', 'Bitmiş ürün ve sevkiyat', 'Finished goods and shipping'), tx('اللوطات والكراتين والطبليات والتحميل', 'Lotlar, koliler, paletler ve yükleme', 'Lots, cartons, pallets and loading'), Icons.local_shipping_outlined, const Color(0xFF2563EB), () => FinishedGoodsShippingScreen(languageCode: languageCode)),
      _module(tx('الصيانة الوقائية', 'Önleyici bakım', 'Preventive maintenance'), tx('المهام والاستحقاقات والأولويات وحالة الإنجاز', 'Görevler, tarihler, öncelikler ve durum', 'Tasks, due dates, priorities and completion'), Icons.build_outlined, const Color(0xFF64748B), () => PreventiveMaintenanceScreen(languageCode: languageCode)),
      _module(tx('التنبؤ بالطلب وخطة الإنتاج', 'Talep tahmini ve üretim planı', 'Demand forecast & production plan'), tx('توقع الطلب واقتراح الدفعات واحتياجات الشراء', 'Talep tahmini, parti ve satın alma önerileri', 'Forecast demand, suggest batches and purchasing needs'), Icons.auto_graph_rounded, const Color(0xFF7C3AED), () => DemandForecastScreen(languageCode: languageCode)),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(tx('نظام إدارة معمل العصير', 'İçecek fabrikası yönetimi', 'Instant drink factory management'))),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 1350 ? 4 : constraints.maxWidth >= 920 ? 3 : constraints.maxWidth >= 620 ? 2 : 1;
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: columns == 1 ? 2.9 : 1.75),
            itemCount: modules.length,
            itemBuilder: (context, index) => _ModuleCard(
              item: modules[index],
              openLabel: tx('فتح', 'Aç', 'Open'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => modules[index].builder())),
            ),
          );
        },
      ),
    );
  }

  _FactoryModule _module(String title, String subtitle, IconData icon, Color color, Widget Function() builder) => _FactoryModule(title: title, subtitle: subtitle, icon: icon, color: color, builder: builder);
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
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final borderColor = _hovered ? item.color.withValues(alpha: .42) : Theme.of(context).colorScheme.outlineVariant.withValues(alpha: .7);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: _hovered ? .075 : .035), blurRadius: _hovered ? 22 : 12, offset: Offset(0, _hovered ? 10 : 5))],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  AnimatedContainer(duration: const Duration(milliseconds: 180), width: 34, height: 34, decoration: BoxDecoration(color: item.color.withValues(alpha: _hovered ? .16 : .09), borderRadius: BorderRadius.circular(10)), child: Icon(item.icon, size: 18, color: item.color)),
                  const Spacer(),
                  AnimatedContainer(duration: const Duration(milliseconds: 180), width: 30, height: 30, decoration: BoxDecoration(color: _hovered ? item.color.withValues(alpha: .12) : Colors.transparent, borderRadius: BorderRadius.circular(9)), child: Icon(Icons.arrow_forward_rounded, size: 17, color: _hovered ? item.color : Theme.of(context).colorScheme.onSurfaceVariant)),
                ]),
                const Spacer(),
                Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(item.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.35)),
                const SizedBox(height: 10),
                Text(widget.openLabel, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: item.color, fontWeight: FontWeight.w700)),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _FactoryModule {
  const _FactoryModule({required this.title, required this.subtitle, required this.icon, required this.color, required this.builder});
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget Function() builder;
}
