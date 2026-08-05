import 'package:flutter/material.dart';

import '../../core/operations/department_registry.dart';

class DepartmentHubScreen extends StatelessWidget {
  const DepartmentHubScreen({required this.languageCode, super.key});

  final String languageCode;

  String _tx({required String ar, required String tr, required String en}) =>
      switch (languageCode) {'ar' => ar, 'tr' => tr, _ => en};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tx(ar: 'مركز الأقسام', tr: 'Bölüm merkezi', en: 'Department hub')),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 1100
              ? 4
              : constraints.maxWidth >= 720
                  ? 3
                  : constraints.maxWidth >= 480
                      ? 2
                      : 1;
          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.25,
            ),
            itemCount: DepartmentRegistry.departments.length,
            itemBuilder: (context, index) {
              final department = DepartmentRegistry.departments[index];
              return _DepartmentCard(
                department: department,
                languageCode: languageCode,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => DepartmentOverviewScreen(
                      languageCode: languageCode,
                      department: department,
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
}

class _DepartmentCard extends StatelessWidget {
  const _DepartmentCard({required this.department, required this.languageCode, required this.onTap});
  final DepartmentDefinition department;
  final String languageCode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: department.color.withValues(alpha: .14),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(department.icon, color: department.color),
              ),
              const Spacer(),
              Text(department.label(languageCode), style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(languageCode == 'ar' ? 'فتح لوحة القسم وإجراءاته' : languageCode == 'tr' ? 'Bölüm panelini ve işlemlerini aç' : 'Open department dashboard and actions'),
            ],
          ),
        ),
      ),
    );
  }
}

class DepartmentOverviewScreen extends StatelessWidget {
  const DepartmentOverviewScreen({required this.languageCode, required this.department, super.key});
  final String languageCode;
  final DepartmentDefinition department;

  String _tx({required String ar, required String tr, required String en}) =>
      switch (languageCode) {'ar' => ar, 'tr' => tr, _ => en};

  @override
  Widget build(BuildContext context) {
    final actions = [
      (Icons.add_task_rounded, _tx(ar: 'مهمة جديدة', tr: 'Yeni görev', en: 'New task')),
      (Icons.list_alt_rounded, _tx(ar: 'قائمة الأعمال', tr: 'İş listesi', en: 'Work list')),
      (Icons.analytics_rounded, _tx(ar: 'تقارير القسم', tr: 'Bölüm raporları', en: 'Department reports')),
      (Icons.notifications_active_rounded, _tx(ar: 'تنبيهات القسم', tr: 'Bölüm uyarıları', en: 'Department alerts')),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(department.label(languageCode))),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: department.color.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              children: [
                Icon(department.icon, size: 42, color: department.color),
                const SizedBox(width: 16),
                Expanded(child: Text(_tx(ar: 'لوحة تشغيل موحدة للقسم، جاهزة لربط البيانات الحقيقية والصلاحيات.', tr: 'Gerçek veriler ve yetkilerle bağlanmaya hazır birleşik bölüm paneli.', en: 'Unified department workspace ready for real data and permissions.'))),
              ],
            ),
          ),
          const SizedBox(height: 20),
          for (final action in actions)
            Card(
              child: ListTile(
                leading: Icon(action.$1, color: department.color),
                title: Text(action.$2),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {},
              ),
            ),
        ],
      ),
    );
  }
}
