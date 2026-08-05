import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModuleManagementScreen extends StatefulWidget {
  const ModuleManagementScreen({required this.languageCode, super.key});

  final String languageCode;

  @override
  State<ModuleManagementScreen> createState() =>
      _ModuleManagementScreenState();
}

class _ModuleManagementScreenState extends State<ModuleManagementScreen> {
  static const _storageKey = 'admin_enabled_modules';
  bool _loading = true;
  String _query = '';

  final List<_AppModule> _modules = [
    _AppModule(
      id: 'sales',
      tr: 'Satış ve müşteriler',
      ar: 'المبيعات والعملاء',
      en: 'Sales and customers',
      icon: Icons.point_of_sale_rounded,
      accent: const Color(0xFF159776),
      enabled: true,
      locked: true,
    ),
    _AppModule(
      id: 'orders',
      tr: 'Siparişler ve RFQ',
      ar: 'الطلبات وعروض الأسعار',
      en: 'Orders and RFQs',
      icon: Icons.receipt_long_rounded,
      accent: const Color(0xFF0879B8),
      enabled: true,
      locked: true,
    ),
    _AppModule(
      id: 'production',
      tr: 'Üretim planlama',
      ar: 'تخطيط الإنتاج',
      en: 'Production planning',
      icon: Icons.factory_rounded,
      accent: const Color(0xFFE87A35),
      enabled: true,
    ),
    _AppModule(
      id: 'machines',
      tr: 'Makine takibi',
      ar: 'متابعة الآلات',
      en: 'Machine monitoring',
      icon: Icons.precision_manufacturing_rounded,
      accent: const Color(0xFFD94F70),
      enabled: true,
    ),
    _AppModule(
      id: 'inventory',
      tr: 'Depo ve stok',
      ar: 'المستودع والمخزون',
      en: 'Warehouse and inventory',
      icon: Icons.inventory_2_rounded,
      accent: const Color(0xFF536773),
      enabled: true,
    ),
    _AppModule(
      id: 'quality',
      tr: 'Kalite kontrol',
      ar: 'مراقبة الجودة',
      en: 'Quality control',
      icon: Icons.verified_rounded,
      accent: const Color(0xFF2E7D32),
      enabled: true,
    ),
    _AppModule(
      id: 'accounting',
      tr: 'Muhasebe',
      ar: 'المحاسبة',
      en: 'Accounting',
      icon: Icons.account_balance_wallet_rounded,
      accent: const Color(0xFF0277BD),
      enabled: true,
    ),
    _AppModule(
      id: 'purchasing',
      tr: 'Satın alma',
      ar: 'المشتريات',
      en: 'Purchasing',
      icon: Icons.shopping_cart_checkout_rounded,
      accent: const Color(0xFF6D4C41),
      enabled: true,
    ),
    _AppModule(
      id: 'logistics',
      tr: 'Lojistik ve sevkiyat',
      ar: 'اللوجستيات والشحن',
      en: 'Logistics and shipping',
      icon: Icons.local_shipping_rounded,
      accent: const Color(0xFF3949AB),
      enabled: true,
    ),
    _AppModule(
      id: 'hr',
      tr: 'İnsan kaynakları',
      ar: 'الموارد البشرية',
      en: 'Human resources',
      icon: Icons.groups_rounded,
      accent: const Color(0xFF00838F),
      enabled: false,
    ),
    _AppModule(
      id: 'maintenance',
      tr: 'Bakım yönetimi',
      ar: 'إدارة الصيانة',
      en: 'Maintenance management',
      icon: Icons.build_circle_rounded,
      accent: const Color(0xFF546E7A),
      enabled: true,
    ),
    _AppModule(
      id: 'analytics',
      tr: 'Gelişmiş analiz',
      ar: 'التحليلات المتقدمة',
      en: 'Advanced analytics',
      icon: Icons.insights_rounded,
      accent: const Color(0xFF7657D9),
      enabled: true,
    ),
  ];

