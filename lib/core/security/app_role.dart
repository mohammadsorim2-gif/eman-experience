enum AppRole {
  owner,
  generalManager,
  sales,
  production,
  quality,
  warehouse,
  accounting,
  purchasing,
  maintenance,
  logistics,
  worker,
}

enum AppPermission {
  viewExecutiveDashboard,
  manageUsers,
  manageRoles,
  manageSales,
  manageProduction,
  manageRecipes,
  manageQuality,
  manageInventory,
  manageWarehouse,
  manageShipping,
  manageMaintenance,
  viewFinancials,
  managePurchasing,
  viewAuditLogs,
  manageBackups,
  manageSystemSettings,
}

extension AppRolePermissions on AppRole {
  Set<AppPermission> get permissions => switch (this) {
        AppRole.owner || AppRole.generalManager => AppPermission.values.toSet(),
        AppRole.sales => {
            AppPermission.manageSales,
            AppPermission.manageShipping,
          },
        AppRole.production => {
            AppPermission.manageProduction,
            AppPermission.manageRecipes,
          },
        AppRole.quality => {
            AppPermission.manageQuality,
            AppPermission.manageProduction,
          },
        AppRole.warehouse => {
            AppPermission.manageInventory,
            AppPermission.manageWarehouse,
            AppPermission.manageShipping,
          },
        AppRole.accounting => {
            AppPermission.viewFinancials,
            AppPermission.manageSales,
            AppPermission.managePurchasing,
          },
        AppRole.purchasing => {
            AppPermission.managePurchasing,
            AppPermission.manageInventory,
          },
        AppRole.maintenance => {
            AppPermission.manageMaintenance,
          },
        AppRole.logistics => {
            AppPermission.manageShipping,
            AppPermission.manageWarehouse,
          },
        AppRole.worker => {
            AppPermission.manageProduction,
          },
      };

  bool allows(AppPermission permission) => permissions.contains(permission);

  String label(String languageCode) => switch ((this, languageCode)) {
        (AppRole.owner, 'ar') => 'المالك',
        (AppRole.owner, 'tr') => 'Sahip',
        (AppRole.generalManager, 'ar') => 'المدير العام',
        (AppRole.generalManager, 'tr') => 'Genel müdür',
        (AppRole.sales, 'ar') => 'المبيعات',
        (AppRole.sales, 'tr') => 'Satış',
        (AppRole.production, 'ar') => 'الإنتاج',
        (AppRole.production, 'tr') => 'Üretim',
        (AppRole.quality, 'ar') => 'الجودة',
        (AppRole.quality, 'tr') => 'Kalite',
        (AppRole.warehouse, 'ar') => 'المستودع',
        (AppRole.warehouse, 'tr') => 'Depo',
        (AppRole.accounting, 'ar') => 'المحاسبة',
        (AppRole.accounting, 'tr') => 'Muhasebe',
        (AppRole.purchasing, 'ar') => 'المشتريات',
        (AppRole.purchasing, 'tr') => 'Satın alma',
        (AppRole.maintenance, 'ar') => 'الصيانة',
        (AppRole.maintenance, 'tr') => 'Bakım',
        (AppRole.logistics, 'ar') => 'اللوجستيات',
        (AppRole.logistics, 'tr') => 'Lojistik',
        (AppRole.worker, 'ar') => 'عامل',
        (AppRole.worker, 'tr') => 'Çalışan',
        (AppRole.owner, _) => 'Owner',
        (AppRole.generalManager, _) => 'General manager',
        (AppRole.sales, _) => 'Sales',
        (AppRole.production, _) => 'Production',
        (AppRole.quality, _) => 'Quality',
        (AppRole.warehouse, _) => 'Warehouse',
        (AppRole.accounting, _) => 'Accounting',
        (AppRole.purchasing, _) => 'Purchasing',
        (AppRole.maintenance, _) => 'Maintenance',
        (AppRole.logistics, _) => 'Logistics',
        (AppRole.worker, _) => 'Worker',
      };
}
