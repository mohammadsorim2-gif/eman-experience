import 'package:flutter/material.dart';

class LoginAuditScreen extends StatefulWidget {
  const LoginAuditScreen({required this.languageCode, super.key});

  final String languageCode;

  @override
  State<LoginAuditScreen> createState() => _LoginAuditScreenState();
}

class _LoginAuditScreenState extends State<LoginAuditScreen> {
  String filter = 'all';

  String tx({required String ar, required String tr, required String en}) =>
      switch (widget.languageCode) {'ar' => ar, 'tr' => tr, _ => en};

  final records = const [
    _LoginRecord('خالد مكية', 'owner@eman.com', 'Gaziantep · Chrome', '04/08/2026 18:42', true, 'Successful login'),
    _LoginRecord('عبد السلام', 'sales@eman.com', 'iPhone · Safari', '04/08/2026 18:18', true, 'Successful login'),
    _LoginRecord('Unknown user', 'test@eman.com', 'Istanbul · Edge', '04/08/2026 17:54', false, 'Wrong password'),
    _LoginRecord('لطفي', 'production@eman.com', 'Factory tablet', '04/08/2026 16:31', true, 'Successful login'),
  ];

  @override
  Widget build(BuildContext context) {
    final visible = records.where((record) => filter == 'all' || (filter == 'success' ? record.success : !record.success)).toList();
    return Scaffold(
      appBar: AppBar(title: Text(tx(ar: 'سجل تسجيل الدخول', tr: 'Giriş denetim kaydı', en: 'Login audit'))),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'all', label: Text(tx(ar: 'الكل', tr: 'Tümü', en: 'All'))),
              ButtonSegment(value: 'success', label: Text(tx(ar: 'ناجح', tr: 'Başarılı', en: 'Successful'))),
              ButtonSegment(value: 'failed', label: Text(tx(ar: 'فاشل', tr: 'Başarısız', en: 'Failed'))),
            ],
            selected: {filter},
            onSelectionChanged: (value) => setState(() => filter = value.first),
          ),
          const SizedBox(height: 18),
          for (final record in visible)
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(record.success ? Icons.verified_user_rounded : Icons.gpp_bad_rounded),
                ),
                title: Text(record.name),
                subtitle: Text('${record.email}\n${record.device}\n${record.reason}'),
                isThreeLine: true,
                trailing: Text(record.time, textAlign: TextAlign.end),
              ),
            ),
        ],
      ),
    );
  }
}

class _LoginRecord {
  const _LoginRecord(this.name, this.email, this.device, this.time, this.success, this.reason);
  final String name;
  final String email;
  final String device;
  final String time;
  final bool success;
  final String reason;
}
