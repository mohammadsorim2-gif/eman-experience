import 'package:flutter/material.dart';

class SystemStatusScreen extends StatelessWidget {
  const SystemStatusScreen({required this.languageCode, super.key});

  final String languageCode;

  String _tx({required String ar, required String tr, required String en}) {
    return switch (languageCode) {
      'ar' => ar,
      'tr' => tr,
      _ => en,
    };
  }

  @override
  Widget build(BuildContext context) {
    final services = [
      ('Firebase Auth', true, '42 ms'),
      ('Cloud Firestore', true, '68 ms'),
      ('Storage', true, '91 ms'),
      ('Notifications', true, '35 ms'),
      ('Analytics', true, '54 ms'),
      ('Backup service', false, '--'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_tx(ar: 'حالة النظام', tr: 'Sistem durumu', en: 'System status')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 26,
                    child: Icon(Icons.health_and_safety_rounded),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _tx(
                            ar: 'النظام يعمل بشكل مستقر',
                            tr: 'Sistem kararlı çalışıyor',
                            en: 'System is operating normally',
                          ),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _tx(
                            ar: 'جميع الخدمات الأساسية متاحة مع وجود تنبيه واحد.',
                            tr: 'Temel servisler açık; bir uyarı bulunuyor.',
                            en: 'Core services are available with one warning.',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          for (final service in services)
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: service.$2
                      ? Colors.green.withValues(alpha: .12)
                      : Colors.orange.withValues(alpha: .12),
                  child: Icon(
                    service.$2 ? Icons.check_rounded : Icons.warning_amber_rounded,
                    color: service.$2 ? Colors.green : Colors.orange,
                  ),
                ),
                title: Text(service.$1),
                subtitle: Text(
                  service.$2
                      ? _tx(ar: 'متصل', tr: 'Bağlı', en: 'Connected')
                      : _tx(ar: 'بحاجة إعداد', tr: 'Yapılandırılmalı', en: 'Needs setup'),
                ),
                trailing: Text(service.$3),
              ),
            ),
        ],
      ),
    );
  }
}
