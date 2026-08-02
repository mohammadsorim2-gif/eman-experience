import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/app_i18n.dart';

String _localeCode(BuildContext context) =>
    AppLocaleScope.of(context).languageCode;

String _tx(BuildContext context, String key) {
  const values = <String, Map<String, String>>{
    'products.title': {
      'tr': 'Etkileşimli Ürün Kataloğu',
      'en': 'Interactive Product Catalog',
      'ar': 'كاتالوج المنتجات التفاعلي',
      'es': 'Catálogo interactivo de productos',
      'pt': 'Catálogo interativo de produtos',
      'ru': 'Интерактивный каталог продукции',
      'fr': 'Catalogue produits interactif',
      'de': 'Interaktiver Produktkatalog',
    },
    'products.subtitle': {
      'tr':
          'Ürünleri inceleyin, kişisel satış bağlantınızla paylaşın ve oluşan talepleri takip edin.',
      'en':
          'Explore products, share them with your personal sales link and track resulting inquiries.',
      'ar':
          'استعرض المنتجات وشاركها عبر رابط المبيعات الخاص بك وتابع الطلبات الناتجة.',
      'es':
          'Explore productos, compártalos con su enlace personal y siga las consultas.',
      'pt':
          'Explore produtos, compartilhe com seu link pessoal e acompanhe as consultas.',
      'ru':
          'Изучайте продукцию, делитесь персональной ссылкой и отслеживайте заявки.',
      'fr':
          'Explorez les produits, partagez votre lien personnel et suivez les demandes.',
      'de':
          'Produkte entdecken, über Ihren persönlichen Link teilen und Anfragen verfolgen.',
    },
    'products.search': {
      'tr': 'Ürün, aroma veya marka ara',
      'en': 'Search products, flavors or brands',
      'ar': 'ابحث عن منتج أو نكهة أو علامة',
      'es': 'Buscar productos, sabores o marcas',
      'pt': 'Pesquisar produtos, sabores ou marcas',
      'ru': 'Поиск продуктов, вкусов или брендов',
      'fr': 'Rechercher produits, saveurs ou marques',
      'de': 'Produkte, Geschmacksrichtungen oder Marken suchen',
    },
    'products.share': {
      'tr': 'Paylaş',
      'en': 'Share',
      'ar': 'مشاركة',
      'es': 'Compartir',
      'pt': 'Compartilhar',
      'ru': 'Поделиться',
      'fr': 'Partager',
      'de': 'Teilen',
    },
    'products.powderDrink': {
      'tr': 'Toz İçecek',
      'en': 'Powder Drink',
      'ar': 'مشروب بودرة',
      'es': 'Bebida en polvo',
      'pt': 'Bebida em pó',
      'ru': 'Порошковый напиток',
      'fr': 'Boisson en poudre',
      'de': 'Getränkepulver',
    },
    'flavor.orange': {
      'tr': 'Portakal',
      'en': 'Orange',
      'ar': 'برتقال',
      'es': 'Naranja',
      'pt': 'Laranja',
      'ru': 'Апельсин',
      'fr': 'Orange',
      'de': 'Orange',
    },
    'flavor.mango': {
      'tr': 'Mango',
      'en': 'Mango',
      'ar': 'مانجو',
      'es': 'Mango',
      'pt': 'Manga',
      'ru': 'Манго',
      'fr': 'Mangue',
      'de': 'Mango',
    },
    'flavor.berries': {
      'tr': 'Orman Meyveleri',
      'en': 'Berries',
      'ar': 'توت مشكل',
      'es': 'Frutos rojos',
      'pt': 'Frutas vermelhas',
      'ru': 'Ягоды',
      'fr': 'Fruits rouges',
      'de': 'Beeren',
    },
    'flavor.banana': {
      'tr': 'Muz',
      'en': 'Banana',
      'ar': 'موز',
      'es': 'Banana',
      'pt': 'Banana',
      'ru': 'Банан',
      'fr': 'Banane',
      'de': 'Banane',
    },
    'flavor.strawberry': {
      'tr': 'Çilek',
      'en': 'Strawberry',
      'ar': 'فراولة',
      'es': 'Fresa',
      'pt': 'Morango',
      'ru': 'Клубника',
      'fr': 'Fraise',
      'de': 'Erdbeere',
    },
    'partner.title': {
      'tr': 'EMAN Satış Ortağı Olun',
      'en': 'Become an EMAN Sales Partner',
      'ar': 'كن شريك مبيعات لدى EMAN',
      'es': 'Conviértase en socio comercial de EMAN',
      'pt': 'Torne-se parceiro de vendas da EMAN',
      'ru': 'Станьте торговым партнёром EMAN',
      'fr': 'Devenez partenaire commercial EMAN',
      'de': 'Werden Sie EMAN Vertriebspartner',
    },
    'partner.subtitle': {
      'tr':
          'Profilinizi oluşturun, kısa eğitim programını tamamlayın ve nitelikli alıcıları yönlendirmek için kişisel bağlantınızı alın.',
      'en':
          'Create your profile, complete the short academy and receive your personal link to introduce qualified buyers.',
      'ar':
          'أنشئ ملفك وأكمل التدريب القصير واحصل على رابطك الخاص لجلب المشترين المؤهلين.',
      'es': 'Cree su perfil, complete la academia y reciba su enlace personal.',
      'pt': 'Crie seu perfil, conclua a academia e receba seu link pessoal.',
      'ru':
          'Создайте профиль, пройдите обучение и получите персональную ссылку.',
      'fr':
          'Créez votre profil, terminez la formation et recevez votre lien personnel.',
      'de':
          'Profil erstellen, Schulung abschließen und persönlichen Link erhalten.',
    },
    'form.name': {
      'tr': 'Ad Soyad',
      'en': 'Full name',
      'ar': 'الاسم الكامل',
      'es': 'Nombre completo',
      'pt': 'Nome completo',
      'ru': 'Полное имя',
      'fr': 'Nom complet',
      'de': 'Vollständiger Name',
    },
    'form.email': {
      'tr': 'E-posta',
      'en': 'Email',
      'ar': 'البريد الإلكتروني',
      'es': 'Correo electrónico',
      'pt': 'E-mail',
      'ru': 'Электронная почта',
      'fr': 'E-mail',
      'de': 'E-Mail',
    },
    'form.phone': {
      'tr': 'Telefon / WhatsApp',
      'en': 'Phone / WhatsApp',
      'ar': 'الهاتف / واتساب',
      'es': 'Teléfono / WhatsApp',
      'pt': 'Telefone / WhatsApp',
      'ru': 'Телефон / WhatsApp',
      'fr': 'Téléphone / WhatsApp',
      'de': 'Telefon / WhatsApp',
    },
    'form.country': {
      'tr': 'Ülke',
      'en': 'Country',
      'ar': 'الدولة',
      'es': 'País',
      'pt': 'País',
      'ru': 'Страна',
      'fr': 'Pays',
      'de': 'Land',
    },
    'form.network': {
      'tr': 'Pazarınız veya iş ağınız hakkında bilgi verin',
      'en': 'Tell us about your market or business network',
      'ar': 'حدثنا عن سوقك أو شبكة أعمالك',
      'es': 'Cuéntenos sobre su mercado o red',
      'pt': 'Conte-nos sobre seu mercado ou rede',
      'ru': 'Расскажите о вашем рынке или деловой сети',
      'fr': 'Parlez-nous de votre marché ou réseau',
      'de': 'Erzählen Sie uns von Ihrem Markt oder Netzwerk',
    },
    'form.submit': {
      'tr': 'Partner Başvurusunu Gönder',
      'en': 'Submit Partner Application',
      'ar': 'إرسال طلب الشراكة',
      'es': 'Enviar solicitud',
      'pt': 'Enviar candidatura',
      'ru': 'Отправить заявку',
      'fr': 'Envoyer la candidature',
      'de': 'Partnerantrag senden',
    },
    'form.required': {
      'tr': 'Bu alan zorunludur',
      'en': 'Required',
      'ar': 'هذا الحقل مطلوب',
      'es': 'Obligatorio',
      'pt': 'Obrigatório',
      'ru': 'Обязательное поле',
      'fr': 'Obligatoire',
      'de': 'Erforderlich',
    },
    'form.invalidEmail': {
      'tr': 'Geçerli bir e-posta girin',
      'en': 'Enter a valid email',
      'ar': 'أدخل بريدًا إلكترونيًا صحيحًا',
      'es': 'Ingrese un correo válido',
      'pt': 'Digite um e-mail válido',
      'ru': 'Введите корректный адрес',
      'fr': 'Saisissez un e-mail valide',
      'de': 'Gültige E-Mail eingeben',
    },
    'form.success': {
      'tr': 'Başvurunuz başarıyla gönderildi',
      'en': 'Application submitted successfully',
      'ar': 'تم إرسال الطلب بنجاح',
      'es': 'Solicitud enviada correctamente',
      'pt': 'Candidatura enviada com sucesso',
      'ru': 'Заявка успешно отправлена',
      'fr': 'Candidature envoyée',
      'de': 'Antrag erfolgreich gesendet',
    },
  };
  final translations = values[key];
  if (translations == null) return key;
  final code = _localeCode(context);
  return translations[code] ?? translations['tr'] ?? key;
}

