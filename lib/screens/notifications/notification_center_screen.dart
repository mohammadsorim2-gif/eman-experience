import 'package:flutter/material.dart';

class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({required this.languageCode, super.key});

  final String languageCode;

  @override
  State<NotificationCenterScreen> createState() =>
      _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  String _filter = 'all';

  final List<_AppNotification> _items = [
    _AppNotification(
      id: 'n1',
      title: 'New production order',
      body: 'Order EM-24018 has entered the printing stage.',
      type: _NotificationType.production,
      createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
      read: false,
    ),
    _AppNotification(
      id: 'n2',
      title: 'Low stock warning',
      body: 'BOPP 50 micron stock dropped below the minimum level.',
      type: _NotificationType.inventory,
      createdAt: DateTime.now().subtract(const Duration(minutes: 34)),
      read: false,
      urgent: true,
    ),
    _AppNotification(
      id: 'n3',
      title: 'RFQ approved',
      body: 'RFQ-1098 was approved by the general manager.',
      type: _NotificationType.sales,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      read: true,
    ),
    _AppNotification(
      id: 'n4',
      title: 'Quality check completed',
      body: 'Quality control for batch B-772 was completed successfully.',
      type: _NotificationType.quality,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      read: true,
    ),
    _AppNotification(
      id: 'n5',
      title: 'Maintenance request',
      body: 'Flexo machine requires scheduled maintenance review.',
      type: _NotificationType.maintenance,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      read: false,
    ),
  ];

  String _tx({required String tr, required String ar, required String en}) {
    return switch (widget.languageCode) {
      'tr' => tr,
      'ar' => ar,
      _ => en,
    };
  }

  List<_AppNotification> get _visibleItems {
    return _items.where((item) {
      return switch (_filter) {
        'unread' => !item.read,
        'urgent' => item.urgent,
        _ => true,
      };
    }).toList();
  }

  int get _unreadCount => _items.where((item) => !item.read).length;
  int get _urgentCount => _items.where((item) => item.urgent).length;

  void _markAllRead() {
    setState(() {
      for (final item in _items) {
        item.read = true;
      }
    });
  }

  void _remove(_AppNotification item) {
    setState(() => _items.remove(item));
  }

  @override
  Widget build(BuildContext context) {
    final items = _visibleItems;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tx(
            tr: 'Bildirim merkezi',
            ar: 'مركز الإشعارات',
            en: 'Notification center',
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: _unreadCount == 0 ? null : _markAllRead,
            icon: const Icon(Icons.done_all_rounded),
            label: Text(
              _tx(
                tr: 'Tümünü okundu yap',
                ar: 'تحديد الكل كمقروء',
                en: 'Mark all read',
              ),
            ),
          ),
          const SizedBox(width: 12),
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
                  icon: Icons.notifications_active_rounded,
                  label: _tx(
                    tr: 'Toplam',
                    ar: 'الإجمالي',
                    en: 'Total',
                  ),
                  value: '${_items.length}',
                  accent: const Color(0xFF0879B8),
                ),
                _SummaryCard(
                  icon: Icons.mark_email_unread_rounded,
                  label: _tx(
                    tr: 'Okunmamış',
                    ar: 'غير مقروء',
                    en: 'Unread',
                  ),
                  value: '$_unreadCount',
                  accent: const Color(0xFF7657D9),
                ),
                _SummaryCard(
                  icon: Icons.warning_amber_rounded,
                  label: _tx(
                    tr: 'Acil',
                    ar: 'عاجل',
                    en: 'Urgent',
                  ),
                  value: '$_urgentCount',
                  accent: const Color(0xFFE87A35),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(
                  value: 'all',
                  icon: const Icon(Icons.all_inbox_rounded),
                  label: Text(_tx(tr: 'Tümü', ar: 'الكل', en: 'All')),
                ),
                ButtonSegment(
                  value: 'unread',
                  icon: const Icon(Icons.mark_email_unread_rounded),
                  label: Text(
                    _tx(tr: 'Okunmamış', ar: 'غير مقروء', en: 'Unread'),
                  ),
                ),
                ButtonSegment(
                  value: 'urgent',
                  icon: const Icon(Icons.priority_high_rounded),
                  label: Text(_tx(tr: 'Acil', ar: 'عاجل', en: 'Urgent')),
                ),
              ],
              selected: {_filter},
              onSelectionChanged: (selection) {
                setState(() => _filter = selection.first);
              },
            ),
            const SizedBox(height: 18),
            Expanded(
              child: items.isEmpty
                  ? _EmptyState(languageCode: widget.languageCode)
                  : ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Dismissible(
                          key: ValueKey(item.id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) => _remove(item),
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.redAccent,
                            ),
                          ),
                          child: _NotificationTile(
                            item: item,
                            languageCode: widget.languageCode,
                            onTap: () => setState(() => item.read = true),
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

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.item,
    required this.languageCode,
    required this.onTap,
  });

  final _AppNotification item;
  final String languageCode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.read ? Colors.white : const Color(0xFFF4F9FC),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: item.type.accent.withValues(alpha: .13),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(item.type.icon, color: item.type.accent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight:
                                      item.read ? FontWeight.w500 : FontWeight.w700,
                                ),
                          ),
                        ),
                        if (item.urgent)
                          const Icon(
                            Icons.priority_high_rounded,
                            color: Color(0xFFE87A35),
                            size: 18,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(item.body),
                    const SizedBox(height: 8),
                    Text(
                      _formatTime(item.createdAt, languageCode),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (!item.read)
                Container(
                  width: 9,
                  height: 9,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0879B8),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatTime(DateTime date, String languageCode) {
    final difference = DateTime.now().difference(date);
    if (difference.inMinutes < 60) {
      return languageCode == 'ar'
          ? 'منذ ${difference.inMinutes} دقيقة'
          : languageCode == 'tr'
              ? '${difference.inMinutes} dakika önce'
              : '${difference.inMinutes} minutes ago';
    }
    if (difference.inHours < 24) {
      return languageCode == 'ar'
          ? 'منذ ${difference.inHours} ساعة'
          : languageCode == 'tr'
              ? '${difference.inHours} saat önce'
              : '${difference.inHours} hours ago';
    }
    return languageCode == 'ar'
        ? 'منذ ${difference.inDays} يوم'
        : languageCode == 'tr'
            ? '${difference.inDays} gün önce'
            : '${difference.inDays} days ago';
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.languageCode});

  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final text = switch (languageCode) {
      'tr' => 'Bu filtrede bildirim yok',
      'ar' => 'لا توجد إشعارات ضمن هذا التصنيف',
      _ => 'No notifications in this filter',
    };

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.notifications_none_rounded, size: 56),
          const SizedBox(height: 12),
          Text(text, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _AppNotification {
  _AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    required this.read,
    this.urgent = false,
  });

  final String id;
  final String title;
  final String body;
  final _NotificationType type;
  final DateTime createdAt;
  bool read;
  final bool urgent;
}

enum _NotificationType {
  production,
  inventory,
  sales,
  quality,
  maintenance,
}

extension on _NotificationType {
  IconData get icon => switch (this) {
    _NotificationType.production => Icons.precision_manufacturing_rounded,
    _NotificationType.inventory => Icons.inventory_2_rounded,
    _NotificationType.sales => Icons.request_quote_rounded,
    _NotificationType.quality => Icons.verified_rounded,
    _NotificationType.maintenance => Icons.build_circle_rounded,
  };

  Color get accent => switch (this) {
    _NotificationType.production => const Color(0xFFE87A35),
    _NotificationType.inventory => const Color(0xFF536773),
    _NotificationType.sales => const Color(0xFF159776),
    _NotificationType.quality => const Color(0xFF0879B8),
    _NotificationType.maintenance => const Color(0xFFD94F70),
  };
}
