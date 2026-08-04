import 'dart:ui';

import 'package:flutter/material.dart';

import '../notifications/notification_center_screen.dart';
import 'audit_log_screen.dart';
import 'company_settings_screen.dart';
import 'module_management_screen.dart';
import 'role_permission_matrix_screen.dart';
import 'user_management_screen.dart';

class AdminControlCenter extends StatelessWidget {
  const AdminControlCenter({required this.languageCode, super.key});

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
    final sections = <_AdminSection>[
      _AdminSection(
        title: _tx(tr: 'Kullanıcılar', ar: 'المستخدمون', en: 'Users'),
        subtitle: _tx(
          tr: 'Hesapları, durumları ve rolleri yönetin',
          ar: 'إدارة الحسابات والحالة والرتب',
          en: 'Manage accounts, status and roles',
        ),
        icon: Icons.groups_rounded,
        accent: const Color(0xFF0879B8),
        onTap: () => _open(
          context,
          UserManagementScreen(languageCode: languageCode),
        ),
      ),
      _AdminSection(
        title: _tx(
          tr: 'Roller ve yetkiler',
          ar: 'الرتب والصلاحيات',
          en: 'Roles and permissions',
        ),
        subtitle: _tx(
          tr: 'Her rol için erişim matrisini düzenleyin',
          ar: 'تعديل مصفوفة الوصول لكل رتبة',
          en: 'Edit the access matrix for every role',
        ),
        icon: Icons.admin_panel_settings_rounded,
        accent: const Color(0xFF7657D9),
        onTap: () => _open(
          context,
          RolePermissionMatrixScreen(languageCode: languageCode),
        ),
      ),
      _AdminSection(
        title: _tx(
          tr: 'Şirket ayarları',
          ar: 'إعدادات الشركة',
          en: 'Company settings',
        ),
        subtitle: _tx(
          tr: 'Kimlik, iletişim ve operasyon ayarları',
          ar: 'الهوية وبيانات التواصل وإعدادات التشغيل',
          en: 'Identity, contact and operation settings',
        ),
        icon: Icons.business_rounded,
        accent: const Color(0xFF159776),
        onTap: () => _open(
          context,
          CompanySettingsScreen(languageCode: languageCode),
        ),
      ),
      _AdminSection(
        title: _tx(tr: 'Bildirimler', ar: 'الإشعارات', en: 'Notifications'),
        subtitle: _tx(
          tr: 'Canlı uyarıları ve önemli olayları izleyin',
          ar: 'متابعة التنبيهات المباشرة والأحداث المهمة',
          en: 'Review live alerts and important events',
        ),
        icon: Icons.notifications_active_rounded,
        accent: const Color(0xFFE87A35),
        onTap: () => _open(
          context,
          NotificationCenterScreen(languageCode: languageCode),
        ),
      ),
      _AdminSection(
        title: _tx(tr: 'Modüller', ar: 'الوحدات', en: 'Modules'),
        subtitle: _tx(
          tr: 'Uygulama bölümlerini etkinleştirin veya kapatın',
          ar: 'تفعيل أو تعطيل أقسام التطبيق',
          en: 'Enable or disable application sections',
        ),
        icon: Icons.widgets_rounded,
        accent: const Color(0xFFD94F70),
        onTap: () => _open(
          context,
          ModuleManagementScreen(languageCode: languageCode),
        ),
      ),
      _AdminSection(
        title: _tx(
          tr: 'İşlem geçmişi',
          ar: 'سجل العمليات',
          en: 'Audit log',
        ),
        subtitle: _tx(
          tr: 'Kritik değişiklikleri ve kullanıcı hareketlerini izleyin',
          ar: 'متابعة التغييرات المهمة ونشاط المستخدمين',
          en: 'Track critical changes and user activity',
        ),
        icon: Icons.history_rounded,
        accent: const Color(0xFF536773),
        onTap: () => _open(
          context,
          AuditLogScreen(languageCode: languageCode),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            pinned: true,
            title: Text(
              _tx(
                tr: 'Yönetim merkezi',
                ar: 'مركز التحكم',
                en: 'Admin control center',
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
            sliver: SliverList.list(
              children: [
                _HeroPanel(languageCode: languageCode),
                const SizedBox(height: 22),
                Text(
                  _tx(
                    tr: 'Yönetim araçları',
                    ar: 'أدوات الإدارة',
                    en: 'Management tools',
                  ),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 14),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth >= 1180
                        ? 3
                        : constraints.maxWidth >= 720
                            ? 2
                            : 1;
                    const spacing = 16.0;
                    final width =
                        (constraints.maxWidth - spacing * (columns - 1)) /
                            columns;
                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: [
                        for (final section in sections)
                          SizedBox(
                            width: width,
                            child: _AdminCard(section: section),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.languageCode});

  final String languageCode;

  String _tx({required String tr, required String ar, required String en}) {
    return switch (languageCode) {
      'tr' => tr,
      'ar' => ar,
      _ => en,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF062A44), Color(0xFF0879B8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: .18)),
          ),
          child: Wrap(
            spacing: 24,
            runSpacing: 20,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 660),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _tx(
                        tr: 'EMAN ONE üzerinde tam kontrol',
                        ar: 'تحكم كامل بمنصة EMAN ONE',
                        en: 'Full control over EMAN ONE',
                      ),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _tx(
                        tr: 'Kullanıcıları, erişimleri ve şirket ayarlarını tek bir merkezden yönetin.',
                        ar: 'أدر المستخدمين والصلاحيات وإعدادات الشركة من مركز واحد.',
                        en: 'Manage users, access and company settings from one place.',
                      ),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: .82),
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF7CE0B6),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _tx(
                        tr: 'Sistem çalışıyor',
                        ar: 'النظام يعمل بشكل طبيعي',
                        en: 'System operational',
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
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

class _AdminSection {
  const _AdminSection({
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
}

class _AdminCard extends StatefulWidget {
  const _AdminCard({required this.section});

  final _AdminSection section;

  @override
  State<_AdminCard> createState() => _AdminCardState();
}

class _AdminCardState extends State<_AdminCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final section = widget.section;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        child: Card(
          elevation: _hovered ? 6 : 0,
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: section.onTap,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: section.accent.withValues(alpha: .13),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(section.icon, color: section.accent, size: 27),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          section.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          section.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: section.accent,
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
