import 'package:flutter/material.dart';

import '../../core/security/app_role.dart';

class AccessControlScreen extends StatefulWidget {
  const AccessControlScreen({required this.languageCode, super.key});

  final String languageCode;

  @override
  State<AccessControlScreen> createState() => _AccessControlScreenState();
}

class _AccessControlScreenState extends State<AccessControlScreen> {
  final users = <_AccessUser>[
    const _AccessUser(name: 'Khaled Makieh', email: 'khaled@eman.com', role: AppRole.owner, active: true),
    const _AccessUser(name: 'Fayek Ozduru', email: 'fayek@eman.com', role: AppRole.generalManager, active: true),
    const _AccessUser(name: 'Abdulsalam', email: 'sales@eman.com', role: AppRole.sales, active: true),
    const _AccessUser(name: 'Zeynep', email: 'quality@eman.com', role: AppRole.quality, active: true),
    const _AccessUser(name: 'Warehouse manager', email: 'warehouse@eman.com', role: AppRole.warehouse, active: false),
  ];

  String tx({required String ar, required String tr, required String en}) =>
      switch (widget.languageCode) {'ar' => ar, 'tr' => tr, _ => en};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tx(ar: 'المستخدمون والصلاحيات', tr: 'Kullanıcılar ve yetkiler', en: 'Users & permissions')),
        actions: [
          FilledButton.icon(
            onPressed: _addUser,
            icon: const Icon(Icons.person_add_alt_1_rounded),
            label: Text(tx(ar: 'إضافة مستخدم', tr: 'Kullanıcı ekle', en: 'Add user')),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _Stat(label: tx(ar: 'المستخدمون', tr: 'Kullanıcılar', en: 'Users'), value: '${users.length}', icon: Icons.groups_rounded),
              _Stat(label: tx(ar: 'النشطون', tr: 'Aktif', en: 'Active'), value: '${users.where((u) => u.active).length}', icon: Icons.verified_user_rounded),
              _Stat(label: tx(ar: 'الأدوار', tr: 'Roller', en: 'Roles'), value: '${AppRole.values.length}', icon: Icons.admin_panel_settings_rounded),
            ],
          ),
          const SizedBox(height: 20),
          for (var index = 0; index < users.length; index++)
            Card(
              child: ListTile(
                leading: CircleAvatar(child: Text(users[index].name.substring(0, 1).toUpperCase())),
                title: Text(users[index].name),
                subtitle: Text('${users[index].email}\n${users[index].role.label(widget.languageCode)} • ${users[index].role.permissions.length} ${tx(ar: 'صلاحية', tr: 'yetki', en: 'permissions')}'),
                isThreeLine: true,
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Switch(
                      value: users[index].active,
                      onChanged: (value) => setState(() => users[index] = users[index].copyWith(active: value)),
                    ),
                    IconButton(
                      onPressed: () => _editRole(index),
                      icon: const Icon(Icons.manage_accounts_rounded),
                      tooltip: tx(ar: 'تعديل الدور', tr: 'Rolü düzenle', en: 'Edit role'),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 20),
          Text(tx(ar: 'مصفوفة الصلاحيات', tr: 'Yetki matrisi', en: 'Permission matrix'), style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          for (final role in AppRole.values)
            ExpansionTile(
              leading: const Icon(Icons.security_rounded),
              title: Text(role.label(widget.languageCode)),
              subtitle: Text('${role.permissions.length} ${tx(ar: 'صلاحية مفعلة', tr: 'etkin yetki', en: 'enabled permissions')}'),
              children: [
                for (final permission in AppPermission.values)
                  CheckboxListTile(
                    value: role.allows(permission),
                    onChanged: null,
                    title: Text(_permissionLabel(permission)),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  String _permissionLabel(AppPermission permission) => switch (permission) {
        AppPermission.viewExecutiveDashboard => tx(ar: 'عرض لوحة المدير التنفيذي', tr: 'Yönetici panelini görüntüle', en: 'View executive dashboard'),
        AppPermission.manageUsers => tx(ar: 'إدارة المستخدمين', tr: 'Kullanıcıları yönet', en: 'Manage users'),
        AppPermission.manageRoles => tx(ar: 'إدارة الأدوار', tr: 'Rolleri yönet', en: 'Manage roles'),
        AppPermission.manageSales => tx(ar: 'إدارة المبيعات', tr: 'Satışı yönet', en: 'Manage sales'),
        AppPermission.manageProduction => tx(ar: 'إدارة الإنتاج', tr: 'Üretimi yönet', en: 'Manage production'),
        AppPermission.manageRecipes => tx(ar: 'إدارة الوصفات', tr: 'Reçeteleri yönet', en: 'Manage recipes'),
        AppPermission.manageQuality => tx(ar: 'إدارة الجودة', tr: 'Kaliteyi yönet', en: 'Manage quality'),
        AppPermission.manageInventory => tx(ar: 'إدارة المخزون', tr: 'Stoku yönet', en: 'Manage inventory'),
        AppPermission.manageWarehouse => tx(ar: 'إدارة المستودع', tr: 'Depoyu yönet', en: 'Manage warehouse'),
        AppPermission.manageShipping => tx(ar: 'إدارة الشحن', tr: 'Sevkiyatı yönet', en: 'Manage shipping'),
        AppPermission.manageMaintenance => tx(ar: 'إدارة الصيانة', tr: 'Bakımı yönet', en: 'Manage maintenance'),
        AppPermission.viewFinancials => tx(ar: 'عرض البيانات المالية', tr: 'Finansalları görüntüle', en: 'View financials'),
        AppPermission.managePurchasing => tx(ar: 'إدارة المشتريات', tr: 'Satın almayı yönet', en: 'Manage purchasing'),
        AppPermission.viewAuditLogs => tx(ar: 'عرض سجلات التدقيق', tr: 'Denetim kayıtlarını görüntüle', en: 'View audit logs'),
        AppPermission.manageBackups => tx(ar: 'إدارة النسخ الاحتياطية', tr: 'Yedekleri yönet', en: 'Manage backups'),
        AppPermission.manageSystemSettings => tx(ar: 'إدارة إعدادات النظام', tr: 'Sistem ayarlarını yönet', en: 'Manage system settings'),
      };

  Future<void> _editRole(int index) async {
    var selected = users[index].role;
    final result = await showDialog<AppRole>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(tx(ar: 'تعديل دور المستخدم', tr: 'Kullanıcı rolünü düzenle', en: 'Edit user role')),
          content: DropdownButtonFormField<AppRole>(
            initialValue: selected,
            items: [for (final role in AppRole.values) DropdownMenuItem(value: role, child: Text(role.label(widget.languageCode)))],
            onChanged: (value) {
              if (value != null) setDialogState(() => selected = value);
            },
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(tx(ar: 'إلغاء', tr: 'İptal', en: 'Cancel'))),
            FilledButton(onPressed: () => Navigator.pop(context, selected), child: Text(tx(ar: 'حفظ', tr: 'Kaydet', en: 'Save'))),
          ],
        ),
      ),
    );
    if (result != null) setState(() => users[index] = users[index].copyWith(role: result));
  }

  Future<void> _addUser() async {
    final name = TextEditingController();
    final email = TextEditingController();
    var role = AppRole.worker;
    final result = await showDialog<_AccessUser>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(tx(ar: 'إضافة مستخدم', tr: 'Kullanıcı ekle', en: 'Add user')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: name, decoration: InputDecoration(labelText: tx(ar: 'الاسم', tr: 'Ad', en: 'Name'))),
              const SizedBox(height: 12),
              TextField(controller: email, decoration: InputDecoration(labelText: tx(ar: 'البريد الإلكتروني', tr: 'E-posta', en: 'Email'))),
              const SizedBox(height: 12),
              DropdownButtonFormField<AppRole>(
                initialValue: role,
                items: [for (final item in AppRole.values) DropdownMenuItem(value: item, child: Text(item.label(widget.languageCode)))],
                onChanged: (value) {
                  if (value != null) setDialogState(() => role = value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(tx(ar: 'إلغاء', tr: 'İptal', en: 'Cancel'))),
            FilledButton(
              onPressed: () {
                if (name.text.trim().isEmpty || email.text.trim().isEmpty) return;
                Navigator.pop(context, _AccessUser(name: name.text.trim(), email: email.text.trim(), role: role, active: true));
              },
              child: Text(tx(ar: 'إضافة', tr: 'Ekle', en: 'Add')),
            ),
          ],
        ),
      ),
    );
    if (result != null) setState(() => users.insert(0, result));
  }
}

class _AccessUser {
  const _AccessUser({required this.name, required this.email, required this.role, required this.active});
  final String name;
  final String email;
  final AppRole role;
  final bool active;

  _AccessUser copyWith({AppRole? role, bool? active}) => _AccessUser(
        name: name,
        email: email,
        role: role ?? this.role,
        active: active ?? this.active,
      );
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 230,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                CircleAvatar(child: Icon(icon)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: Theme.of(context).textTheme.titleLarge), Text(label)])),
              ],
            ),
          ),
        ),
      );
}
