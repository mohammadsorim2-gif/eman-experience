import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({required this.languageCode, super.key});

  final String languageCode;

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _loading = true;
  bool _push = true;
  bool _email = true;
  bool _sound = true;
  bool _criticalOnlyAfterHours = true;
  bool _sales = true;
  bool _production = true;
  bool _inventory = true;
  bool _quality = true;
  bool _maintenance = true;
  bool _accounting = true;

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
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _push = prefs.getBool('notify_push') ?? true;
      _email = prefs.getBool('notify_email') ?? true;
      _sound = prefs.getBool('notify_sound') ?? true;
      _criticalOnlyAfterHours =
          prefs.getBool('notify_critical_after_hours') ?? true;
      _sales = prefs.getBool('notify_sales') ?? true;
      _production = prefs.getBool('notify_production') ?? true;
      _inventory = prefs.getBool('notify_inventory') ?? true;
      _quality = prefs.getBool('notify_quality') ?? true;
      _maintenance = prefs.getBool('notify_maintenance') ?? true;
      _accounting = prefs.getBool('notify_accounting') ?? true;
      _loading = false;
    });
  }

  Future<void> _save(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tx(
            tr: 'Bildirim ayarları',
            ar: 'إعدادات الإشعارات',
            en: 'Notification settings',
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _SectionTitle(
                  icon: Icons.send_rounded,
                  title: _tx(
                    tr: 'Kanallar',
                    ar: 'قنوات الإرسال',
                    en: 'Delivery channels',
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Column(
                    children: [
                      _toggle(
                        title: _tx(
                          tr: 'Anlık bildirimler',
                          ar: 'الإشعارات الفورية',
                          en: 'Push notifications',
                        ),
                        subtitle: _tx(
                          tr: 'Uygulama içi ve cihaz bildirimleri',
                          ar: 'تنبيهات داخل التطبيق وعلى الجهاز',
                          en: 'In-app and device alerts',
                        ),
                        icon: Icons.notifications_active_rounded,
                        value: _push,
                        onChanged: (value) {
                          setState(() => _push = value);
                          _save('notify_push', value);
                        },
                      ),
                      const Divider(height: 1),
                      _toggle(
                        title: _tx(
                          tr: 'E-posta bildirimleri',
                          ar: 'إشعارات البريد الإلكتروني',
                          en: 'Email notifications',
                        ),
                        subtitle: _tx(
                          tr: 'Özetler ve kritik uyarılar',
                          ar: 'الملخصات والتنبيهات الحرجة',
                          en: 'Summaries and critical alerts',
                        ),
                        icon: Icons.mark_email_unread_rounded,
                        value: _email,
                        onChanged: (value) {
                          setState(() => _email = value);
                          _save('notify_email', value);
                        },
                      ),
                      const Divider(height: 1),
                      _toggle(
                        title: _tx(
                          tr: 'Sesli uyarılar',
                          ar: 'التنبيهات الصوتية',
                          en: 'Sound alerts',
                        ),
                        subtitle: _tx(
                          tr: 'Önemli bildirimlerde ses çal',
                          ar: 'تشغيل صوت للتنبيهات المهمة',
                          en: 'Play sound for important alerts',
                        ),
                        icon: Icons.volume_up_rounded,
                        value: _sound,
                        onChanged: (value) {
                          setState(() => _sound = value);
                          _save('notify_sound', value);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _SectionTitle(
                  icon: Icons.schedule_rounded,
                  title: _tx(
                    tr: 'Zamanlama',
                    ar: 'الجدولة',
                    en: 'Scheduling',
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: _toggle(
                    title: _tx(
                      tr: 'Mesai dışında yalnızca kritik',
                      ar: 'خارج الدوام: الحرج فقط',
                      en: 'Critical only after hours',
                    ),
                    subtitle: _tx(
                      tr: 'Normal bildirimleri sonraki iş gününe ertele',
                      ar: 'تأجيل التنبيهات العادية إلى يوم العمل التالي',
                      en: 'Delay normal alerts until the next workday',
                    ),
                    icon: Icons.nightlight_round,
                    value: _criticalOnlyAfterHours,
                    onChanged: (value) {
                      setState(() => _criticalOnlyAfterHours = value);
                      _save('notify_critical_after_hours', value);
                    },
                  ),
                ),
                const SizedBox(height: 24),
                _SectionTitle(
                  icon: Icons.tune_rounded,
                  title: _tx(
                    tr: 'Bölüm bildirimleri',
                    ar: 'إشعارات الأقسام',
                    en: 'Module notifications',
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Column(
                    children: [
                      _moduleToggle('sales', Icons.trending_up_rounded,
                          tr: 'Satış', ar: 'المبيعات', en: 'Sales'),
                      const Divider(height: 1),
                      _moduleToggle(
                          'production',
                          Icons.precision_manufacturing_rounded,
                          tr: 'Üretim',
                          ar: 'الإنتاج',
                          en: 'Production'),
                      const Divider(height: 1),
                      _moduleToggle('inventory', Icons.inventory_2_rounded,
                          tr: 'Stok', ar: 'المخزون', en: 'Inventory'),
                      const Divider(height: 1),
                      _moduleToggle('quality', Icons.verified_rounded,
                          tr: 'Kalite', ar: 'الجودة', en: 'Quality'),
                      const Divider(height: 1),
                      _moduleToggle('maintenance', Icons.build_circle_rounded,
                          tr: 'Bakım', ar: 'الصيانة', en: 'Maintenance'),
                      const Divider(height: 1),
                      _moduleToggle('accounting', Icons.account_balance_rounded,
                          tr: 'Muhasebe', ar: 'المحاسبة', en: 'Accounting'),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _moduleToggle(
    String key,
    IconData icon, {
    required String tr,
    required String ar,
    required String en,
  }) {
    final value = switch (key) {
      'sales' => _sales,
      'production' => _production,
      'inventory' => _inventory,
      'quality' => _quality,
      'maintenance' => _maintenance,
      _ => _accounting,
    };

    return _toggle(
      title: _tx(tr: tr, ar: ar, en: en),
      subtitle: _tx(
        tr: 'Bu bölümdeki önemli değişiklikleri bildir',
        ar: 'إرسال تنبيهات عند التغييرات المهمة في هذا القسم',
        en: 'Alert on important changes in this module',
      ),
      icon: icon,
      value: value,
      onChanged: (enabled) {
        setState(() {
          switch (key) {
            case 'sales':
              _sales = enabled;
            case 'production':
              _production = enabled;
            case 'inventory':
              _inventory = enabled;
            case 'quality':
              _quality = enabled;
            case 'maintenance':
              _maintenance = enabled;
            default:
              _accounting = enabled;
          }
        });
        _save('notify_$key', enabled);
      },
    );
  }

  Widget _toggle({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      secondary: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF0879B8).withValues(alpha: .11),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: const Color(0xFF0879B8)),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 10),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}
