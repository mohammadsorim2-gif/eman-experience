import 'package:flutter/material.dart';

class DepartmentDefinition {
  const DepartmentDefinition({
    required this.id,
    required this.ar,
    required this.tr,
    required this.en,
    required this.icon,
    required this.color,
  });

  final String id;
  final String ar;
  final String tr;
  final String en;
  final IconData icon;
  final Color color;

  String label(String languageCode) => switch (languageCode) {
        'ar' => ar,
        'tr' => tr,
        _ => en,
      };
}

class DepartmentRegistry {
  DepartmentRegistry._();

  static const departments = <DepartmentDefinition>[
    DepartmentDefinition(id: 'sales', ar: 'المبيعات', tr: 'Satış', en: 'Sales', icon: Icons.point_of_sale_rounded, color: Color(0xFF159776)),
    DepartmentDefinition(id: 'production', ar: 'الإنتاج', tr: 'Üretim', en: 'Production', icon: Icons.precision_manufacturing_rounded, color: Color(0xFF0879B8)),
    DepartmentDefinition(id: 'design', ar: 'التصميم', tr: 'Tasarım', en: 'Design', icon: Icons.design_services_rounded, color: Color(0xFF7657D9)),
    DepartmentDefinition(id: 'warehouse', ar: 'المستودع', tr: 'Depo', en: 'Warehouse', icon: Icons.warehouse_rounded, color: Color(0xFFE87A35)),
    DepartmentDefinition(id: 'accounting', ar: 'المحاسبة', tr: 'Muhasebe', en: 'Accounting', icon: Icons.account_balance_wallet_rounded, color: Color(0xFF536773)),
    DepartmentDefinition(id: 'quality', ar: 'الجودة', tr: 'Kalite', en: 'Quality', icon: Icons.verified_rounded, color: Color(0xFFD94F70)),
    DepartmentDefinition(id: 'purchasing', ar: 'المشتريات', tr: 'Satın alma', en: 'Purchasing', icon: Icons.shopping_cart_checkout_rounded, color: Color(0xFF8A6A3A)),
    DepartmentDefinition(id: 'maintenance', ar: 'الصيانة', tr: 'Bakım', en: 'Maintenance', icon: Icons.build_circle_rounded, color: Color(0xFFB05C2E)),
    DepartmentDefinition(id: 'shipping', ar: 'التغليف والشحن', tr: 'Paketleme ve sevkiyat', en: 'Packing & Shipping', icon: Icons.local_shipping_rounded, color: Color(0xFF2E7D6B)),
    DepartmentDefinition(id: 'hr', ar: 'الموارد البشرية', tr: 'İnsan kaynakları', en: 'Human Resources', icon: Icons.groups_rounded, color: Color(0xFF5C6BC0)),
  ];

  static DepartmentDefinition? byId(String id) {
    for (final department in departments) {
      if (department.id == id) return department;
    }
    return null;
  }
}
