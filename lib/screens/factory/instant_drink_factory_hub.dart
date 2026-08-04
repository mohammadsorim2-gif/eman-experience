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
      module(
        tx('لوحة المدير التنفيذي', 'Yönetici paneli', 'Executive dashboard'),
        tx('الإنتاج والكفاءة والمبيعات والتنبيهات المباشرة', 'Üretim, verimlilik, satış ve canlı uyarılar', 'Production, efficiency, sales and live alerts'),
        Icons.insights_rounded,
        () => ExecutiveFactoryDashboard(languageCode: languageCode),
      ),
      module(
        tx('المستخدمون والصلاحيات', 'Kullanıcılar ve yetkiler', 'Users & permissions'),
        tx('إدارة المستخدمين والأدوار والتفعيل ومصفوفة الصلاحيات', 'Kullanıcıları, rolleri, durumu ve yetki matrisini yönetin', 'Manage users, roles, activation and the permission matrix'),
        Icons.manage_accounts_rounded,
        () => AccessControlScreen(languageCode: languageCode),
      ),
      module(
        tx('مركز إدارة النظام', 'Sistem yönetim merkezi', 'System administration center'),
        tx('حالة النظام وسجل الدخول والنسخ الاحتياطية وتخصيص اللوحة', 'Sistem durumu, giriş kayıtları, yedekler ve panel düzeni', 'System status, login audit, backups and dashboard layout'),
        Icons.admin_panel_settings_rounded,
        () => AdminToolsHub(languageCode: languageCode),
      ),
      module(
        tx('مركز الأقسام', 'Bölüm merkezi', 'Department hub'),
        tx('لوحات موحدة لكل أقسام الشركة', 'Tüm şirket bölümleri için birleşik paneller', 'Unified workspaces for all company departments'),
        Icons.account_tree_outlined,
        () => DepartmentHubScreen(languageCode: languageCode),
      ),
      module(
        tx('خطوط ومحطات الإنتاج', 'Üretim hatları', 'Production lines'),
        tx('الخلط والتعبئة والتغليف وحالة التشغيل', 'Karıştırma, dolum, paketleme ve hat durumu', 'Mixing, filling, packing and line status'),
        Icons.precision_manufacturing_rounded,
        () => MachineFleetScreen(languageCode: languageCode),
      ),
      module(
        tx('دفعات الإنتاج', 'Üretim partileri', 'Production batches'),
        tx('متابعة الدفعات ونسب الإنجاز ومراحل التشغيل', 'Partiler, ilerleme ve üretim aşamaları', 'Track batches, progress and production stages'),
        Icons.factory_rounded,
        () => InstantDrinkBatchScreen(languageCode: languageCode),
      ),
      module(
        tx('تتبع الدفعة واللوط', 'Parti ve lot izlenebilirliği', 'Batch & lot traceability'),
        tx('من المواد الخام حتى العميل والشحن', 'Hammaddeden müşteriye ve sevkiyata', 'From raw materials through customer and shipping'),
        Icons.account_tree_rounded,
        () => BatchTraceabilityScreen(languageCode: languageCode),
      ),
      module(
        tx('الوصفات والتركيبات', 'Reçeteler', 'Recipes and formulas'),
        tx('إدارة النكهات والأوزان وتركيبة كل دفعة', 'Aroma, gramaj ve parti formülleri', 'Manage flavors, weights and batch formulas'),
        Icons.science_rounded,
        () => InstantDrinkRecipeScreen(languageCode: languageCode),
      ),
      module(
        tx('الجودة والمختبر', 'Kalite ve laboratuvar', 'Quality and laboratory'),
        tx('فحص الطعم واللون والوزن والإغلاق والذوبان', 'Tat, renk, ağırlık, sızdırmazlık ve çözünürlük', 'Taste, color, weight, seal and solubility checks'),
        Icons.verified_rounded,
        () => InstantDrinkQualityScreen(languageCode: languageCode),
      ),
      module(
        tx('مخزون المواد', 'Malzeme stoğu', 'Materials inventory'),
        tx('المواد الخام والنكهات ومواد التغليف والتنبيهات', 'Hammadde, aroma, ambalaj ve uyarılar', 'Raw materials, flavors, packaging and alerts'),
        Icons.inventory_2_rounded,
        () => InstantDrinkMaterialsScreen(languageCode: languageCode),
      ),
      module(
        tx('مستودع الباركود', 'Barkod deposu', 'Barcode warehouse'),
        tx('الاستلام والصرف والجرد والشحن بالباركود وQR', 'Barkod ve QR ile giriş, çıkış, sayım ve sevkiyat', 'Receive, issue, count and ship with barcode and QR'),
        Icons.qr_code_scanner_rounded,
        () => BarcodeWarehouseScreen(languageCode: languageCode),
      ),
      module(
        tx('طلبات المبيعات', 'Satış siparişleri', 'Sales orders'),
        tx('ربط طلبات العملاء بالإنتاج والجاهزية', 'Siparişleri üretim ve hazırlıkla bağlayın', 'Connect customer orders to production and readiness'),
        Icons.receipt_long_rounded,
        () => SalesOrdersScreen(languageCode: languageCode),
      ),
      module(
        tx('المندوبون وخطوط السير', 'Satış temsilcileri ve rotalar', 'Sales representatives & routes'),
        tx('الأهداف والزيارات والتحصيل والمناطق والمسارات', 'Hedefler, ziyaretler, tahsilat ve rotalar', 'Targets, visits, collections, territories and routes'),
        Icons.route_rounded,
        () => SalesRepresentativesScreen(languageCode: languageCode),
      ),
      module(
        tx('المنتج النهائي والشحن', 'Bitmiş ürün ve sevkiyat', 'Finished goods and shipping'),
        tx('اللوطات والكراتين والطبليات والتحميل', 'Lotlar, koliler, paletler ve yükleme', 'Lots, cartons, pallets and loading'),
        Icons.local_shipping_rounded,
        () => FinishedGoodsShippingScreen(languageCode: languageCode),
      ),
      module(
        tx('الصيانة الوقائية', 'Önleyici bakım', 'Preventive maintenance'),
        tx('المهام والاستحقاقات والأولويات وحالة الإنجاز', 'Görevler, tarihler, öncelikler ve durum', 'Tasks, due dates, priorities and completion'),
        Icons.build_circle_rounded,
        () => PreventiveMaintenanceScreen(languageCode: languageCode),
      ),
      module(
        tx('التنبؤ بالطلب وخطة الإنتاج', 'Talep tahmini ve üretim planı', 'Demand forecast & production plan'),
        tx('توقع الطلب واقتراح الدفعات واحتياجات الشراء', 'Talep tahmini, parti ve satın alma önerileri', 'Forecast demand, suggest batches and purchasing needs'),
        Icons.auto_awesome_rounded,
        () => DemandForecastScreen(languageCode: languageCode),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(tx('نظام إدارة معمل العصير', 'İçecek fabrikası yönetimi', 'Instant drink factory management')),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 1200 ? 3 : constraints.maxWidth >= 760 ? 2 : 1;
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
              final item = modules[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => item.builder())),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(radius: 25, child: Icon(item.icon)),
                        const Spacer(),
                        Text(item.title, style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(item.subtitle, maxLines: 3, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 14),
                        Row(children: [Text(tx('فتح القسم', 'Bölümü aç', 'Open module')), const Spacer(), const Icon(Icons.arrow_forward_rounded)]),
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

  _FactoryModule module(String title, String subtitle, IconData icon, Widget Function() builder) =>
      _FactoryModule(title: title, subtitle: subtitle, icon: icon, builder: builder);
}

class _FactoryModule {
  const _FactoryModule({required this.title, required this.subtitle, required this.icon, required this.builder});
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget Function() builder;
}
