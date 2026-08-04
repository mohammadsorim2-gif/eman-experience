import 'package:flutter/material.dart';

import '../../core/auth/app_role.dart';
import '../../core/auth/role_presentation.dart';

class RolePermissionMatrixScreen extends StatefulWidget {
  const RolePermissionMatrixScreen({required this.languageCode, super.key});

  final String languageCode;

  @override
  State<RolePermissionMatrixScreen> createState() =>
      _RolePermissionMatrixScreenState();
}

class _RolePermissionMatrixScreenState
    extends State<RolePermissionMatrixScreen> {
  late final Map<AppRole, Set<AppPermission>> _matrix = {
    for (final role in AppRole.values)
      role: {...?RolePermissions.matrix[role]},
  };

  AppRole _selectedRole = AppRole.owner;
  String _query = '';

  String _tx({required String tr, required String ar, required String en}) {
    return switch (widget.languageCode) {
      'tr' => tr,
      'ar' => ar,
      _ => en,
    };
  }

  List<AppPermission> get _permissions {
    final query = _query.trim().toLowerCase();
    return AppPermission.values.where((permission) {
      if (query.isEmpty) return true;
      return permission.label(widget.languageCode).toLowerCase().contains(query);
    }).toList();
  }

  void _toggle(AppPermission permission, bool enabled) {
    if (_selectedRole.isExecutive) return;
    setState(() {
      final permissions = _matrix[_selectedRole]!;
      enabled ? permissions.add(permission) : permissions.remove(permission);
    });
  }

  void _resetRole() {
    setState(() {
      _matrix[_selectedRole] = {...?RolePermissions.matrix[_selectedRole]};
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedPermissions = _matrix[_selectedRole]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tx(
            tr: 'Rol ve yetki matrisi',
            ar: 'مصفوفة الرتب والصلاحيات',
            en: 'Role and permission matrix',
          ),
        ),
        actions: [
          IconButton(
            tooltip: _tx(
              tr: 'Varsayılana dön',
              ar: 'استعادة الافتراضي',
              en: 'Reset defaults',
            ),
            onPressed: _resetRole,
            icon: const Icon(Icons.restart_alt_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 980;
          final rolePanel = _RolePanel(
            languageCode: widget.languageCode,
            selectedRole: _selectedRole,
            matrix: _matrix,
            onSelected: (role) => setState(() => _selectedRole = role),
          );
          final permissionPanel = _PermissionPanel(
            languageCode: widget.languageCode,
            role: _selectedRole,
            permissions: _permissions,
            selectedPermissions: selectedPermissions,
            onSearch: (value) => setState(() => _query = value),
            onChanged: _toggle,
          );

          if (wide) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(width: 320, child: rolePanel),
                  const SizedBox(width: 18),
                  Expanded(child: permissionPanel),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SizedBox(height: 360, child: rolePanel),
              const SizedBox(height: 16),
              SizedBox(height: 620, child: permissionPanel),
            ],
          );
        },
      ),
    );
  }
}

class _RolePanel extends StatelessWidget {
  const _RolePanel({
    required this.languageCode,
    required this.selectedRole,
    required this.matrix,
    required this.onSelected,
  });

  final String languageCode;
  final AppRole selectedRole;
  final Map<AppRole, Set<AppPermission>> matrix;
  final ValueChanged<AppRole> onSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
            child: Text(
              languageCode == 'ar'
                  ? 'الرتب'
                  : languageCode == 'tr'
                      ? 'Roller'
                      : 'Roles',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: AppRole.values.length,
              itemBuilder: (context, index) {
                final role = AppRole.values[index];
                final selected = role == selectedRole;
                return ListTile(
                  selected: selected,
                  onTap: () => onSelected(role),
                  leading: CircleAvatar(
                    backgroundColor: role.accent.withValues(alpha: .14),
                    child: Icon(role.icon, color: role.accent, size: 20),
                  ),
                  title: Text(role.label(languageCode)),
                  subtitle: Text(
                    '${matrix[role]?.length ?? 0} ${languageCode == 'ar' ? 'صلاحية' : languageCode == 'tr' ? 'yetki' : 'permissions'}',
                  ),
                  trailing: role.isExecutive
                      ? const Icon(Icons.lock_rounded, size: 18)
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionPanel extends StatelessWidget {
  const _PermissionPanel({
    required this.languageCode,
    required this.role,
    required this.permissions,
    required this.selectedPermissions,
    required this.onSearch,
    required this.onChanged,
  });

  final String languageCode;
  final AppRole role;
  final List<AppPermission> permissions;
  final Set<AppPermission> selectedPermissions;
  final ValueChanged<String> onSearch;
  final void Function(AppPermission permission, bool enabled) onChanged;

  String _tx({required String tr, required String ar, required String en}) {
    return switch (languageCode) {
      'tr' => tr,
      'ar' => ar,
      _ => en,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: role.accent.withValues(alpha: .14),
                  child: Icon(role.icon, color: role.accent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role.label(languageCode),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        role.isExecutive
                            ? _tx(
                                tr: 'Tüm yetkiler zorunlu olarak açık',
                                ar: 'جميع الصلاحيات مفعّلة إجباريًا',
                                en: 'All permissions are locked on',
                              )
                            : _tx(
                                tr: 'Bu rolün erişimini yönetin',
                                ar: 'تحكم بوصول هذه الرتبة',
                                en: 'Manage access for this role',
                              ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text('${selectedPermissions.length}/${AppPermission.values.length}'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
            child: TextField(
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: _tx(
                  tr: 'Yetki ara...',
                  ar: 'ابحث عن صلاحية...',
                  en: 'Search permissions...',
                ),
                prefixIcon: const Icon(Icons.search_rounded),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: permissions.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final permission = permissions[index];
                final enabled = role.isExecutive ||
                    selectedPermissions.contains(permission);
                return SwitchListTile(
                  value: enabled,
                  onChanged: role.isExecutive
                      ? null
                      : (value) => onChanged(permission, value),
                  title: Text(permission.label(languageCode)),
                  secondary: Icon(
                    enabled
                        ? Icons.verified_user_rounded
                        : Icons.no_accounts_rounded,
                    color: enabled ? const Color(0xFF159776) : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
