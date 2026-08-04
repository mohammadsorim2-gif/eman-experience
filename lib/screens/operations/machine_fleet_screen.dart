import 'package:flutter/material.dart';

class MachineFleetScreen extends StatefulWidget {
  const MachineFleetScreen({required this.languageCode, super.key});

  final String languageCode;

  @override
  State<MachineFleetScreen> createState() => _MachineFleetScreenState();
}

class _MachineFleetScreenState extends State<MachineFleetScreen> {
  final lines = <_ProductionLine>[
    const _ProductionLine(
      nameAr: 'استلام وفحص المواد الخام',
      nameTr: 'Hammadde kabul ve kontrol',
      nameEn: 'Raw material receiving',
      stageAr: 'المواد الخام',
      stageTr: 'Hammadde',
      stageEn: 'Raw materials',
      status: _LineStatus.running,
      efficiency: 96,
      currentJob: 'RM-2408-17',
    ),
    const _ProductionLine(
      nameAr: 'خط الخلط وتركيب الوصفات',
      nameTr: 'Karışım ve reçete hattı',
      nameEn: 'Blending and formulation line',
      stageAr: 'الخلط',
      stageTr: 'Karışım',
      stageEn: 'Blending',
      status: _LineStatus.running,
      efficiency: 92,
      currentJob: 'VAL-ORANGE-20G',
    ),
    const _ProductionLine(
      nameAr: 'خط التعبئة والوزن الآلي',
      nameTr: 'Otomatik dolum ve tartım hattı',
      nameEn: 'Automatic filling and weighing line',
      stageAr: 'التعبئة',
      stageTr: 'Dolum',
      stageEn: 'Filling',
      status: _LineStatus.running,
      efficiency: 89,
      currentJob: 'EMAN-MANGO-25G',
    ),
    const _ProductionLine(
      nameAr: 'خط الإغلاق الحراري',
      nameTr: 'Isıl yapıştırma hattı',
      nameEn: 'Heat sealing line',
      stageAr: 'الإغلاق',
      stageTr: 'Yapıştırma',
      stageEn: 'Sealing',
      status: _LineStatus.maintenance,
      efficiency: 71,
      currentJob: 'PM-SEA-04',
    ),
    const _ProductionLine(
      nameAr: 'طباعة تاريخ الإنتاج والانتهاء',
      nameTr: 'Üretim ve son kullanma tarihi kodlama',
      nameEn: 'Date coding station',
      stageAr: 'الترميز',
      stageTr: 'Kodlama',
      stageEn: 'Coding',
      status: _LineStatus.running,
      efficiency: 94,
      currentJob: 'LOT-240804-B',
    ),
    const _ProductionLine(
      nameAr: 'فحص الجودة والوزن',
      nameTr: 'Kalite ve ağırlık kontrolü',
      nameEn: 'Quality and weight inspection',
      stageAr: 'الجودة',
      stageTr: 'Kalite',
      stageEn: 'Quality',
      status: _LineStatus.running,
      efficiency: 98,
      currentJob: 'QC-240804-06',
    ),
    const _ProductionLine(
      nameAr: 'التغليف بالكرتون',
      nameTr: 'Karton paketleme hattı',
      nameEn: 'Carton packing line',
      stageAr: 'التغليف',
      stageTr: 'Paketleme',
      stageEn: 'Packing',
      status: _LineStatus.idle,
      efficiency: 83,
      currentJob: 'WAITING',
    ),
    const _ProductionLine(
      nameAr: 'الترصيص على الطبليات',
      nameTr: 'Paletleme hattı',
      nameEn: 'Palletizing line',
      stageAr: 'الطبليات',
      stageTr: 'Paletleme',
      stageEn: 'Palletizing',
      status: _LineStatus.running,
      efficiency: 87,
      currentJob: 'PAL-240804-12',
    ),
  ];

  String _tx({required String ar, required String tr, required String en}) =>
      switch (widget.languageCode) {'ar' => ar, 'tr' => tr, _ => en};

  @override
  Widget build(BuildContext context) {
    final running = lines.where((item) => item.status == _LineStatus.running).length;
    final maintenance =
        lines.where((item) => item.status == _LineStatus.maintenance).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tx(
            ar: 'خطوط إنتاج العصائر سريعة التحضير',
            tr: 'Toz içecek üretim hatları',
            en: 'Instant drink production lines',
          ),
        ),
        actions: [
          IconButton(
            tooltip: _tx(ar: 'إضافة خط', tr: 'Hat ekle', en: 'Add line'),
            onPressed: _showAddLine,
            icon: const Icon(Icons.add_circle_outline_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _SummaryHeader(
            languageCode: widget.languageCode,
            total: lines.length,
            running: running,
            maintenance: maintenance,
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1100
                  ? 3
                  : constraints.maxWidth >= 700
                      ? 2
                      : 1;
              const gap = 16.0;
              final width =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (var index = 0; index < lines.length; index++)
                    SizedBox(
                      width: width,
                      child: _ProductionLineCard(
                        line: lines[index],
                        languageCode: widget.languageCode,
                        onStatusChanged: (status) => setState(
                          () => lines[index] =
                              lines[index].copyWith(status: status),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddLine,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          _tx(ar: 'خط جديد', tr: 'Yeni hat', en: 'New line'),
        ),
      ),
    );
  }

  Future<void> _showAddLine() async {
    final nameController = TextEditingController();
    final stageController = TextEditingController();
    final result = await showDialog<_ProductionLine>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          _tx(ar: 'إضافة خط إنتاج', tr: 'Üretim hattı ekle', en: 'Add production line'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: _tx(ar: 'اسم الخط', tr: 'Hat adı', en: 'Line name'),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: stageController,
              decoration: InputDecoration(
                labelText: _tx(ar: 'مرحلة الإنتاج', tr: 'Üretim aşaması', en: 'Production stage'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_tx(ar: 'إلغاء', tr: 'İptal', en: 'Cancel')),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) return;
              final stage = stageController.text.trim();
              Navigator.pop(
                context,
                _ProductionLine(
                  nameAr: nameController.text.trim(),
                  nameTr: nameController.text.trim(),
                  nameEn: nameController.text.trim(),
                  stageAr: stage,
                  stageTr: stage,
                  stageEn: stage,
                  status: _LineStatus.idle,
                  efficiency: 0,
                  currentJob: '-',
                ),
              );
            },
            child: Text(_tx(ar: 'إضافة', tr: 'Ekle', en: 'Add')),
          ),
        ],
      ),
    );
    nameController.dispose();
    stageController.dispose();
    if (result != null && mounted) setState(() => lines.add(result));
  }
}

