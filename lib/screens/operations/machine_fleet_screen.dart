import 'package:flutter/material.dart';

class MachineFleetScreen extends StatefulWidget {
  const MachineFleetScreen({required this.languageCode, super.key});

  final String languageCode;

  @override
  State<MachineFleetScreen> createState() => _MachineFleetScreenState();
}

class _MachineFleetScreenState extends State<MachineFleetScreen> {
  final machines = <_Machine>[
    const _Machine(name: 'Rotogravure Windmöller', section: 'Printing', status: _MachineStatus.running, efficiency: 94),
    const _Machine(name: 'Flexo 1', section: 'Printing', status: _MachineStatus.running, efficiency: 88),
    const _Machine(name: 'Lamination 1', section: 'Lamination', status: _MachineStatus.maintenance, efficiency: 62),
    const _Machine(name: 'Lamination 2', section: 'Lamination', status: _MachineStatus.running, efficiency: 91),
    const _Machine(name: 'Slitter 1', section: 'Slitting', status: _MachineStatus.idle, efficiency: 76),
    const _Machine(name: 'Slitter 2', section: 'Slitting', status: _MachineStatus.running, efficiency: 89),
  ];

  String _tx({required String ar, required String tr, required String en}) =>
      switch (widget.languageCode) {'ar' => ar, 'tr' => tr, _ => en};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tx(ar: 'إدارة الآلات', tr: 'Makine yönetimi', en: 'Machine management')),
        actions: [
          IconButton(
            tooltip: _tx(ar: 'إضافة آلة', tr: 'Makine ekle', en: 'Add machine'),
            onPressed: _showAddMachine,
            icon: const Icon(Icons.add_circle_outline_rounded),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 1100 ? 3 : constraints.maxWidth >= 700 ? 2 : 1;
          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.35,
            ),
            itemCount: machines.length,
            itemBuilder: (context, index) => _MachineCard(
              machine: machines[index],
              languageCode: widget.languageCode,
              onStatusChanged: (status) => setState(() => machines[index] = machines[index].copyWith(status: status)),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddMachine,
        icon: const Icon(Icons.add_rounded),
        label: Text(_tx(ar: 'آلة جديدة', tr: 'Yeni makine', en: 'New machine')),
      ),
    );
  }

  Future<void> _showAddMachine() async {
    final nameController = TextEditingController();
    final sectionController = TextEditingController();
    final result = await showDialog<_Machine>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_tx(ar: 'إضافة آلة', tr: 'Makine ekle', en: 'Add machine')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: _tx(ar: 'اسم الآلة', tr: 'Makine adı', en: 'Machine name'))),
            const SizedBox(height: 12),
            TextField(controller: sectionController, decoration: InputDecoration(labelText: _tx(ar: 'القسم', tr: 'Bölüm', en: 'Section'))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(_tx(ar: 'إلغاء', tr: 'İptal', en: 'Cancel'))),
          FilledButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) return;
              Navigator.pop(context, _Machine(name: nameController.text.trim(), section: sectionController.text.trim(), status: _MachineStatus.idle, efficiency: 0));
            },
            child: Text(_tx(ar: 'إضافة', tr: 'Ekle', en: 'Add')),
          ),
        ],
      ),
    );
    if (result != null) setState(() => machines.add(result));
  }
}

enum _MachineStatus { running, idle, maintenance }

class _Machine {
  const _Machine({required this.name, required this.section, required this.status, required this.efficiency});
  final String name;
  final String section;
  final _MachineStatus status;
  final int efficiency;

  _Machine copyWith({_MachineStatus? status}) => _Machine(name: name, section: section, status: status ?? this.status, efficiency: efficiency);
}

class _MachineCard extends StatelessWidget {
  const _MachineCard({required this.machine, required this.languageCode, required this.onStatusChanged});
  final _Machine machine;
  final String languageCode;
  final ValueChanged<_MachineStatus> onStatusChanged;

  String _tx({required String ar, required String tr, required String en}) =>
      switch (languageCode) {'ar' => ar, 'tr' => tr, _ => en};

  @override
  Widget build(BuildContext context) {
    final color = switch (machine.status) {
      _MachineStatus.running => const Color(0xFF159776),
      _MachineStatus.idle => const Color(0xFFE87A35),
      _MachineStatus.maintenance => const Color(0xFFD94F70),
    };
    final statusLabel = switch (machine.status) {
      _MachineStatus.running => _tx(ar: 'تعمل', tr: 'Çalışıyor', en: 'Running'),
      _MachineStatus.idle => _tx(ar: 'متوقفة', tr: 'Beklemede', en: 'Idle'),
      _MachineStatus.maintenance => _tx(ar: 'صيانة', tr: 'Bakımda', en: 'Maintenance'),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundColor: color.withValues(alpha: .14), child: Icon(Icons.precision_manufacturing_rounded, color: color)),
                const Spacer(),
                PopupMenuButton<_MachineStatus>(
                  onSelected: onStatusChanged,
                  itemBuilder: (_) => [
                    for (final status in _MachineStatus.values)
                      PopupMenuItem(value: status, child: Text(status.name)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(machine.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(machine.section),
            const Spacer(),
            Row(children: [Icon(Icons.circle, size: 12, color: color), const SizedBox(width: 8), Text(statusLabel)]),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: machine.efficiency / 100),
            const SizedBox(height: 6),
            Text('${_tx(ar: 'الكفاءة', tr: 'Verim', en: 'Efficiency')}: ${machine.efficiency}%'),
          ],
        ),
      ),
    );
  }
}
