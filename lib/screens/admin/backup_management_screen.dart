import 'package:flutter/material.dart';

class BackupManagementScreen extends StatefulWidget {
  const BackupManagementScreen({required this.languageCode, super.key});

  final String languageCode;

  @override
  State<BackupManagementScreen> createState() => _BackupManagementScreenState();
}

class _BackupManagementScreenState extends State<BackupManagementScreen> {
  bool automatic = true;
  bool includeMedia = true;
  String frequency = 'daily';

  String _tx({required String ar, required String tr, required String en}) {
    return switch (widget.languageCode) {
      'ar' => ar,
      'tr' => tr,
      _ => en,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tx(ar: 'إدارة النسخ الاحتياطية', tr: 'Yedekleme yönetimi', en: 'Backup management')),
        actions: [
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(_tx(ar: 'بدأ إنشاء النسخة الاحتياطية', tr: 'Yedekleme başlatıldı', en: 'Backup started'))),
              );
            },
            icon: const Icon(Icons.backup_rounded),
            label: Text(_tx(ar: 'نسخة الآن', tr: 'Şimdi yedekle', en: 'Backup now')),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: automatic,
                  onChanged: (value) => setState(() => automatic = value),
                  secondary: const Icon(Icons.schedule_rounded),
                  title: Text(_tx(ar: 'نسخ احتياطي تلقائي', tr: 'Otomatik yedekleme', en: 'Automatic backup')),
                ),
                SwitchListTile(
                  value: includeMedia,
                  onChanged: (value) => setState(() => includeMedia = value),
                  secondary: const Icon(Icons.perm_media_rounded),
                  title: Text(_tx(ar: 'تضمين الصور والملفات', tr: 'Medya ve dosyaları dahil et', en: 'Include media and files')),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
                  child: DropdownButtonFormField<String>(
                    initialValue: frequency,
                    decoration: InputDecoration(labelText: _tx(ar: 'التكرار', tr: 'Sıklık', en: 'Frequency')),
                    items: [
                      DropdownMenuItem(value: 'daily', child: Text(_tx(ar: 'يومي', tr: 'Günlük', en: 'Daily'))),
                      DropdownMenuItem(value: 'weekly', child: Text(_tx(ar: 'أسبوعي', tr: 'Haftalık', en: 'Weekly'))),
                      DropdownMenuItem(value: 'monthly', child: Text(_tx(ar: 'شهري', tr: 'Aylık', en: 'Monthly'))),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => frequency = value);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(_tx(ar: 'آخر النسخ', tr: 'Son yedekler', en: 'Recent backups'), style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          for (final item in const [
            ('EMAN-2026-08-04', '2.4 GB', true),
            ('EMAN-2026-08-03', '2.3 GB', true),
            ('EMAN-2026-08-02', '1.9 GB', false),
          ])
            Card(
              child: ListTile(
                leading: Icon(item.$3 ? Icons.cloud_done_rounded : Icons.error_outline_rounded),
                title: Text(item.$1),
                subtitle: Text(item.$2),
                trailing: Wrap(
                  children: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.restore_rounded)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.download_rounded)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
