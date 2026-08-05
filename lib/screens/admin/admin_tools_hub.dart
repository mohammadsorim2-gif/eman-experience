import 'package:flutter/material.dart';

import '../analytics/dashboard_layout_settings_screen.dart';
import '../auth/firebase_login_screen.dart';
import 'backup_management_screen.dart';
import 'login_audit_screen.dart';
import 'system_status_screen.dart';

class AdminToolsHub extends StatelessWidget {
  const AdminToolsHub({required this.languageCode, super.key});

  final String languageCode;

  String tx({required String ar, required String tr, required String en}) =>
      switch (languageCode) {'ar' => ar, 'tr' => tr, _ => en};

  @override
  Widget build(BuildContext context) {
    final tools = <_AdminTool>[
      _AdminTool(
        title: tx(ar: 'تسجيل الدخول الحقيقي', tr: 'Gerçek giriş', en: 'Real sign in'),
        subtitle: tx(ar: 'اختبار Firebase Auth وقراءة دور المستخدم من Firestore', tr: 'Firebase Auth ve Firestore kullanıcı rolünü test edin', en: 'Test Firebase Auth and load the user role from Firestore'),
        icon: Icons.login_rounded,
        builder: () => FirebaseLoginScreen(languageCode: languageCode),
      ),
      _AdminTool(
        title: tx(ar: 'حالة النظام', tr: 'Sistem durumu', en: 'System status'),
        subtitle: tx(ar: 'مراقبة الخدمات والاتصالات والتنبيهات', tr: 'Servisleri, bağlantıları ve uyarıları izleyin', en: 'Monitor services, connectivity and alerts'),
        icon: Icons.health_and_safety_rounded,
        builder: () => SystemStatusScreen(languageCode: languageCode),
      ),
      _AdminTool(
        title: tx(ar: 'سجل تسجيل الدخول', tr: 'Giriş denetim kaydı', en: 'Login audit'),
        subtitle: tx(ar: 'محاولات الدخول الناجحة والفاشلة والأجهزة', tr: 'Başarılı ve başarısız girişler ile cihazlar', en: 'Successful and failed logins with devices'),
        icon: Icons.manage_accounts_rounded,
        builder: () => LoginAuditScreen(languageCode: languageCode),
      ),
      _AdminTool(
        title: tx(ar: 'النسخ الاحتياطية', tr: 'Yedekleme yönetimi', en: 'Backup management'),
        subtitle: tx(ar: 'النسخ التلقائي والاستعادة والتنزيل', tr: 'Otomatik yedekleme, geri yükleme ve indirme', en: 'Automatic backups, restore and download'),
        icon: Icons.cloud_sync_rounded,
        builder: () => BackupManagementScreen(languageCode: languageCode),
      ),
      _AdminTool(
        title: tx(ar: 'تخصيص لوحة التحكم', tr: 'Kontrol paneli düzeni', en: 'Dashboard layout'),
        subtitle: tx(ar: 'ترتيب البطاقات وإظهارها وإخفاؤها', tr: 'Kartları sıralayın, gösterin veya gizleyin', en: 'Reorder, show or hide dashboard widgets'),
        icon: Icons.dashboard_customize_rounded,
        builder: () => DashboardLayoutSettingsScreen(languageCode: languageCode),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(tx(ar: 'مركز إدارة النظام', tr: 'Sistem yönetim merkezi', en: 'System administration center'))),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 1050 ? 3 : constraints.maxWidth >= 650 ? 2 : 1;
          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: columns == 1 ? 2.2 : 1.25,
            ),
            itemCount: tools.length,
            itemBuilder: (context, index) {
              final tool = tools[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => tool.builder())),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(radius: 25, child: Icon(tool.icon)),
                        const Spacer(),
                        Text(tool.title, style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(tool.subtitle, maxLines: 3, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 14),
                        Row(children: [Text(tx(ar: 'فتح الأداة', tr: 'Aracı aç', en: 'Open tool')), const Spacer(), const Icon(Icons.arrow_forward_rounded)]),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _AdminTool {
  const _AdminTool({required this.title, required this.subtitle, required this.icon, required this.builder});
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget Function() builder;
}
