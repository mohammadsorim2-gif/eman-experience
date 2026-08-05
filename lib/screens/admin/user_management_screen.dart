import 'package:flutter/material.dart';

import '../../core/auth/app_role.dart';
import '../../core/auth/role_presentation.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({required this.languageCode, super.key});

  final String languageCode;

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final _searchController = TextEditingController();
  AppRole? _roleFilter;

  final List<_ManagedUser> _users = [
    const _ManagedUser(
      name: 'Khaled Makieh',
      email: 'owner@eman.one',
      role: AppRole.owner,
      active: true,
    ),
    const _ManagedUser(
      name: 'Fayek Ozduru',
      email: 'manager@eman.one',
      role: AppRole.generalManager,
      active: true,
    ),
    const _ManagedUser(
      name: 'Abdulsalam',
      email: 'sales@eman.one',
      role: AppRole.salesManager,
      active: true,
    ),
    const _ManagedUser(
      name: 'Lutfi',
      email: 'production@eman.one',
      role: AppRole.productionManager,
      active: true,
    ),
    const _ManagedUser(
      name: 'Zeynep',
      email: 'quality@eman.one',
      role: AppRole.quality,
      active: true,
    ),
  ];

  String _tx({required String tr, required String ar, required String en}) {
    return switch (widget.languageCode) {
      'tr' => tr,
      'ar' => ar,
      _ => en,
    };
  }

  List<_ManagedUser> get _filteredUsers {
    final query = _searchController.text.trim().toLowerCase();
    return _users.where((user) {
      final matchesQuery = query.isEmpty ||
          user.name.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query);
      final matchesRole = _roleFilter == null || user.role == _roleFilter;
      return matchesQuery && matchesRole;
    }).toList();
  }

  Future<void> _openCreateUser() async {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    var selectedRole = AppRole.worker;

    final created = await showDialog<_ManagedUser>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            _tx(
              tr: 'Yeni kullanıcı',
              ar: 'مستخدم جديد',
              en: 'New user',
            ),
          ),
          content: SizedBox(
            width: 460,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: _tx(tr: 'Ad soyad', ar: 'الاسم الكامل', en: 'Full name'),
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: _tx(tr: 'E-posta', ar: 'البريد الإلكتروني', en: 'Email'),
                    prefixIcon: const Icon(Icons.alternate_email_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<AppRole>(
                  value: selectedRole,
                  decoration: InputDecoration(
                    labelText: _tx(tr: 'Rol', ar: 'الرتبة', en: 'Role'),
                    prefixIcon: const Icon(Icons.badge_outlined),
                  ),
                  items: AppRole.values
                      .map(
                        (role) => DropdownMenuItem(
                          value: role,
                          child: Row(
                            children: [
                              Icon(role.icon, color: role.accent, size: 20),
                              const SizedBox(width: 10),
                              Text(role.label(widget.languageCode)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => selectedRole = value);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_tx(tr: 'İptal', ar: 'إلغاء', en: 'Cancel')),
            ),
            FilledButton.icon(
              onPressed: () {
                final name = nameController.text.trim();
                final email = emailController.text.trim();
                if (name.isEmpty || !email.contains('@')) return;
                Navigator.pop(
                  context,
                  _ManagedUser(
                    name: name,
                    email: email,
                    role: selectedRole,
                    active: true,
                  ),
                );
              },
              icon: const Icon(Icons.person_add_alt_1_rounded),
              label: Text(_tx(tr: 'Oluştur', ar: 'إنشاء', en: 'Create')),
            ),
          ],
        ),
      ),
    );

    nameController.dispose();
    emailController.dispose();

    if (created != null) {
      setState(() => _users.insert(0, created));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _tx(
              tr: 'Kullanıcı oluşturuldu',
              ar: 'تم إنشاء المستخدم',
              en: 'User created',
            ),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final users = _filteredUsers;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tx(
            tr: 'Kullanıcılar ve roller',
            ar: 'المستخدمون والرتب',
            en: 'Users and roles',
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 16),
            child: FilledButton.icon(
              onPressed: _openCreateUser,
              icon: const Icon(Icons.add_rounded),
              label: Text(
                _tx(tr: 'Kullanıcı ekle', ar: 'إضافة مستخدم', en: 'Add user'),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _StatCard(
                  icon: Icons.groups_rounded,
                  label: _tx(tr: 'Toplam kullanıcı', ar: 'إجمالي المستخدمين', en: 'Total users'),
                  value: '${_users.length}',
                  accent: const Color(0xFF0879B8),
                ),
                _StatCard(
                  icon: Icons.verified_user_rounded,
                  label: _tx(tr: 'Aktif', ar: 'نشط', en: 'Active'),
                  value: '${_users.where((user) => user.active).length}',
                  accent: const Color(0xFF159776),
                ),
                _StatCard(
                  icon: Icons.admin_panel_settings_rounded,
                  label: _tx(tr: 'Yönetici', ar: 'إداريون', en: 'Executives'),
                  value: '${_users.where((user) => user.role.isExecutive).length}',
                  accent: const Color(0xFF7657D9),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: _tx(
                        tr: 'Ad veya e-posta ara...',
                        ar: 'ابحث بالاسم أو البريد...',
                        en: 'Search name or email...',
                      ),
                      prefixIcon: const Icon(Icons.search_rounded),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 240,
                  child: DropdownButtonFormField<AppRole?>(
                    value: _roleFilter,
                    decoration: InputDecoration(
                      labelText: _tx(tr: 'Rol filtresi', ar: 'تصفية الرتب', en: 'Role filter'),
                    ),
                    items: [
                      DropdownMenuItem<AppRole?>(
                        value: null,
                        child: Text(_tx(tr: 'Tüm roller', ar: 'كل الرتب', en: 'All roles')),
                      ),
                      ...AppRole.values.map(
                        (role) => DropdownMenuItem<AppRole?>(
                          value: role,
                          child: Text(role.label(widget.languageCode)),
                        ),
                      ),
                    ],
                    onChanged: (value) => setState(() => _roleFilter = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: users.isEmpty
                    ? Center(
                        child: Text(
                          _tx(
                            tr: 'Kullanıcı bulunamadı',
                            ar: 'لا يوجد مستخدمون',
                            en: 'No users found',
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: users.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            leading: CircleAvatar(
                              backgroundColor: user.role.accent.withValues(alpha: .14),
                              child: Icon(user.role.icon, color: user.role.accent),
                            ),
                            title: Text(user.name),
                            subtitle: Text(user.email),
                            trailing: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 12,
                              children: [
                                Chip(
                                  avatar: Icon(user.role.icon, size: 16, color: user.role.accent),
                                  label: Text(user.role.label(widget.languageCode)),
                                ),
                                Switch(
                                  value: user.active,
                                  onChanged: (value) {
                                    final actualIndex = _users.indexOf(user);
                                    setState(() {
                                      _users[actualIndex] = user.copyWith(active: value);
                                    });
                                  },
                                ),
                                PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'delete') {
                                      setState(() => _users.remove(user));
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'permissions',
                                      child: Text(
                                        _tx(
                                          tr: 'Yetkileri görüntüle',
                                          ar: 'عرض الصلاحيات',
                                          en: 'View permissions',
                                        ),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text(
                                        _tx(tr: 'Sil', ar: 'حذف', en: 'Delete'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ManagedUser {
  const _ManagedUser({
    required this.name,
    required this.email,
    required this.role,
    required this.active,
  });

  final String name;
  final String email;
  final AppRole role;
  final bool active;

  _ManagedUser copyWith({bool? active}) => _ManagedUser(
        name: name,
        email: email,
        role: role,
        active: active ?? this.active,
      );
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(value, style: Theme.of(context).textTheme.headlineSmall),
                    Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
