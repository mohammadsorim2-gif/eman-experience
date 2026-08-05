import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanySettingsScreen extends StatefulWidget {
  const CompanySettingsScreen({required this.languageCode, super.key});

  final String languageCode;

  @override
  State<CompanySettingsScreen> createState() => _CompanySettingsScreenState();
}

class _CompanySettingsScreenState extends State<CompanySettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyName = TextEditingController(text: 'EMAN Agro');
  final _legalName = TextEditingController(text: 'EMAN Agro Gıda Sanayi ve Ticaret');
  final _email = TextEditingController(text: 'info@emanagro.com');
  final _phone = TextEditingController(text: '+90');
  final _website = TextEditingController(text: 'emanagro.com');
  final _address = TextEditingController(text: 'Gaziantep, Türkiye');
  final _taxNumber = TextEditingController();
  final _currency = TextEditingController(text: 'TRY');
  final _timezone = TextEditingController(text: 'Europe/Istanbul');

  bool _saving = false;
  bool _loaded = false;
  bool _emailNotifications = true;
  bool _stockAlerts = true;
  bool _productionAlerts = true;
  bool _approvalAlerts = true;

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
    _companyName.text = prefs.getString('company_name') ?? _companyName.text;
    _legalName.text = prefs.getString('company_legal_name') ?? _legalName.text;
    _email.text = prefs.getString('company_email') ?? _email.text;
    _phone.text = prefs.getString('company_phone') ?? _phone.text;
    _website.text = prefs.getString('company_website') ?? _website.text;
    _address.text = prefs.getString('company_address') ?? _address.text;
    _taxNumber.text = prefs.getString('company_tax_number') ?? '';
    _currency.text = prefs.getString('company_currency') ?? _currency.text;
    _timezone.text = prefs.getString('company_timezone') ?? _timezone.text;
    _emailNotifications = prefs.getBool('company_email_notifications') ?? true;
    _stockAlerts = prefs.getBool('company_stock_alerts') ?? true;
    _productionAlerts = prefs.getBool('company_production_alerts') ?? true;
    _approvalAlerts = prefs.getBool('company_approval_alerts') ?? true;
    if (mounted) setState(() => _loaded = true);
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString('company_name', _companyName.text.trim()),
      prefs.setString('company_legal_name', _legalName.text.trim()),
      prefs.setString('company_email', _email.text.trim()),
      prefs.setString('company_phone', _phone.text.trim()),
      prefs.setString('company_website', _website.text.trim()),
      prefs.setString('company_address', _address.text.trim()),
      prefs.setString('company_tax_number', _taxNumber.text.trim()),
      prefs.setString('company_currency', _currency.text.trim()),
      prefs.setString('company_timezone', _timezone.text.trim()),
      prefs.setBool('company_email_notifications', _emailNotifications),
      prefs.setBool('company_stock_alerts', _stockAlerts),
      prefs.setBool('company_production_alerts', _productionAlerts),
      prefs.setBool('company_approval_alerts', _approvalAlerts),
    ]);
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _tx(
            tr: 'Şirket ayarları kaydedildi',
            ar: 'تم حفظ إعدادات الشركة',
            en: 'Company settings saved',
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in [
      _companyName,
      _legalName,
      _email,
      _phone,
      _website,
      _address,
      _taxNumber,
      _currency,
      _timezone,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tx(
            tr: 'Şirket ayarları',
            ar: 'إعدادات الشركة',
            en: 'Company settings',
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 16),
            child: FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_rounded),
              label: Text(
                _tx(tr: 'Kaydet', ar: 'حفظ', en: 'Save'),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _SectionCard(
              title: _tx(
                tr: 'Kurumsal kimlik',
                ar: 'هوية الشركة',
                en: 'Company identity',
              ),
              icon: Icons.business_rounded,
              accent: const Color(0xFF0879B8),
              children: [
                _field(_companyName,
                    label: _tx(tr: 'Marka adı', ar: 'اسم العلامة', en: 'Brand name'),
                    icon: Icons.apartment_rounded,
                    required: true),
                _field(_legalName,
                    label: _tx(tr: 'Resmi unvan', ar: 'الاسم القانوني', en: 'Legal name'),
                    icon: Icons.badge_rounded),
                _field(_taxNumber,
                    label: _tx(tr: 'Vergi numarası', ar: 'الرقم الضريبي', en: 'Tax number'),
                    icon: Icons.receipt_long_rounded),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: _tx(
                tr: 'İletişim bilgileri',
                ar: 'معلومات التواصل',
                en: 'Contact information',
              ),
              icon: Icons.contact_mail_rounded,
              accent: const Color(0xFF159776),
              children: [
                _field(_email,
                    label: _tx(tr: 'E-posta', ar: 'البريد الإلكتروني', en: 'Email'),
                    icon: Icons.alternate_email_rounded,
                    email: true,
                    required: true),
                _field(_phone,
                    label: _tx(tr: 'Telefon', ar: 'الهاتف', en: 'Phone'),
                    icon: Icons.phone_rounded),
                _field(_website,
                    label: _tx(tr: 'Web sitesi', ar: 'الموقع الإلكتروني', en: 'Website'),
                    icon: Icons.language_rounded),
                _field(_address,
                    label: _tx(tr: 'Adres', ar: 'العنوان', en: 'Address'),
                    icon: Icons.location_on_rounded,
                    maxLines: 3),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: _tx(
                tr: 'Operasyon ayarları',
                ar: 'إعدادات التشغيل',
                en: 'Operational settings',
              ),
              icon: Icons.tune_rounded,
              accent: const Color(0xFF7657D9),
              children: [
                _field(_currency,
                    label: _tx(tr: 'Varsayılan para birimi', ar: 'العملة الافتراضية', en: 'Default currency'),
                    icon: Icons.currency_exchange_rounded,
                    required: true),
                _field(_timezone,
                    label: _tx(tr: 'Saat dilimi', ar: 'المنطقة الزمنية', en: 'Timezone'),
                    icon: Icons.schedule_rounded,
                    required: true),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: _tx(
                tr: 'Uyarı tercihleri',
                ar: 'تفضيلات التنبيه',
                en: 'Alert preferences',
              ),
              icon: Icons.notifications_active_rounded,
              accent: const Color(0xFFE87A35),
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _emailNotifications,
                  onChanged: (value) => setState(() => _emailNotifications = value),
                  title: Text(_tx(tr: 'E-posta bildirimleri', ar: 'إشعارات البريد', en: 'Email notifications')),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _stockAlerts,
                  onChanged: (value) => setState(() => _stockAlerts = value),
                  title: Text(_tx(tr: 'Düşük stok uyarıları', ar: 'تنبيهات انخفاض المخزون', en: 'Low stock alerts')),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _productionAlerts,
                  onChanged: (value) => setState(() => _productionAlerts = value),
                  title: Text(_tx(tr: 'Üretim uyarıları', ar: 'تنبيهات الإنتاج', en: 'Production alerts')),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _approvalAlerts,
                  onChanged: (value) => setState(() => _approvalAlerts = value),
                  title: Text(_tx(tr: 'Onay uyarıları', ar: 'تنبيهات الموافقات', en: 'Approval alerts')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller, {
    required String label,
    required IconData icon,
    bool required = false,
    bool email = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (value) {
          final text = value?.trim() ?? '';
          if (required && text.isEmpty) {
            return _tx(tr: 'Bu alan zorunludur', ar: 'هذا الحقل مطلوب', en: 'This field is required');
          }
          if (email && text.isNotEmpty && !text.contains('@')) {
            return _tx(tr: 'Geçerli bir e-posta girin', ar: 'أدخل بريدًا صحيحًا', en: 'Enter a valid email');
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          alignLabelWithHint: maxLines > 1,
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.accent,
    required this.children,
  });

  final String title;
  final IconData icon;
  final Color accent;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
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
                const SizedBox(width: 12),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }
}
