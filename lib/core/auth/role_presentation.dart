import 'package:flutter/material.dart';

import 'app_role.dart';

extension AppRolePresentation on AppRole {
  String label(String languageCode) {
    final labels = switch (this) {
      AppRole.owner => ('Sahip', 'المالك', 'Owner'),
      AppRole.generalManager => ('Genel Müdür', 'المدير العام', 'General Manager'),
      AppRole.admin => ('Sistem Yöneticisi', 'مدير النظام', 'Administrator'),
      AppRole.salesManager => ('Satış Müdürü', 'مدير المبيعات', 'Sales Manager'),
      AppRole.sales => ('Satış', 'المبيعات', 'Sales'),
      AppRole.productionManager => ('Üretim Müdürü', 'مدير الإنتاج', 'Production Manager'),
      AppRole.machineSupervisor => ('Makine Sorumlusu', 'مشرف الماكينات', 'Machine Supervisor'),
      AppRole.quality => ('Kalite', 'الجودة', 'Quality'),
      AppRole.design => ('Tasarım', 'التصميم', 'Design'),
      AppRole.purchasing => ('Satın Alma', 'المشتريات', 'Purchasing'),
      AppRole.warehouse => ('Depo', 'المستودع', 'Warehouse'),
      AppRole.accounting => ('Muhasebe', 'المحاسبة', 'Accounting'),
      AppRole.logistics => ('Lojistik', 'اللوجستيات', 'Logistics'),
      AppRole.maintenance => ('Bakım', 'الصيانة', 'Maintenance'),
      AppRole.packaging => ('Paketleme', 'التغليف', 'Packaging'),
      AppRole.hr => ('İnsan Kaynakları', 'الموارد البشرية', 'Human Resources'),
      AppRole.worker => ('Çalışan', 'عامل', 'Worker'),
      AppRole.partner => ('İş Ortağı', 'شريك', 'Partner'),
    };

    return switch (languageCode) {
      'tr' => labels.$1,
      'ar' => labels.$2,
      _ => labels.$3,
    };
  }

  IconData get icon => switch (this) {
    AppRole.owner => Icons.workspace_premium_rounded,
    AppRole.generalManager => Icons.corporate_fare_rounded,
    AppRole.admin => Icons.admin_panel_settings_rounded,
    AppRole.salesManager => Icons.trending_up_rounded,
    AppRole.sales => Icons.point_of_sale_rounded,
    AppRole.productionManager => Icons.factory_rounded,
    AppRole.machineSupervisor => Icons.precision_manufacturing_rounded,
    AppRole.quality => Icons.verified_rounded,
    AppRole.design => Icons.design_services_rounded,
    AppRole.purchasing => Icons.shopping_cart_checkout_rounded,
    AppRole.warehouse => Icons.warehouse_rounded,
    AppRole.accounting => Icons.account_balance_wallet_rounded,
    AppRole.logistics => Icons.local_shipping_rounded,
    AppRole.maintenance => Icons.build_circle_rounded,
    AppRole.packaging => Icons.inventory_2_rounded,
    AppRole.hr => Icons.groups_rounded,
    AppRole.worker => Icons.engineering_rounded,
    AppRole.partner => Icons.handshake_rounded,
  };

  Color get accent => switch (this) {
    AppRole.owner => const Color(0xFFB7791F),
    AppRole.generalManager => const Color(0xFF1565C0),
    AppRole.admin => const Color(0xFF5E35B1),
    AppRole.salesManager || AppRole.sales => const Color(0xFF00897B),
    AppRole.productionManager || AppRole.machineSupervisor => const Color(0xFFE65100),
    AppRole.quality => const Color(0xFF2E7D32),
    AppRole.design => const Color(0xFFC2185B),
    AppRole.purchasing => const Color(0xFF6D4C41),
    AppRole.warehouse => const Color(0xFF455A64),
    AppRole.accounting => const Color(0xFF0277BD),
    AppRole.logistics => const Color(0xFF3949AB),
    AppRole.maintenance => const Color(0xFF546E7A),
    AppRole.packaging => const Color(0xFF7B1FA2),
    AppRole.hr => const Color(0xFF00838F),
    AppRole.worker => const Color(0xFF607D8B),
    AppRole.partner => const Color(0xFF388E3C),
  };

  bool get isExecutive => switch (this) {
    AppRole.owner || AppRole.generalManager || AppRole.admin => true,
    _ => false,
  };
}

extension AppPermissionPresentation on AppPermission {
  String label(String languageCode) {
    final labels = switch (this) {
      AppPermission.viewDashboard => ('Paneli Görüntüle', 'عرض لوحة التحكم', 'View dashboard'),
      AppPermission.manageUsers => ('Kullanıcıları Yönet', 'إدارة المستخدمين', 'Manage users'),
      AppPermission.manageRoles => ('Rolleri Yönet', 'إدارة الأدوار', 'Manage roles'),
      AppPermission.manageContent => ('İçeriği Yönet', 'إدارة المحتوى', 'Manage content'),
      AppPermission.manageProducts => ('Ürünleri Yönet', 'إدارة المنتجات', 'Manage products'),
      AppPermission.manageCustomers => ('Müşterileri Yönet', 'إدارة العملاء', 'Manage customers'),
      AppPermission.manageSuppliers => ('Tedarikçileri Yönet', 'إدارة الموردين', 'Manage suppliers'),
      AppPermission.manageRfq => ('RFQ Yönet', 'إدارة طلبات الأسعار', 'Manage RFQs'),
      AppPermission.approveRfq => ('RFQ Onayla', 'اعتماد طلبات الأسعار', 'Approve RFQs'),
      AppPermission.manageSales => ('Satışları Yönet', 'إدارة المبيعات', 'Manage sales'),
      AppPermission.manageOrders => ('Siparişleri Yönet', 'إدارة الطلبات', 'Manage orders'),
      AppPermission.manageProduction => ('Üretimi Yönet', 'إدارة الإنتاج', 'Manage production'),
      AppPermission.manageMachines => ('Makineleri Yönet', 'إدارة الماكينات', 'Manage machines'),
      AppPermission.manageQuality => ('Kaliteyi Yönet', 'إدارة الجودة', 'Manage quality'),
      AppPermission.manageInventory => ('Stoku Yönet', 'إدارة المخزون', 'Manage inventory'),
      AppPermission.managePurchasing => ('Satın Almayı Yönet', 'إدارة المشتريات', 'Manage purchasing'),
      AppPermission.manageAccounting => ('Muhasebeyi Yönet', 'إدارة المحاسبة', 'Manage accounting'),
      AppPermission.manageLogistics => ('Lojistiği Yönet', 'إدارة اللوجستيات', 'Manage logistics'),
      AppPermission.manageMaintenance => ('Bakımı Yönet', 'إدارة الصيانة', 'Manage maintenance'),
      AppPermission.manageHr => ('İK Yönet', 'إدارة الموارد البشرية', 'Manage HR'),
      AppPermission.viewReports => ('Raporları Görüntüle', 'عرض التقارير', 'View reports'),
      AppPermission.manageSettings => ('Ayarları Yönet', 'إدارة الإعدادات', 'Manage settings'),
      AppPermission.viewAuditLog => ('İşlem Geçmişi', 'عرض سجل العمليات', 'View audit log'),
    };

    return switch (languageCode) {
      'tr' => labels.$1,
      'ar' => labels.$2,
      _ => labels.$3,
    };
  }
}
