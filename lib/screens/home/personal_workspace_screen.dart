import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalWorkspaceScreen extends StatefulWidget {
  const PersonalWorkspaceScreen({
    required this.languageCode,
    required this.onOpen,
    super.key,
  });

  final String languageCode;
  final ValueChanged<String> onOpen;

  @override
  State<PersonalWorkspaceScreen> createState() =>
      _PersonalWorkspaceScreenState();
}

class _PersonalWorkspaceScreenState extends State<PersonalWorkspaceScreen> {
  static const _favoritesKey = 'eman_workspace_favorites';
  static const _quickActionsKey = 'eman_workspace_quick_actions';

  final List<_WorkspaceItem> _items = const [
    _WorkspaceItem(
      id: 'customers',
      tr: 'Müşteriler',
      ar: 'العملاء',
      en: 'Customers',
      icon: Icons.groups_rounded,
      accent: Color(0xFF0879B8),
    ),
    _WorkspaceItem(
      id: 'orders',
      tr: 'Siparişler',
      ar: 'الطلبات',
      en: 'Orders',
      icon: Icons.receipt_long_rounded,
      accent: Color(0xFF7657D9),
    ),
    _WorkspaceItem(
      id: 'production',
      tr: 'Üretim',
      ar: 'الإنتاج',
      en: 'Production',
      icon: Icons.precision_manufacturing_rounded,
      accent: Color(0xFFE87A35),
    ),
    _WorkspaceItem(
      id: 'inventory',
      tr: 'Stok',
      ar: 'المخزون',
      en: 'Inventory',
      icon: Icons.warehouse_rounded,
      accent: Color(0xFF159776),
    ),
    _WorkspaceItem(
      id: 'accounting',
      tr: 'Muhasebe',
      ar: 'المحاسبة',
      en: 'Accounting',
      icon: Icons.account_balance_wallet_rounded,
      accent: Color(0xFF3B68D9),
    ),
    _WorkspaceItem(
      id: 'quality',
      tr: 'Kalite',
      ar: 'الجودة',
      en: 'Quality',
      icon: Icons.verified_rounded,
      accent: Color(0xFF2E7D32),
    ),
    _WorkspaceItem(
      id: 'rfq',
      tr: 'Teklif Talepleri',
      ar: 'طلبات الأسعار',
      en: 'RFQs',
      icon: Icons.request_quote_rounded,
      accent: Color(0xFFD94F70),
    ),
    _WorkspaceItem(
      id: 'reports',
      tr: 'Raporlar',
      ar: 'التقارير',
      en: 'Reports',
      icon: Icons.insights_rounded,
      accent: Color(0xFF8A58C7),
    ),
  ];

  final List<String> _recentIds = [
    'production',
    'orders',
    'inventory',
    'customers',
  ];

