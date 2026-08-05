import 'package:flutter/material.dart';

class PreventiveMaintenanceScreen extends StatefulWidget {
  const PreventiveMaintenanceScreen({required this.languageCode, super.key});

  final String languageCode;

  @override
  State<PreventiveMaintenanceScreen> createState() => _PreventiveMaintenanceScreenState();
}

class _PreventiveMaintenanceScreenState extends State<PreventiveMaintenanceScreen> {
  final tasks = <_MaintenanceTask>[
    const _MaintenanceTask(asset: 'Mixer 1', task: 'Lubrication and seal inspection', due: '2026-08-05', priority: 'high', completed: false),
    const _MaintenanceTask(asset: 'Sachet filler 1', task: 'Weight calibration', due: '2026-08-06', priority: 'medium', completed: false),
    const _MaintenanceTask(asset: 'Carton sealer', task: 'Belt and sensor check', due: '2026-08-03', priority: 'low', completed: true),
  ];

  String _tx({required String ar, required String tr, required String en}) =>
      switch (widget.languageCode) {'ar' => ar, 'tr' => tr, _ => en};

  @override
  Widget build(BuildContext context) {
    final open = tasks.where((task) => !task.completed).length;
    return Scaffold(
      appBar: AppBar(
        title: Text(_tx(ar: 'الصيانة الوقائية', tr: 'Önleyici bakım', en: 'Preventive maintenance')),
        actions: [IconButton(onPressed: _addTask, icon: const Icon(Icons.add_task_rounded))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _StatCard(label: _tx(ar: 'المهام المفتوحة', tr: 'Açık görevler', en: 'Open tasks'), value: '$open', icon: Icons.build_circle_outlined),
              _StatCard(label: _tx(ar: 'المكتملة', tr: 'Tamamlandı', en: 'Completed'), value: '${tasks.length - open}', icon: Icons.task_alt_rounded),
              _StatCard(label: _tx(ar: 'الأولوية العالية', tr: 'Yüksek öncelik', en: 'High priority'), value: '${tasks.where((task) => task.priority == 'high' && !task.completed).length}', icon: Icons.warning_amber_rounded),
            ],
          ),
          const SizedBox(height: 20),
          for (var index = 0; index < tasks.length; index++)
            Card(
              child: CheckboxListTile(
                value: tasks[index].completed,
                onChanged: (value) => setState(() => tasks[index] = tasks[index].copyWith(completed: value ?? false)),
                secondary: CircleAvatar(child: Icon(_priorityIcon(tasks[index].priority))),
                title: Text(tasks[index].asset),
                subtitle: Text('${tasks[index].task}\n${_tx(ar: 'الاستحقاق', tr: 'Tarih', en: 'Due')}: ${tasks[index].due}'),
                isThreeLine: true,
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTask,
        icon: const Icon(Icons.add_rounded),
        label: Text(_tx(ar: 'مهمة صيانة', tr: 'Bakım görevi', en: 'Maintenance task')),
      ),
    );
  }

  IconData _priorityIcon(String priority) => switch (priority) {
        'high' => Icons.priority_high_rounded,
        'medium' => Icons.remove_rounded,
        _ => Icons.keyboard_arrow_down_rounded,
      };

  Future<void> _addTask() async {
    final asset = TextEditingController();
    final task = TextEditingController();
    final result = await showDialog<_MaintenanceTask>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_tx(ar: 'إضافة مهمة صيانة', tr: 'Bakım görevi ekle', en: 'Add maintenance task')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: asset, decoration: InputDecoration(labelText: _tx(ar: 'المعدة', tr: 'Ekipman', en: 'Asset'))),
            const SizedBox(height: 12),
            TextField(controller: task, decoration: InputDecoration(labelText: _tx(ar: 'المهمة', tr: 'Görev', en: 'Task'))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(_tx(ar: 'إلغاء', tr: 'İptal', en: 'Cancel'))),
          FilledButton(
            onPressed: () {
              if (asset.text.trim().isEmpty || task.text.trim().isEmpty) return;
              Navigator.pop(context, _MaintenanceTask(asset: asset.text.trim(), task: task.text.trim(), due: '2026-08-10', priority: 'medium', completed: false));
            },
            child: Text(_tx(ar: 'إضافة', tr: 'Ekle', en: 'Add')),
          ),
        ],
      ),
    );
    if (result != null) setState(() => tasks.insert(0, result));
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 230,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(children: [CircleAvatar(child: Icon(icon)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: Theme.of(context).textTheme.headlineSmall), Text(label)]))]),
          ),
        ),
      );
}

class _MaintenanceTask {
  const _MaintenanceTask({required this.asset, required this.task, required this.due, required this.priority, required this.completed});
  final String asset;
  final String task;
  final String due;
  final String priority;
  final bool completed;

  _MaintenanceTask copyWith({bool? completed}) => _MaintenanceTask(asset: asset, task: task, due: due, priority: priority, completed: completed ?? this.completed);
}
