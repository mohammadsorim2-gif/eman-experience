import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../data/admin_repository.dart';

class UsersRolesScreen extends StatefulWidget {
  const UsersRolesScreen({super.key});

  @override
  State<UsersRolesScreen> createState() => _UsersRolesScreenState();
}

class _UsersRolesScreenState extends State<UsersRolesScreen> with SingleTickerProviderStateMixin {
  late final TabController tabs;
  late final AdminRepository repo;

  @override
  void initState() {
    super.initState();
    tabs = TabController(length: 2, vsync: this);
    repo = AdminRepository(FirebaseFirestore.instance);
  }

  @override
  void dispose() {
    tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Users, Roles & Audit', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900, color: Color(0xFF173A33))),
            const SizedBox(height: 5),
            const Text('Activate accounts, assign operational responsibility, and review administrative changes.', style: TextStyle(color: Color(0xFF71847F))),
            const SizedBox(height: 18),
            TabBar(controller: tabs, isScrollable: true, tabs: const [Tab(text: 'Users & access'), Tab(text: 'Audit log')]),
          ]),
        ),
        Expanded(child: TabBarView(controller: tabs, children: [_UsersTab(repo: repo), _AuditTab(repo: repo)])),
      ]);
}

class _UsersTab extends StatelessWidget {
  const _UsersTab({required this.repo});
  final AdminRepository repo;

  @override
  Widget build(BuildContext context) => StreamBuilder<List<ErpUserProfile>>(
        stream: repo.watchUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return _Message(icon: Icons.error_outline, text: snapshot.error.toString());
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final users = snapshot.data!;
          if (users.isEmpty) return const _Message(icon: Icons.group_outlined, text: 'No ERP users have requested access yet.');
          return LayoutBuilder(builder: (_, constraints) {
            final columns = constraints.maxWidth >= 1250 ? 3 : constraints.maxWidth >= 760 ? 2 : 1;
            return GridView.builder(
              padding: const EdgeInsets.all(22),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: columns == 1 ? 2.25 : 1.55),
              itemCount: users.length,
              itemBuilder: (_, index) => _UserCard(user: users[index], repo: repo),
            );
          });
        },
      );
}

class _UserCard extends StatelessWidget {
  const _UserCard({required this.user, required this.repo});
  final ErpUserProfile user;
  final AdminRepository repo;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(backgroundColor: user.active ? const Color(0xFFDDF5ED) : const Color(0xFFF3E8E8), child: Icon(user.active ? Icons.person_outline : Icons.person_off_outlined, color: user.active ? const Color(0xFF146C5A) : Colors.red)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(user.displayName.isEmpty ? user.email : user.displayName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                Text(user.email, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF71847F), fontSize: 12)),
              ])),
              _Status(active: user.active),
            ]),
            const Spacer(),
            Wrap(spacing: 8, runSpacing: 8, children: [
              Chip(label: Text(user.role.replaceAll('_', ' '))),
              Chip(avatar: const Icon(Icons.apartment_outlined, size: 16), label: Text(user.department)),
            ]),
            const Spacer(),
            SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () => _edit(context), icon: const Icon(Icons.manage_accounts_outlined), label: const Text('Manage access'))),
          ]),
        ),
      );

  Future<void> _edit(BuildContext context) async {
    var role = user.role;
    var department = user.department;
    var active = user.active;
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(builder: (_, setDialogState) => AlertDialog(
        title: Text('Access · ${user.displayName.isEmpty ? user.email : user.displayName}'),
        content: SizedBox(width: 430, child: Column(mainAxisSize: MainAxisSize.min, children: [
          DropdownButtonFormField<String>(value: AdminRepository.roles.contains(role) ? role : 'viewer', decoration: const InputDecoration(labelText: 'Role'), items: AdminRepository.roles.map((item) => DropdownMenuItem(value: item, child: Text(item.replaceAll('_', ' ')))).toList(), onChanged: (value) => setDialogState(() => role = value!)),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(value: AdminRepository.departments.contains(department) ? department : 'unassigned', decoration: const InputDecoration(labelText: 'Department'), items: AdminRepository.departments.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(), onChanged: (value) => setDialogState(() => department = value!)),
          const SizedBox(height: 10),
          SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('Active ERP access'), subtitle: const Text('Inactive users cannot read factory data.'), value: active, onChanged: (value) => setDialogState(() => active = value)),
        ])),
        actions: [TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Save access'))],
      )),
    );
    if (saved != true) return;
    try {
      await repo.updateUser(user: user, role: role, department: department, active: active);
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User access updated.')));
    } catch (error) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}

class _AuditTab extends StatelessWidget {
  const _AuditTab({required this.repo});
  final AdminRepository repo;

  @override
  Widget build(BuildContext context) => StreamBuilder<List<AuditEntry>>(
        stream: repo.watchAudit(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return _Message(icon: Icons.error_outline, text: snapshot.error.toString());
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final entries = snapshot.data!;
          if (entries.isEmpty) return const _Message(icon: Icons.history_rounded, text: 'No audited actions recorded yet.');
          return ListView.separated(
            padding: const EdgeInsets.all(22),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, index) {
              final item = entries[index];
              return Card(child: ListTile(
                leading: const CircleAvatar(backgroundColor: Color(0xFFE6F4F0), child: Icon(Icons.history_rounded, color: Color(0xFF146C5A))),
                title: Text(item.action.replaceAll('_', ' '), style: const TextStyle(fontWeight: FontWeight.w800)),
                subtitle: Text('${item.entityType} · ${item.entityId}\n${item.actorEmail}${item.createdAt == null ? '' : ' · ${item.createdAt}'}'),
                isThreeLine: true,
                trailing: item.details.isEmpty ? null : IconButton(icon: const Icon(Icons.info_outline), onPressed: () => showDialog<void>(context: context, builder: (_) => AlertDialog(title: const Text('Audit details'), content: SelectableText(item.details.toString()), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))]))),
              ));
            },
          );
        },
      );
}

class _Status extends StatelessWidget {
  const _Status({required this.active});
  final bool active;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: active ? const Color(0xFFDDF5ED) : const Color(0xFFFFECEC), borderRadius: BorderRadius.circular(20)), child: Text(active ? 'Active' : 'Pending', style: TextStyle(color: active ? const Color(0xFF146C5A) : Colors.red, fontSize: 11, fontWeight: FontWeight.w800)));
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 48, color: const Color(0xFF8CA09B)), const SizedBox(height: 12), Text(text, textAlign: TextAlign.center)])));
}