  String _tx({required String tr, required String ar, required String en}) {
    return switch (widget.languageCode) {
      'tr' => tr,
      'ar' => ar,
      _ => en,
    };
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final preferences = await SharedPreferences.getInstance();
    final saved = preferences.getStringList(_storageKey);
    if (saved != null) {
      for (final module in _modules) {
        if (!module.locked) module.enabled = saved.contains(module.id);
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _save() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      _storageKey,
      _modules.where((module) => module.enabled).map((module) => module.id).toList(),
    );
  }

  List<_AppModule> get _visibleModules {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return _modules;
    return _modules.where((module) {
      return module.label(widget.languageCode).toLowerCase().contains(query) ||
          module.id.contains(query);
    }).toList();
  }

  Future<void> _toggle(_AppModule module, bool enabled) async {
    if (module.locked) return;
    setState(() => module.enabled = enabled);
    await _save();
  }

  Future<void> _enableAll() async {
    setState(() {
      for (final module in _modules) {
        module.enabled = true;
      }
    });
    await _save();
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visibleModules;
    final enabledCount = _modules.where((module) => module.enabled).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tx(
            tr: 'Uygulama modülleri',
            ar: 'وحدات التطبيق',
            en: 'Application modules',
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: _enableAll,
            icon: const Icon(Icons.done_all_rounded),
            label: Text(
              _tx(tr: 'Tümünü etkinleştir', ar: 'تفعيل الكل', en: 'Enable all'),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _SummaryCard(
                        icon: Icons.widgets_rounded,
                        label: _tx(tr: 'Toplam', ar: 'الإجمالي', en: 'Total'),
                        value: '${_modules.length}',
                        accent: const Color(0xFF0879B8),
                      ),
                      _SummaryCard(
                        icon: Icons.toggle_on_rounded,
                        label: _tx(tr: 'Etkin', ar: 'مفعّل', en: 'Enabled'),
                        value: '$enabledCount',
                        accent: const Color(0xFF159776),
                      ),
                      _SummaryCard(
                        icon: Icons.toggle_off_rounded,
                        label: _tx(tr: 'Kapalı', ar: 'معطّل', en: 'Disabled'),
                        value: '${_modules.length - enabledCount}',
                        accent: const Color(0xFFD94F70),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    onChanged: (value) => setState(() => _query = value),
                    decoration: InputDecoration(
                      hintText: _tx(
                        tr: 'Modül ara...',
                        ar: 'ابحث عن وحدة...',
                        en: 'Search modules...',
                      ),
                      prefixIcon: const Icon(Icons.search_rounded),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final columns = constraints.maxWidth >= 1100
                            ? 3
                            : constraints.maxWidth >= 720
                                ? 2
                                : 1;
                        final spacing = 14.0;
                        final width =
                            (constraints.maxWidth - spacing * (columns - 1)) /
                                columns;
                        return SingleChildScrollView(
                          child: Wrap(
                            spacing: spacing,
                            runSpacing: spacing,
                            children: [
                              for (final module in visible)
                                SizedBox(
                                  width: width,
                                  child: _ModuleCard(
                                    module: module,
                                    languageCode: widget.languageCode,
                                    onChanged: (value) => _toggle(module, value),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _AppModule {
  _AppModule({
    required this.id,
    required this.tr,
    required this.ar,
    required this.en,
    required this.icon,
    required this.accent,
    required this.enabled,
    this.locked = false,
  });

  final String id;
  final String tr;
  final String ar;
  final String en;
  final IconData icon;
  final Color accent;
  bool enabled;
  final bool locked;

  String label(String languageCode) => switch (languageCode) {
        'tr' => tr,
        'ar' => ar,
        _ => en,
      };
}

class _ModuleCard extends StatefulWidget {
  const _ModuleCard({
    required this.module,
    required this.languageCode,
    required this.onChanged,
  });

  final _AppModule module;
  final String languageCode;
  final ValueChanged<bool> onChanged;

  @override
  State<_ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<_ModuleCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final module = widget.module;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
        child: Card(
          elevation: _hovered ? 5 : 0,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: module.accent.withValues(alpha: .13),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(module.icon, color: module.accent),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module.label(widget.languageCode),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        module.locked
                            ? widget.languageCode == 'ar'
                                ? 'وحدة أساسية لا يمكن تعطيلها'
                                : widget.languageCode == 'tr'
                                    ? 'Kapatılamayan temel modül'
                                    : 'Required core module'
                            : module.enabled
                                ? widget.languageCode == 'ar'
                                    ? 'متاحة للمستخدمين المصرح لهم'
                                    : widget.languageCode == 'tr'
                                        ? 'Yetkili kullanıcılara açık'
                                        : 'Available to authorized users'
                                : widget.languageCode == 'ar'
                                    ? 'مخفية عن جميع المستخدمين'
                                    : widget.languageCode == 'tr'
                                        ? 'Tüm kullanıcılardan gizli'
                                        : 'Hidden from all users',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: module.enabled,
                  onChanged: module.locked ? null : widget.onChanged,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
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
      width: 220,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: Theme.of(context).textTheme.headlineSmall),
                  Text(label),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
