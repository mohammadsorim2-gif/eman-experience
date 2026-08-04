import 'package:flutter/material.dart';

import '../../core/onboarding/section_tour_controller.dart';
import 'admin_control_center.dart';

class GuidedAdminControlCenter extends StatefulWidget {
  const GuidedAdminControlCenter({required this.languageCode, super.key});

  final String languageCode;

  @override
  State<GuidedAdminControlCenter> createState() =>
      _GuidedAdminControlCenterState();
}

class _GuidedAdminControlCenterState extends State<GuidedAdminControlCenter> {
  bool _scheduled = false;

  String _tx({required String tr, required String ar, required String en}) {
    return switch (widget.languageCode) {
      'tr' => tr,
      'ar' => ar,
      _ => en,
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_scheduled) return;
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _showTour());
  }

  Future<void> _showTour({bool force = false}) async {
    await SectionTourController.showIfNeeded(
      context: context,
      sectionId: 'admin_control_center',
      force: force,
      nextLabel: _tx(tr: 'Devam', ar: 'التالي', en: 'Next'),
      finishLabel: _tx(tr: 'Başla', ar: 'ابدأ', en: 'Start'),
      skipLabel: _tx(tr: 'Atla', ar: 'تخطي', en: 'Skip'),
      steps: [
        SectionTourStep(
          title: _tx(
            tr: 'Merkezi yönetim',
            ar: 'الإدارة المركزية',
            en: 'Central administration',
          ),
          description: _tx(
            tr: 'Kullanıcıları, rolleri ve şirket ayarlarını tek yerden yönetin.',
            ar: 'أدر المستخدمين والرتب وإعدادات الشركة من مكان واحد.',
            en: 'Manage users, roles and company settings from one place.',
          ),
          icon: Icons.admin_panel_settings_rounded,
          accent: const Color(0xFF0879B8),
        ),
        SectionTourStep(
          title: _tx(
            tr: 'Erişim ve güvenlik',
            ar: 'الوصول والأمان',
            en: 'Access and security',
          ),
          description: _tx(
            tr: 'Her rolün yetkilerini düzenleyin ve kritik işlemleri takip edin.',
            ar: 'عدّل صلاحيات كل رتبة وتابع العمليات الحساسة.',
            en: 'Configure each role and review critical activity.',
          ),
          icon: Icons.security_rounded,
          accent: const Color(0xFF7657D9),
        ),
        SectionTourStep(
          title: _tx(
            tr: 'Modüller ve bildirimler',
            ar: 'الوحدات والإشعارات',
            en: 'Modules and notifications',
          ),
          description: _tx(
            tr: 'Uygulama bölümlerini açıp kapatın ve bildirim tercihlerini yönetin.',
            ar: 'فعّل أو عطّل أقسام التطبيق واضبط تفضيلات الإشعارات.',
            en: 'Enable modules and configure notification preferences.',
          ),
          icon: Icons.widgets_rounded,
          accent: const Color(0xFFE87A35),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AdminControlCenter(languageCode: widget.languageCode),
        PositionedDirectional(
          end: 20,
          bottom: 20,
          child: FloatingActionButton.small(
            heroTag: 'admin-help-tour',
            tooltip: _tx(
              tr: 'Bölüm tanıtımını yeniden göster',
              ar: 'إعادة عرض شرح القسم',
              en: 'Replay section guide',
            ),
            onPressed: () => _showTour(force: true),
            child: const Icon(Icons.help_outline_rounded),
          ),
        ),
      ],
    );
  }
}
