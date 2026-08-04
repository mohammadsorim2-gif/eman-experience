import 'package:flutter/material.dart';

class AuditLogScreen extends StatefulWidget {
  const AuditLogScreen({required this.languageCode, super.key});

  final String languageCode;

  @override
  State<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends State<AuditLogScreen> {
  final _searchController = TextEditingController();
  String _category = 'all';
  String _severity = 'all';

  final List<_AuditEntry> _entries = const [
    _AuditEntry(
      actor: 'Khaled Makieh',
      action: 'Updated role permissions',
      target: 'Production Manager',
      category: 'security',
      severity: 'high',
      timestamp: '14:06',
      ipAddress: '10.0.0.18',
      icon: Icons.admin_panel_settings_rounded,
      accent: Color(0xFF7657D9),
    ),
    _AuditEntry(
      actor: 'Abdulsalam',
      action: 'Created a new sales order',
      target: 'SO-2026-0841',
      category: 'sales',
      severity: 'normal',
      timestamp: '13:42',
      ipAddress: '10.0.0.32',
      icon: Icons.receipt_long_rounded,
      accent: Color(0xFF159776),
    ),
    _AuditEntry(
      actor: 'Lutfi',
      action: 'Changed machine status',
      target: 'Rotogravure 01 → Running',
      category: 'production',
      severity: 'normal',
      timestamp: '13:18',
      ipAddress: '10.0.0.44',
      icon: Icons.precision_manufacturing_rounded,
      accent: Color(0xFFE87A35),
    ),
    _AuditEntry(
      actor: 'Zeynep',
      action: 'Rejected quality inspection',
      target: 'QC-2026-0193',
      category: 'quality',
      severity: 'high',
      timestamp: '12:54',
      ipAddress: '10.0.0.51',
      icon: Icons.verified_rounded,
      accent: Color(0xFFD94F70),
    ),
    _AuditEntry(
      actor: 'System',
      action: 'Low stock threshold reached',
      target: 'BOPP 50 micron',
      category: 'inventory',
      severity: 'critical',
      timestamp: '12:31',
      ipAddress: 'system',
      icon: Icons.inventory_2_rounded,
      accent: Color(0xFF536773),
    ),
  ];

  String _tx({required String tr, required String ar, required String en}) {
    return switch (widget.languageCode) {
      'tr' => tr,
      'ar' => ar,
      _ => en,
    };
  }

  List<_AuditEntry> get _filtered {
    final query = _searchController.text.trim().toLowerCase();
    return _entries.where((entry) {
      final matchesQuery = query.isEmpty ||
          entry.actor.toLowerCase().contains(query) ||
          entry.action.toLowerCase().contains(query) ||
          entry.target.toLowerCase().contains(query);
      final matchesCategory = _category == 'all' || entry.category == _category;
      final matchesSeverity = _severity == 'all' || entry.severity == _severity;
      return matchesQuery && matchesCategory && matchesSeverity;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entries = _filtered;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tx(
            tr: 'İşlem geçmişi',
            ar: 'سجل العمليات',
            en: 'Audit log',
          ),
        ),
        actions: [
          IconButton(
            tooltip: _tx(tr: 'Dışa aktar', ar: 'تصدير', en: 'Export'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _tx(
                      tr: 'Rapor dışa aktarılmaya hazır',
                      ar: 'التقرير جاهز للتصدير',
                      en: 'Report is ready to export',
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.download_rounded),
          ),
          const SizedBox(width: 8),
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
                _SummaryCard(
                  label: _tx(tr: 'Bugünkü işlemler', ar: 'عمليات اليوم', en: 'Today events'),
                  value: '${_entries.length}',
                  icon: Icons.history_rounded,
                  accent: const Color(0xFF0879B8),
                ),
                _SummaryCard(
                  label: _tx(tr: 'Yüksek risk', ar: 'مخاطر عالية', en: 'High risk'),
                  value: '${_entries.where((entry) => entry.severity == 'high' || entry.severity == 'critical').length}',
                  icon: Icons.gpp_maybe_rounded,
                  accent: const Color(0xFFD94F70),
                ),
                _SummaryCard(
                  label: _tx(tr: 'Aktif kullanıcı', ar: 'مستخدمون نشطون', en: 'Active users'),
                  value: '${_entries.map((entry) => entry.actor).toSet().length}',
                  icon: Icons.groups_rounded,
                  accent: const Color(0xFF159776),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 360,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: _tx(
                        tr: 'Kullanıcı, işlem veya kayıt ara...',
                        ar: 'ابحث عن مستخدم أو عملية أو سجل...',
                        en: 'Search user, action or record...',
                      ),
                      prefixIcon: const Icon(Icons.search_rounded),
                    ),
                  ),
                ),
                SizedBox(
                  width: 210,
                  child: DropdownButtonFormField<String>(
                    value: _category,
                    decoration: InputDecoration(
                      labelText: _tx(tr: 'Kategori', ar: 'القسم', en: 'Category'),
                    ),
                    items: [
                      _item('all', tr: 'Tümü', ar: 'الكل', en: 'All'),
                      _item('security', tr: 'Güvenlik', ar: 'الأمان', en: 'Security'),
                      _item('sales', tr: 'Satış', ar: 'المبيعات', en: 'Sales'),
                      _item('production', tr: 'Üretim', ar: 'الإنتاج', en: 'Production'),
                      _item('quality', tr: 'Kalite', ar: 'الجودة', en: 'Quality'),
                      _item('inventory', tr: 'Stok', ar: 'المخزون', en: 'Inventory'),
                    ],
                    onChanged: (value) => setState(() => _category = value ?? 'all'),
                  ),
                ),
                SizedBox(
                  width: 210,
                  child: DropdownButtonFormField<String>(
                    value: _severity,
                    decoration: InputDecoration(
                      labelText: _tx(tr: 'Önem', ar: 'الأهمية', en: 'Severity'),
                    ),
                    items: [
                      _item('all', tr: 'Tümü', ar: 'الكل', en: 'All'),
                      _item('normal', tr: 'Normal', ar: 'عادي', en: 'Normal'),
                      _item('high', tr: 'Yüksek', ar: 'مرتفع', en: 'High'),
                      _item('critical', tr: 'Kritik', ar: 'حرج', en: 'Critical'),
                    ],
                    onChanged: (value) => setState(() => _severity = value ?? 'all'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: entries.isEmpty
                    ? Center(
                        child: Text(
                          _tx(
                            tr: 'Kayıt bulunamadı',
                            ar: 'لا توجد سجلات',
                            en: 'No log entries found',
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: entries.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final entry = entries[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            leading: CircleAvatar(
                              backgroundColor: entry.accent.withValues(alpha: .12),
                              child: Icon(entry.icon, color: entry.accent),
                            ),
                            title: Text(entry.action),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: [
                                  Text('${entry.actor} • ${entry.target}'),
                                  Text('IP ${entry.ipAddress}'),
                                ],
                              ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(entry.timestamp),
                                const SizedBox(height: 6),
                                _SeverityBadge(
                                  severity: entry.severity,
                                  languageCode: widget.languageCode,
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

  DropdownMenuItem<String> _item(
    String value, {
    required String tr,
    required String ar,
    required String en,
  }) {
    return DropdownMenuItem(
      value: value,
      child: Text(_tx(tr: tr, ar: ar, en: en)),
    );
  }
}

class _AuditEntry {
  const _AuditEntry({
    required this.actor,
    required this.action,
    required this.target,
    required this.category,
    required this.severity,
    required this.timestamp,
    required this.ipAddress,
    required this.icon,
    required this.accent,
  });

  final String actor;
  final String action;
  final String target;
  final String category;
  final String severity;
  final String timestamp;
  final String ipAddress;
  final IconData icon;
  final Color accent;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
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
              const SizedBox(width: 12),
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

class _SeverityBadge extends StatelessWidget {
  const _SeverityBadge({required this.severity, required this.languageCode});

  final String severity;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final color = switch (severity) {
      'critical' => const Color(0xFFC62828),
      'high' => const Color(0xFFE87A35),
      _ => const Color(0xFF159776),
    };
    final label = switch ((severity, languageCode)) {
      ('critical', 'ar') => 'حرج',
      ('critical', 'tr') => 'Kritik',
      ('critical', _) => 'Critical',
      ('high', 'ar') => 'مرتفع',
      ('high', 'tr') => 'Yüksek',
      ('high', _) => 'High',
      ('normal', 'ar') => 'عادي',
      ('normal', 'tr') => 'Normal',
      _ => 'Normal',
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}