enum _LineStatus { running, idle, maintenance, cleaning }

class _ProductionLine {
  const _ProductionLine({
    required this.nameAr,
    required this.nameTr,
    required this.nameEn,
    required this.stageAr,
    required this.stageTr,
    required this.stageEn,
    required this.status,
    required this.efficiency,
    required this.currentJob,
  });

  final String nameAr;
  final String nameTr;
  final String nameEn;
  final String stageAr;
  final String stageTr;
  final String stageEn;
  final _LineStatus status;
  final int efficiency;
  final String currentJob;

  _ProductionLine copyWith({_LineStatus? status}) => _ProductionLine(
        nameAr: nameAr,
        nameTr: nameTr,
        nameEn: nameEn,
        stageAr: stageAr,
        stageTr: stageTr,
        stageEn: stageEn,
        status: status ?? this.status,
        efficiency: efficiency,
        currentJob: currentJob,
      );
}

class _SummaryHeader extends StatelessWidget {
  const _SummaryHeader({
    required this.languageCode,
    required this.total,
    required this.running,
    required this.maintenance,
  });

  final String languageCode;
  final int total;
  final int running;
  final int maintenance;

  String _tx({required String ar, required String tr, required String en}) =>
      switch (languageCode) {'ar' => ar, 'tr' => tr, _ => en};

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 28,
          runSpacing: 16,
          children: [
            _SummaryItem(
              label: _tx(ar: 'إجمالي المحطات', tr: 'Toplam istasyon', en: 'Total stations'),
              value: '$total',
              icon: Icons.factory_rounded,
            ),
            _SummaryItem(
              label: _tx(ar: 'قيد التشغيل', tr: 'Çalışıyor', en: 'Running'),
              value: '$running',
              icon: Icons.play_circle_fill_rounded,
            ),
            _SummaryItem(
              label: _tx(ar: 'تحت الصيانة', tr: 'Bakımda', en: 'Maintenance'),
              value: '$maintenance',
              icon: Icons.build_circle_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(child: Icon(icon)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: Theme.of(context).textTheme.titleLarge),
            Text(label),
          ],
        ),
      ],
    );
  }
}

class _ProductionLineCard extends StatelessWidget {
  const _ProductionLineCard({
    required this.line,
    required this.languageCode,
    required this.onStatusChanged,
  });

  final _ProductionLine line;
  final String languageCode;
  final ValueChanged<_LineStatus> onStatusChanged;

  String _tx({required String ar, required String tr, required String en}) =>
      switch (languageCode) {'ar' => ar, 'tr' => tr, _ => en};

  String get _name => switch (languageCode) {
        'ar' => line.nameAr,
        'tr' => line.nameTr,
        _ => line.nameEn,
      };

  String get _stage => switch (languageCode) {
        'ar' => line.stageAr,
        'tr' => line.stageTr,
        _ => line.stageEn,
      };

  @override
  Widget build(BuildContext context) {
    final color = switch (line.status) {
      _LineStatus.running => const Color(0xFF159776),
      _LineStatus.idle => const Color(0xFFE87A35),
      _LineStatus.maintenance => const Color(0xFFD94F70),
      _LineStatus.cleaning => const Color(0xFF0879B8),
    };
    final statusLabel = switch (line.status) {
      _LineStatus.running => _tx(ar: 'تعمل', tr: 'Çalışıyor', en: 'Running'),
      _LineStatus.idle => _tx(ar: 'متوقفة', tr: 'Beklemede', en: 'Idle'),
      _LineStatus.maintenance => _tx(ar: 'صيانة', tr: 'Bakımda', en: 'Maintenance'),
      _LineStatus.cleaning => _tx(ar: 'تنظيف وتعقيم', tr: 'Temizlik', en: 'Cleaning'),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withValues(alpha: .14),
                  child: Icon(Icons.factory_rounded, color: color),
                ),
                const Spacer(),
                PopupMenuButton<_LineStatus>(
                  onSelected: onStatusChanged,
                  itemBuilder: (_) => [
                    for (final status in _LineStatus.values)
                      PopupMenuItem(
                        value: status,
                        child: Text(status.name),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(_name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(_stage),
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(Icons.circle, size: 12, color: color),
                const SizedBox(width: 8),
                Text(statusLabel),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: line.efficiency / 100),
            const SizedBox(height: 6),
            Text(
              '${_tx(ar: 'الكفاءة', tr: 'Verim', en: 'Efficiency')}: ${line.efficiency}%',
            ),
            const SizedBox(height: 10),
            Text(
              '${_tx(ar: 'أمر التشغيل', tr: 'İş emri', en: 'Work order')}: ${line.currentJob}',
            ),
          ],
        ),
      ),
    );
  }
}
