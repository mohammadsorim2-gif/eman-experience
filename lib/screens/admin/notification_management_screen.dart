import 'package:flutter/material.dart';

import '../notifications/notification_center_screen.dart';
import 'notification_settings_screen.dart';

class NotificationManagementScreen extends StatelessWidget {
  const NotificationManagementScreen({required this.languageCode, super.key});

  final String languageCode;

  String _tx({required String tr, required String ar, required String en}) {
    return switch (languageCode) {
      'tr' => tr,
      'ar' => ar,
      _ => en,
    };
  }

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tx(
            tr: 'Bildirim yönetimi',
            ar: 'إدارة الإشعارات',
            en: 'Notification management',
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF062A44), Color(0xFF0879B8)],
              ),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .14),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.notifications_active_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _tx(
                          tr: 'Tüm uyarıları tek merkezden yönetin',
                          ar: 'تحكم بكل التنبيهات من مركز واحد',
                          en: 'Manage every alert from one place',
                        ),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _tx(
                          tr: 'Gelen bildirimleri takip edin ve kanal tercihlerini düzenleyin.',
                          ar: 'تابع الإشعارات الواردة واضبط القنوات والتفضيلات.',
                          en: 'Review incoming notifications and configure delivery preferences.',
                        ),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: .82),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 760;
              final cards = [
                _ActionCard(
                  title: _tx(
                    tr: 'Bildirim merkezi',
                    ar: 'مركز الإشعارات',
                    en: 'Notification center',
                  ),
                  subtitle: _tx(
                    tr: 'Okunmamış ve acil bildirimleri görüntüleyin',
                    ar: 'عرض الإشعارات غير المقروءة والعاجلة',
                    en: 'Review unread and urgent notifications',
                  ),
                  icon: Icons.notifications_rounded,
                  accent: const Color(0xFF0879B8),
                  onTap: () => _open(
                    context,
                    NotificationCenterScreen(languageCode: languageCode),
                  ),
                ),
                _ActionCard(
                  title: _tx(
                    tr: 'Bildirim ayarları',
                    ar: 'إعدادات الإشعارات',
                    en: 'Notification settings',
                  ),
                  subtitle: _tx(
                    tr: 'Kanallar, ses ve bölüm tercihlerini düzenleyin',
                    ar: 'ضبط القنوات والصوت وإشعارات الأقسام',
                    en: 'Configure channels, sound and module alerts',
                  ),
                  icon: Icons.tune_rounded,
                  accent: const Color(0xFF7657D9),
                  onTap: () => _open(
                    context,
                    NotificationSettingsScreen(languageCode: languageCode),
                  ),
                ),
              ];

              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: cards[0]),
                    const SizedBox(width: 16),
                    Expanded(child: cards[1]),
                  ],
                );
              }

              return Column(
                children: [
                  cards[0],
                  const SizedBox(height: 16),
                  cards[1],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatefulWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        child: Card(
          elevation: _hovered ? 5 : 0,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(22),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: widget.accent.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Icon(widget.icon, color: widget.accent),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(widget.subtitle),
                  const SizedBox(height: 18),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: widget.accent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