class LocalizedProductsPage extends StatefulWidget {
  const LocalizedProductsPage({super.key});

  @override
  State<LocalizedProductsPage> createState() => _LocalizedProductsPageState();
}

class _LocalizedProductsPageState extends State<LocalizedProductsPage> {
  String query = '';

  static const products = [
    (
      'flavor.orange',
      'Frio Cups',
      'assets/products/friocups/9g-orange-flavored-powder-drink-friocups.png',
    ),
    (
      'flavor.mango',
      'Frio Cups',
      'assets/products/friocups/9g-mango-flavored-powder-drink-friocups.png',
    ),
    (
      'flavor.berries',
      'Frio Cups',
      'assets/products/friocups/9g-berries-flavored-powder-drink-friocups.png',
    ),
    (
      'flavor.banana',
      'Frio Cups',
      'assets/products/friocups/9g-banana-flavored-powder-drink-friocups.png',
    ),
    (
      'flavor.strawberry',
      'Full Fresh',
      'assets/products/fullfresh/Full-fresh-9g-drink-powder-strawberry.png',
    ),
    (
      'flavor.orange',
      'Valore',
      'assets/products/valore/orange-flavored-powder-drink-valore-10grams.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = products.where((item) {
      final text = '${_tx(context, item.$1)} ${item.$2}'.toLowerCase();
      return text.contains(query.toLowerCase());
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        Text(
          _tx(context, 'products.title'),
          style: const TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w500,
            color: EmanExperienceApp.navy,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _tx(context, 'products.subtitle'),
          style: const TextStyle(
            fontSize: 17,
            color: Color(0xFF607482),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 28),
        TextField(
          onChanged: (value) => setState(() => query = value),
          decoration: InputDecoration(
            hintText: _tx(context, 'products.search'),
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 28),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 1100
                ? 3
                : constraints.maxWidth >= 650
                ? 2
                : 1;
            final width =
                (constraints.maxWidth - ((columns - 1) * 18)) / columns;
            return Wrap(
              spacing: 18,
              runSpacing: 18,
              children: filtered
                  .map(
                    (product) => SizedBox(
                      width: width,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(22),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 245,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7FAFD),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Image.asset(
                                  product.$3,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, _, _) => const Icon(
                                    Icons.local_drink,
                                    size: 90,
                                    color: EmanExperienceApp.blue,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                product.$2,
                                style: const TextStyle(
                                  color: EmanExperienceApp.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${_tx(context, product.$1)} ${_tx(context, 'products.powderDrink')}',
                                style: const TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w500,
                                  color: EmanExperienceApp.navy,
                                ),
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.share_outlined),
                                  label: Text(_tx(context, 'products.share')),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class LocalizedBecomePartnerPage extends StatefulWidget {
  const LocalizedBecomePartnerPage({super.key});

  @override
  State<LocalizedBecomePartnerPage> createState() =>
      _LocalizedBecomePartnerPageState();
}

class _LocalizedBecomePartnerPageState
    extends State<LocalizedBecomePartnerPage> {
  final formKey = GlobalKey<FormState>();
  String country = 'Türkiye';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _tx(context, 'partner.title'),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                    color: EmanExperienceApp.navy,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _tx(context, 'partner.subtitle'),
                  style: const TextStyle(fontSize: 17, height: 1.6),
                ),
                const SizedBox(height: 28),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: _tx(context, 'form.name'),
                              prefixIcon: const Icon(Icons.person_outline),
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? _tx(context, 'form.required')
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: _tx(context, 'form.email'),
                              prefixIcon: const Icon(Icons.email_outlined),
                            ),
                            validator: (value) =>
                                value == null || !value.contains('@')
                                ? _tx(context, 'form.invalidEmail')
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: _tx(context, 'form.phone'),
                              prefixIcon: const Icon(Icons.phone_outlined),
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            initialValue: country,
                            decoration: InputDecoration(
                              labelText: _tx(context, 'form.country'),
                              prefixIcon: const Icon(Icons.public),
                            ),
                            items:
                                const [
                                      'Türkiye',
                                      'Germany',
                                      'Spain',
                                      'Portugal',
                                      'Brazil',
                                      'Russia',
                                      'Saudi Arabia',
                                      'United Arab Emirates',
                                      'Other',
                                    ]
                                    .map(
                                      (item) => DropdownMenuItem(
                                        value: item,
                                        child: Text(item),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              if (value != null)
                                setState(() => country = value);
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            maxLines: 4,
                            decoration: InputDecoration(
                              labelText: _tx(context, 'form.network'),
                              alignLabelWithHint: true,
                              prefixIcon: const Icon(
                                Icons.business_center_outlined,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        _tx(context, 'form.success'),
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.send),
                              label: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                child: Text(_tx(context, 'form.submit')),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
