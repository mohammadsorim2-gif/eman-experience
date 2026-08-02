enum AppRole {
  owner,
  generalManager,
  admin,
  salesManager,
  sales,
  productionManager,
  machineSupervisor,
  quality,
  design,
  purchasing,
  warehouse,
  accounting,
  logistics,
  maintenance,
  packaging,
  hr,
  worker,
  partner,
}

enum AppPermission {
  viewDashboard,
  manageUsers,
  manageRoles,
  manageContent,
  manageProducts,
  manageCustomers,
  manageSuppliers,
  manageRfq,
  approveRfq,
  manageSales,
  manageOrders,
  manageProduction,
  manageMachines,
  manageQuality,
  manageInventory,
  managePurchasing,
  manageAccounting,
  manageLogistics,
  manageMaintenance,
  manageHr,
  viewReports,
  manageSettings,
  viewAuditLog,
}

abstract final class RolePermissions {
  static const all = <AppPermission>{...AppPermission.values};

  static const Map<AppRole, Set<AppPermission>> matrix = {
    AppRole.owner: all,
    AppRole.generalManager: all,
    AppRole.admin: all,
    AppRole.salesManager: {
      AppPermission.viewDashboard,
      AppPermission.manageCustomers,
      AppPermission.manageRfq,
      AppPermission.approveRfq,
      AppPermission.manageSales,
      AppPermission.manageOrders,
      AppPermission.viewReports,
    },
    AppRole.sales: {
      AppPermission.viewDashboard,
      AppPermission.manageCustomers,
      AppPermission.manageRfq,
      AppPermission.manageSales,
      AppPermission.manageOrders,
    },
    AppRole.productionManager: {
      AppPermission.viewDashboard,
      AppPermission.manageProduction,
      AppPermission.manageMachines,
      AppPermission.manageQuality,
      AppPermission.manageInventory,
      AppPermission.viewReports,
    },
    AppRole.machineSupervisor: {
      AppPermission.viewDashboard,
      AppPermission.manageProduction,
      AppPermission.manageMachines,
    },
    AppRole.quality: {
      AppPermission.viewDashboard,
      AppPermission.manageQuality,
      AppPermission.viewReports,
    },
    AppRole.design: {
      AppPermission.viewDashboard,
      AppPermission.manageContent,
      AppPermission.manageProducts,
      AppPermission.manageRfq,
    },
    AppRole.purchasing: {
      AppPermission.viewDashboard,
      AppPermission.managePurchasing,
      AppPermission.manageSuppliers,
      AppPermission.manageInventory,
    },
    AppRole.warehouse: {
      AppPermission.viewDashboard,
      AppPermission.manageInventory,
      AppPermission.manageOrders,
      AppPermission.manageLogistics,
    },
    AppRole.accounting: {
      AppPermission.viewDashboard,
      AppPermission.manageAccounting,
      AppPermission.viewReports,
    },
    AppRole.logistics: {
      AppPermission.viewDashboard,
      AppPermission.manageLogistics,
      AppPermission.manageOrders,
    },
    AppRole.maintenance: {
      AppPermission.viewDashboard,
      AppPermission.manageMaintenance,
      AppPermission.manageMachines,
    },
    AppRole.packaging: {
      AppPermission.viewDashboard,
      AppPermission.manageProduction,
      AppPermission.manageOrders,
    },
    AppRole.hr: {
      AppPermission.viewDashboard,
      AppPermission.manageHr,
      AppPermission.manageUsers,
      AppPermission.viewReports,
    },
    AppRole.worker: {
      AppPermission.viewDashboard,
      AppPermission.manageProduction,
    },
    AppRole.partner: {
      AppPermission.viewDashboard,
      AppPermission.manageRfq,
      AppPermission.manageOrders,
    },
  };

  static bool allows(AppRole role, AppPermission permission) {
    return matrix[role]?.contains(permission) ?? false;
  }
}
