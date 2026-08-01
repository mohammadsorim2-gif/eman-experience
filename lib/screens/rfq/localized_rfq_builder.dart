import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/app_i18n.dart';

class LocalizedRfqBuilder extends StatefulWidget {
  const LocalizedRfqBuilder({super.key});

  @override
  State<LocalizedRfqBuilder> createState() => _LocalizedRfqBuilderState();
}

class _LocalizedRfqBuilderState extends State<LocalizedRfqBuilder> {
  String brand = 'Frio Cups';
  String product = 'Orange Powder Drink';
  String container = '20 ft';
  double cartons = 1200;
  bool privateLabel = false;

  String _t(BuildContext context, String key) {
    final code = AppLocaleScope.of(context).languageCode;
    const values = <String, Map<String, String>>{
      'title': {
        'tr': 'Akıllı Teklif Talebi',
        'en': 'Smart Request for Quotation',
        'ar': 'طلب عرض سعر ذكي',
        'es': 'Solicitud inteligente de cotización',
        'pt': 'Solicitação inteligente de cotação',
        'ru': 'Умный запрос коммерческого предложения',
        'fr': 'Demande de devis intelligente',
        'de': 'Intelligente Angebotsanfrage',
      },
      'subtitle': {
        'tr': 'Ürün, ambalaj ve sevkiyat tercihlerinizi seçin; satış ekibine hazır bir B2B talebi gönderin.',
        'en': 'Choose product, packaging and shipment preferences, then send a ready B2B request to the sales team.',
        'ar': 'اختر المنتج والتغليف والشحن ثم أرسل طلب B2B جاهزًا إلى فريق المبيعات.',
        'es': 'Elija producto, embalaje y envío y envíe una solicitud B2B lista.',
        'pt': 'Escolha produto, embalagem e envio e envie uma solicitação B2B pronta.',
        'ru': 'Выберите продукт, упаковку и доставку и отправьте готовый B2B-запрос.',
        'fr': 'Choisissez produit, emballage et expédition puis envoyez une demande B2B prête.',
        'de': 'Wählen Sie Produkt, Verpackung und Versand und senden Sie eine fertige B2B-Anfrage.',
      },
      'brand': {'tr': 'Marka', 'en': 'Brand', 'ar': 'العلامة التجارية', 'es': 'Marca', 'pt': 'Marca', 'ru': 'Бренд', 'fr': 'Marque', 'de': 'Marke'},
      'product': {'tr': 'Ürün', 'en': 'Product', 'ar': 'المنتج', 'es': 'Producto', 'pt': 'Produto', 'ru': 'Продукт', 'fr': 'Produit', 'de': 'Produkt'},
      'container': {'tr': 'Konteyner', 'en': 'Container', 'ar': 'الحاوية', 'es': 'Contenedor', 'pt': 'Contêiner', 'ru': 'Контейнер', 'fr': 'Conteneur', 'de': 'Container'},
      'cartons': {'tr': 'Tahmini koli adedi', 'en': 'Estimated cartons', 'ar': 'عدد الكراتين التقديري', 'es': 'Cajas estimadas', 'pt': 'Caixas estimadas', 'ru': 'Ориентировочно коробок', 'fr': 'Cartons estimés', 'de': 'Geschätzte Kartons'},
      'privateLabel': {'tr': 'Özel marka üretimi', 'en': 'Private label production', 'ar': 'تصنيع علامة خاصة', 'es': 'Producción de marca privada', 'pt': 'Produção de marca própria', 'ru': 'Производство под СТМ', 'fr': 'Production marque privée', 'de': 'Private-Label-Produktion'},
      'summary': {'tr': 'Talep Özeti', 'en': 'Request Summary', 'ar': 'ملخص الطلب', 'es': 'Resumen de solicitud', 'pt': 'Resumo da solicitação', 'ru': 'Сводка запроса', 'fr': 'Résumé de la demande', 'de': 'Anfrageübersicht'},
      'send': {'tr': 'Teklif Talebini Gönder', 'en': 'Send RFQ', 'ar': 'إرسال طلب عرض السعر', 'es': 'Enviar solicitud', 'pt': 'Enviar solicitação', 'ru': 'Отправить запрос', 'fr': 'Envoyer la demande', 'de': 'Anfrage senden'},
      'sent': {'tr': 'Teklif talebiniz başarıyla oluşturuldu.', 'en': 'Your RFQ was created successfully.', 'ar': 'تم إنشاء طلب عرض السعر بنجاح.', 'es': 'Su solicitud se creó correctamente.', 'pt': 'Sua solicitação foi criada com sucesso.', 'ru': 'Ваш запрос успешно создан.', 'fr': 'Votre demande a été créée avec succès.', 'de': 'Ihre Anfrage wurde erfolgreich erstellt.'},
      'buyer': {'tr': 'Alıcı bilgileri', 'en': 'Buyer information', 'ar': 'معلومات المشتري', 'es': 'Información del comprador', 'pt': 'Informações do comprador', 'ru': 'Информация о покупателе', 'fr': 'Informations acheteur', 'de': 'Käuferinformationen'},
      'company': {'tr': 'Şirket adı', 'en': 'Company name', 'ar': 'اسم الشركة', 'es': 'Empresa', 'pt': 'Empresa', 'ru': 'Компания', 'fr': 'Entreprise', 'de': 'Firmenname'},
      'country': {'tr': 'Ülke / pazar', 'en': 'Country / market', 'ar': 'الدولة / السوق', 'es': 'País / mercado', 'pt': 'País / mercado', 'ru': 'Страна / рынок', 'fr': 'Pays / marché', 'de': 'Land / Markt'},
      'email': {'tr': 'E-posta', 'en': 'Email', 'ar': 'البريد الإلكتروني', 'es': 'Correo', 'pt': 'E-mail', 'ru': 'Эл. почта', 'fr': 'E-mail', 'de': 'E-Mail'},
    };
    return values[key]?[code] ?? values[key]?['tr'] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        Text(
          _t(context, 'title'),
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: EmanExperienceApp.navy),
        ),
        const SizedBox(height: 10),
        Text(_t(context, 'subtitle'), style: const TextStyle(fontSize: 17, height: 1.55, color: Color(0xFF617684))),
        const SizedBox(height: 26),
        LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < 920;
            final form = _buildForm(context);
            final summary = _buildSummary(context);
            if (stacked) {
              return Column(children: [form, const SizedBox(height: 18), summary]);
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Expanded(flex: 3, child: form), const SizedBox(width: 18), Expanded(flex: 2, child: summary)],
            );
          },
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              initialValue: brand,
              decoration: InputDecoration(labelText: _t(context, 'brand'), prefixIcon: const Icon(Icons.branding_watermark_outlined)),
              items: const ['Frio Cups', 'Full Fresh', 'Valore', 'Roya C'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
              onChanged: (value) => setState(() => brand = value ?? brand),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: product,
              decoration: InputDecoration(labelText: _t(context, 'product'), prefixIcon: const Icon(Icons.inventory_2_outlined)),
              items: const ['Orange Powder Drink', 'Mango Powder Drink', 'Strawberry Powder Drink', 'Cocktail Powder Drink'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
              onChanged: (value) => setState(() => product = value ?? product),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: container,
              decoration: InputDecoration(labelText: _t(context, 'container'), prefixIcon: const Icon(Icons.local_shipping_outlined)),
              items: const ['20 ft', '40 ft', '40 ft HC', 'LCL'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
              onChanged: (value) => setState(() => container = value ?? container),
            ),
            const SizedBox(height: 20),
            Text('${_t(context, 'cartons')}: ${cartons.round()}', style: const TextStyle(fontWeight: FontWeight.w800)),
            Slider(value: cartons, min: 100, max: 5000, divisions: 49, label: cartons.round().toString(), onChanged: (value) => setState(() => cartons = value)),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(_t(context, 'privateLabel'), style: const TextStyle(fontWeight: FontWeight.w800)),
              value: privateLabel,
              onChanged: (value) => setState(() => privateLabel = value),
            ),
            const Divider(height: 34),
            Text(_t(context, 'buyer'), style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
            TextFormField(decoration: InputDecoration(labelText: _t(context, 'company'), prefixIcon: const Icon(Icons.business_outlined))),
            const SizedBox(height: 14),
            TextFormField(decoration: InputDecoration(labelText: _t(context, 'country'), prefixIcon: const Icon(Icons.public))),
            const SizedBox(height: 14),
            TextFormField(keyboardType: TextInputType.emailAddress, decoration: InputDecoration(labelText: _t(context, 'email'), prefixIcon: const Icon(Icons.email_outlined))),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_t(context, 'summary'), style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
            const SizedBox(height: 20),
            _SummaryRow(icon: Icons.branding_watermark_outlined, label: _t(context, 'brand'), value: brand),
            _SummaryRow(icon: Icons.inventory_2_outlined, label: _t(context, 'product'), value: product),
            _SummaryRow(icon: Icons.local_shipping_outlined, label: _t(context, 'container'), value: container),
            _SummaryRow(icon: Icons.all_inbox_outlined, label: _t(context, 'cartons'), value: cartons.round().toString()),
            _SummaryRow(icon: Icons.palette_outlined, label: _t(context, 'privateLabel'), value: privateLabel ? '✓' : '—'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_t(context, 'sent'))));
                },
                icon: const Icon(Icons.send_outlined),
                label: Padding(padding: const EdgeInsets.symmetric(vertical: 15), child: Text(_t(context, 'send'))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: const Color(0xFFEAF6FF), child: Icon(icon, color: EmanExperienceApp.blue, size: 20)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Color(0xFF6C7D87))), Text(value, style: const TextStyle(fontWeight: FontWeight.w900))])),
        ],
      ),
    );
  }
}