  Set<String> _favorites = {};
  List<String> _quickActionIds = [];
  bool _loading = true;

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
    _restore();
  }

  Future<void> _restore() async {
    final preferences = await SharedPreferences.getInstance();
    final favorites = preferences.getStringList(_favoritesKey) ?? const [];
    final quickActions =
        preferences.getStringList(_quickActionsKey) ??
        const ['customers', 'orders', 'production', 'inventory'];

    if (!mounted) return;
    setState(() {
      _favorites = favorites.toSet();
      _quickActionIds = quickActions
          .where((id) => _items.any((item) => item.id == id))
          .toList();
      _loading = false;
    });
  }

  Future<void> _save() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(_favoritesKey, _favorites.toList());
    await preferences.setStringList(_quickActionsKey, _quickActionIds);
  }

  void _toggleFavorite(String id) {
    setState(() {
      _favorites.contains(id) ? _favorites.remove(id) : _favorites.add(id);
    });
    _save();
  }

  void _open(_WorkspaceItem item) {
    _recentIds.remove(item.id);
    _recentIds.insert(0, item.id);
    if (_recentIds.length > 6) _recentIds.removeLast();
    setState(() {});
    widget.onOpen(item.id);
  }

  Future<void> _customizeQuickActions() async {
    final selected = _quickActionIds.toSet();
    final result = await showDialog<Set<String>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(
              _tx(
                tr: 'Hızlı işlemleri özelleştir',
                ar: 'تخصيص الإجراءات السريعة',
                en: 'Customize quick actions',
              ),
            ),
            content: SizedBox(
              width: 520,
              child: ListView(
                shrinkWrap: true,
                children: _items.map((item) {
                  final enabled = selected.contains(item.id);
                  return CheckboxListTile(
                    value: enabled,
                    onChanged: (value) {
                      setDialogState(() {
                        if (value == true && selected.length < 6) {
                          selected.add(item.id);
                        } else if (value == false) {
                          selected.remove(item.id);
                        }
                      });
                    },
                    secondary: CircleAvatar(
                      backgroundColor: item.accent.withValues(alpha: .12),
                      child: Icon(item.icon, color: item.accent),
                    ),
                    title: Text(item.label(widget.languageCode)),
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(_tx(tr: 'İptal', ar: 'إلغاء', en: 'Cancel')),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, selected),
                child: Text(_tx(tr: 'Kaydet', ar: 'حفظ', en: 'Save')),
              ),
            ],
          );
        },
      ),
    );

    if (result == null) return;
    setState(() {
      _quickActionIds = _items
          .where((item) => result.contains(item.id))
          .map((item) => item.id)
          .toList();
    });
    await _save();
  }

  List<_WorkspaceItem> _resolve(Iterable<String> ids) {
    return ids
        .map((id) => _items.where((item) => item.id == id).firstOrNull)
        .whereType<_WorkspaceItem>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final quickActions = _resolve(_quickActionIds);
    final favorites = _items.where((item) => _favorites.contains(item.id)).toList();
    final recents = _resolve(_recentIds);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tx(
            tr: 'Kişisel çalışma alanım',
            ar: 'مساحة عملي',
            en: 'My workspace',
          ),
        ),
        actions: [
          IconButton(
            tooltip: _tx(
              tr: 'Hızlı işlemleri düzenle',
              ar: 'تعديل الإجراءات السريعة',
              en: 'Edit quick actions',
            ),
            onPressed: _customizeQuickActions,
            icon: const Icon(Icons.tune_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _WorkspaceHero(
            title: _tx(
              tr: 'Günlük işlerinize tek yerden ulaşın',
              ar: 'وصل إلى أعمالك اليومية من مكان واحد',
              en: 'Reach your daily work from one place',
            ),
            subtitle: _tx(
              tr: 'Favoriler, son kullanılanlar ve kişisel hızlı işlemleriniz burada.',
              ar: 'المفضلة وآخر العناصر والإجراءات السريعة المخصصة لك هنا.',
              en: 'Favorites, recents and your personalized quick actions are here.',
            ),
          ),
          const SizedBox(height: 24),
          _SectionHeader(
            title: _tx(
              tr: 'Hızlı işlemler',
              ar: 'إجراءات سريعة',
              en: 'Quick actions',
            ),
            actionLabel: _tx(tr: 'Düzenle', ar: 'تعديل', en: 'Edit'),
            onAction: _customizeQuickActions,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: quickActions
                .map(
                  (item) => _QuickActionCard(
                    item: item,
                    languageCode: widget.languageCode,
                    favorite: _favorites.contains(item.id),
                    onTap: () => _open(item),
                    onFavorite: () => _toggleFavorite(item.id),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 30),
          _SectionHeader(
            title: _tx(tr: 'Favoriler', ar: 'المفضلة', en: 'Favorites'),
          ),
          const SizedBox(height: 12),
          if (favorites.isEmpty)
            _EmptyState(
              icon: Icons.favorite_border_rounded,
              label: _tx(
                tr: 'Henüz favori eklemediniz',
                ar: 'لم تضف أي عنصر إلى المفضلة بعد',
                en: 'You have not added favorites yet',
              ),
            )
          else
            _HorizontalItemList(
              items: favorites,
              languageCode: widget.languageCode,
              favorites: _favorites,
              onOpen: _open,
              onFavorite: _toggleFavorite,
            ),
          const SizedBox(height: 30),
          _SectionHeader(
            title: _tx(
              tr: 'Son kullanılanlar',
              ar: 'آخر العناصر المستخدمة',
              en: 'Recently used',
            ),
          ),
          const SizedBox(height: 12),
          _HorizontalItemList(
            items: recents,
            languageCode: widget.languageCode,
            favorites: _favorites,
            onOpen: _open,
            onFavorite: _toggleFavorite,
          ),
        ],
      ),
    );
  }
}

class _WorkspaceItem {
  const _WorkspaceItem({
    required this.id,
    required this.tr,
    required this.ar,
    required this.en,
    required this.icon,
    required this.accent,
  });

  final String id;
  final String tr;
  final String ar;
  final String en;
  final IconData icon;
  final Color accent;

  String label(String languageCode) => switch (languageCode) {
        'tr' => tr,
        'ar' => ar,
        _ => en,
      };
}

class _WorkspaceHero extends StatelessWidget {
  const _WorkspaceHero({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF052A43), Color(0xFF0879B8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            blurRadius: 30,
            offset: Offset(0, 16),
            color: Color(0x22000000),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .14),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: .82),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        if (actionLabel != null && onAction != null)
          TextButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.tune_rounded, size: 18),
            label: Text(actionLabel!),
          ),
      ],
    );
  }
}

class _QuickActionCard extends StatefulWidget {
  const _QuickActionCard({
    required this.item,
    required this.languageCode,
    required this.favorite,
    required this.onTap,
    required this.onFavorite,
  });

  final _WorkspaceItem item;
  final String languageCode;
  final bool favorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 220,
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        child: Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: widget.item.accent.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(widget.item.icon, color: widget.item.accent),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: widget.onFavorite,
                        icon: Icon(
                          widget.favorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: widget.favorite ? Colors.redAccent : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    widget.item.label(widget.languageCode),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Icon(Icons.arrow_forward_rounded, color: widget.item.accent),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HorizontalItemList extends StatelessWidget {
  const _HorizontalItemList({
    required this.items,
    required this.languageCode,
    required this.favorites,
    required this.onOpen,
    required this.onFavorite,
  });

  final List<_WorkspaceItem> items;
  final String languageCode;
  final Set<String> favorites;
  final ValueChanged<_WorkspaceItem> onOpen;
  final ValueChanged<String> onFavorite;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return SizedBox(
            width: 280,
            child: Card(
              child: ListTile(
                onTap: () => onOpen(item),
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: item.accent.withValues(alpha: .12),
                  child: Icon(item.icon, color: item.accent),
                ),
                title: Text(item.label(languageCode)),
                trailing: IconButton(
                  onPressed: () => onFavorite(item.id),
                  icon: Icon(
                    favorites.contains(item.id)
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: favorites.contains(item.id)
                        ? Colors.redAccent
                        : null,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE4ECF1)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 42),
          const SizedBox(height: 12),
          Text(label),
        ],
      ),
    );
  }
}
