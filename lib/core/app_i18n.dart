import 'package:flutter/widgets.dart';

class AppI18n {
  const AppI18n._();

  static const defaultCode = 'tr';

  static const Map<String, Map<String, String>> _values = {
    'app.title': {'tr': 'EMAN ONE', 'en': 'EMAN ONE', 'ar': 'EMAN ONE'},
    'app.platform': {
      'tr': 'TEK PLATFORM',
      'en': 'ONE PLATFORM',
      'ar': 'منصة واحدة',
      'es': 'UNA PLATAFORMA',
      'pt': 'UMA PLATAFORMA',
      'ru': 'ЕДИНАЯ ПЛАТФОРМА',
      'fr': 'UNE SEULE PLATEFORME',
      'de': 'EINE PLATTFORM',
    },
    'nav.home': {
      'tr': 'Ana Sayfa',
      'en': 'Home',
      'ar': 'الرئيسية',
      'es': 'Inicio',
      'pt': 'Início',
      'ru': 'Главная',
      'fr': 'Accueil',
      'de': 'Startseite',
    },
    'nav.products': {
      'tr': 'Ürünler',
      'en': 'Products',
      'ar': 'المنتجات',
      'es': 'Productos',
      'pt': 'Produtos',
      'ru': 'Продукты',
      'fr': 'Produits',
      'de': 'Produkte',
    },
    'nav.partner': {
      'tr': 'Satış Ortağı Ol',
      'en': 'Become a Partner',
      'ar': 'كن شريك مبيعات',
      'es': 'Ser socio',
      'pt': 'Seja parceiro',
      'ru': 'Стать партнёром',
      'fr': 'Devenir partenaire',
      'de': 'Partner werden',
    },
    'nav.partnerDashboard': {
      'tr': 'Partner Paneli',
      'en': 'Partner Dashboard',
      'ar': 'لوحة الشريك',
      'es': 'Panel del socio',
      'pt': 'Painel do parceiro',
      'ru': 'Панель партнёра',
      'fr': 'Espace partenaire',
      'de': 'Partnerbereich',
    },
    'nav.factory': {
      'tr': 'EMAN Fabrika',
      'en': 'EMAN Factory',
      'ar': 'إدارة المعمل',
      'es': 'Fábrica EMAN',
      'pt': 'Fábrica EMAN',
      'ru': 'Фабрика EMAN',
      'fr': 'Usine EMAN',
      'de': 'EMAN Werk',
    },
    'nav.executive': {
      'tr': 'Yönetim Merkezi',
      'en': 'Executive Center',
      'ar': 'مركز الإدارة',
      'es': 'Centro ejecutivo',
      'pt': 'Centro executivo',
      'ru': 'Центр управления',
      'fr': 'Centre exécutif',
      'de': 'Management Center',
    },
    'nav.admin': {
      'tr': 'Yönetici Paneli',
      'en': 'Admin',
      'ar': 'لوحة الإدارة',
      'es': 'Administración',
      'pt': 'Administração',
      'ru': 'Администрирование',
      'fr': 'Administration',
      'de': 'Administration',
    },
    'common.language': {
      'tr': 'Dil',
      'en': 'Language',
      'ar': 'اللغة',
      'es': 'Idioma',
      'pt': 'Idioma',
      'ru': 'Язык',
      'fr': 'Langue',
      'de': 'Sprache',
    },
    'home.eyebrow': {
      'tr': 'KÜRESEL İÇECEK ÜRETİCİSİ',
      'en': 'GLOBAL BEVERAGE MANUFACTURER',
      'ar': 'مصنّع مشروبات عالمي',
      'es': 'FABRICANTE GLOBAL DE BEBIDAS',
      'pt': 'FABRICANTE GLOBAL DE BEBIDAS',
      'ru': 'МИРОВОЙ ПРОИЗВОДИТЕЛЬ НАПИТКОВ',
      'fr': 'FABRICANT MONDIAL DE BOISSONS',
      'de': 'GLOBALER GETRÄNKEHERSTELLER',
    },
    'home.heroTitle': {
      'tr': 'Dünyaya üretiyor,\nortaklarımızla büyüyoruz.',
      'en': 'Built for the world,\ngrowing with partners.',
      'ar': 'نصنع للعالم،\nوننمو مع شركائنا.',
      'es': 'Producimos para el mundo,\ncrecemos con socios.',
      'pt': 'Produzimos para o mundo,\ncrescemos com parceiros.',
      'ru': 'Производим для мира,\nрастём вместе с партнёрами.',
      'fr': 'Produire pour le monde,\ngrandir avec nos partenaires.',
      'de': 'Für die Welt produziert,\nmit Partnern gewachsen.',
    },
    'home.heroSubtitle': {
      'tr':
          'EMAN ONE; toptan satış, küresel satış ortaklığı, fabrika operasyonları ve yönetim kararlarını tek profesyonel platformda birleştirir.',
      'en':
          'EMAN ONE unifies wholesale sales, global partner growth, factory operations and executive decisions in one professional platform.',
      'ar':
          'تجمع EMAN ONE مبيعات الجملة وشبكة الشركاء العالمية وعمليات المعمل وقرارات الإدارة ضمن منصة احترافية واحدة.',
      'es':
          'EMAN ONE reúne ventas mayoristas, socios globales, operaciones de fábrica y decisiones ejecutivas en una sola plataforma.',
      'pt':
          'A EMAN ONE reúne vendas por atacado, parceiros globais, operações de fábrica e decisões executivas em uma única plataforma.',
      'ru':
          'EMAN ONE объединяет оптовые продажи, глобальных партнёров, производство и управленческие решения в одной платформе.',
      'fr':
          'EMAN ONE réunit ventes en gros, partenaires mondiaux, opérations d’usine et décisions de direction sur une seule plateforme.',
      'de':
          'EMAN ONE vereint Großhandel, globale Partner, Werksbetrieb und Managemententscheidungen auf einer Plattform.',
    },
    'home.exploreProducts': {
      'tr': 'Ürünleri Keşfet',
      'en': 'Explore Products',
      'ar': 'استكشف المنتجات',
      'es': 'Explorar productos',
      'pt': 'Explorar produtos',
      'ru': 'Смотреть продукты',
      'fr': 'Découvrir les produits',
      'de': 'Produkte entdecken',
    },
    'home.becomePartner': {
      'tr': 'Satış Ortağı Ol',
      'en': 'Become a Sales Partner',
      'ar': 'كن شريك مبيعات',
      'es': 'Ser socio comercial',
      'pt': 'Seja parceiro de vendas',
      'ru': 'Стать партнёром',
      'fr': 'Devenir partenaire commercial',
      'de': 'Vertriebspartner werden',
    },
    'home.proofGlobal': {
      'tr': 'Dünya çapında çalışma',
      'en': 'Work worldwide',
      'ar': 'اعمل من أي مكان',
      'es': 'Trabaja globalmente',
      'pt': 'Trabalhe globalmente',
      'ru': 'Работа по всему миру',
      'fr': 'Travaillez partout',
      'de': 'Weltweit arbeiten',
    },
    'home.proofFactory': {
      'tr': 'Fabrika ile tam bağlantı',
      'en': 'Connected to factory operations',
      'ar': 'مرتبط مباشرة بإدارة المعمل',
      'es': 'Conectado con la fábrica',
      'pt': 'Conectado à fábrica',
      'ru': 'Связь с производством',
      'fr': 'Connecté à l’usine',
      'de': 'Mit dem Werk verbunden',
    },
    'home.proofCommission': {
      'tr': 'Şeffaf komisyon takibi',
      'en': 'Transparent commission tracking',
      'ar': 'تتبّع شفاف للعمولات',
      'es': 'Seguimiento transparente',
      'pt': 'Comissões transparentes',
      'ru': 'Прозрачные комиссии',
      'fr': 'Suivi transparent des commissions',
      'de': 'Transparente Provisionen',
    },
    'home.badgeCountriesValue': {'tr': '38+', 'en': '38+', 'ar': '38+'},
    'home.badgeCountriesLabel': {
      'tr': 'aktif ülke',
      'en': 'active countries',
      'ar': 'دولة نشطة',
      'es': 'países activos',
      'pt': 'países ativos',
      'ru': 'активных стран',
      'fr': 'pays actifs',
      'de': 'aktive Länder',
    },
    'home.badgePartnersValue': {'tr': '1.200+', 'en': '1,200+', 'ar': '1,200+'},
    'home.badgePartnersLabel': {
      'tr': 'satış ortağı',
      'en': 'sales partners',
      'ar': 'شريك مبيعات',
      'es': 'socios de ventas',
      'pt': 'parceiros de vendas',
      'ru': 'партнёров',
      'fr': 'partenaires',
      'de': 'Vertriebspartner',
    },
    'home.capabilitiesTitle': {
      'tr': 'Tek platform, dört güçlü iş alanı',
      'en': 'One platform, four powerful business areas',
      'ar': 'منصة واحدة، أربعة مجالات عمل قوية',
      'es': 'Una plataforma, cuatro áreas potentes',
      'pt': 'Uma plataforma, quatro áreas fortes',
      'ru': 'Одна платформа, четыре направления',
      'fr': 'Une plateforme, quatre pôles puissants',
      'de': 'Eine Plattform, vier starke Bereiche',
    },
    'home.capabilitiesSubtitle': {
      'tr':
          'Müşteriden üretime, sevkiyattan komisyona kadar tüm süreç tek akışta.',
      'en':
          'From customer to production, shipment and commission, every step stays connected.',
      'ar': 'من العميل إلى الإنتاج والشحن والعمولة، كل المراحل مترابطة.',
      'es': 'Del cliente a producción, envío y comisión, todo está conectado.',
      'pt':
          'Do cliente à produção, envio e comissão, tudo permanece conectado.',
      'ru': 'От клиента до производства, отгрузки и комиссии — всё связано.',
      'fr':
          'Du client à la production, l’expédition et la commission, tout reste connecté.',
      'de':
          'Vom Kunden bis Produktion, Versand und Provision bleibt alles verbunden.',
    },
    'home.cardWholesaleTitle': {
      'tr': 'Toptan Satış',
      'en': 'Wholesale Commerce',
      'ar': 'تجارة الجملة',
      'es': 'Comercio mayorista',
      'pt': 'Comércio atacadista',
      'ru': 'Оптовая торговля',
      'fr': 'Commerce de gros',
      'de': 'Großhandel',
    },
    'home.cardWholesaleText': {
      'tr': 'Ürün kataloğu, teklif talepleri ve ihracat süreçleri.',
      'en': 'Product catalog, quote requests and export workflows.',
      'ar': 'كاتالوج المنتجات وطلبات الأسعار ومسارات التصدير.',
    },
    'home.cardPartnerTitle': {
      'tr': 'Küresel Satış Ağı',
      'en': 'Global Sales Network',
      'ar': 'شبكة مبيعات عالمية',
      'es': 'Red global de ventas',
      'pt': 'Rede global de vendas',
      'ru': 'Глобальная сеть продаж',
      'fr': 'Réseau commercial mondial',
      'de': 'Globales Vertriebsnetz',
    },
    'home.cardPartnerText': {
      'tr':
          'Herkes satış ortağı olabilir, müşteri kazandırabilir ve komisyonunu izleyebilir.',
      'en':
          'Anyone can become a partner, introduce buyers and track approved commissions.',
      'ar': 'يمكن لأي شخص أن يصبح شريكًا ويجلب العملاء ويتابع عمولاته.',
    },
    'home.cardFactoryTitle': {
      'tr': 'Fabrika Operasyonları',
      'en': 'Factory Operations',
      'ar': 'عمليات المعمل',
      'es': 'Operaciones de fábrica',
      'pt': 'Operações de fábrica',
      'ru': 'Производственные операции',
      'fr': 'Opérations d’usine',
      'de': 'Werksbetrieb',
    },
    'home.cardFactoryText': {
      'tr': 'Üretim, kalite, stok, bakım, depo ve sevkiyat yönetimi.',
      'en':
          'Production, quality, inventory, maintenance, warehouse and shipping.',
      'ar': 'الإنتاج والجودة والمخزون والصيانة والمستودع والشحن.',
    },
    'home.cardExecutiveTitle': {
      'tr': 'Yönetim Merkezi',
      'en': 'Executive Center',
      'ar': 'مركز الإدارة',
      'es': 'Centro ejecutivo',
      'pt': 'Centro executivo',
      'ru': 'Центр управления',
      'fr': 'Centre exécutif',
      'de': 'Management Center',
    },
    'home.cardExecutiveText': {
      'tr': 'Satış, üretim ve finans performansını tek ekrandan izleyin.',
      'en':
          'Monitor sales, production and financial performance from one view.',
      'ar': 'راقب المبيعات والإنتاج والأداء المالي من شاشة واحدة.',
    },
    'home.partnerBannerTitle': {
      'tr': 'Dünyanın her yerinden EMAN satış ortağı olun',
      'en': 'Become an EMAN sales partner from anywhere',
      'ar': 'كن شريك مبيعات لـ EMAN من أي مكان في العالم',
      'es': 'Sé socio comercial de EMAN desde cualquier lugar',
      'pt': 'Seja parceiro comercial da EMAN em qualquer lugar',
      'ru': 'Станьте партнёром EMAN из любой точки мира',
      'fr': 'Devenez partenaire EMAN où que vous soyez',
      'de': 'Werden Sie weltweit EMAN-Vertriebspartner',
    },
    'home.partnerBannerText': {
      'tr':
          'Kendi bağlantınızı paylaşın, nitelikli alıcılar kazandırın ve tamamlanan satışlardan onaylı komisyon alın.',
      'en':
          'Share your personal link, introduce qualified buyers and earn approved commission from completed sales.',
      'ar':
          'شارك رابطك الخاص، واجلب مشترين مؤهلين، واحصل على عمولة معتمدة من الصفقات المكتملة.',
    },
    'home.partnerBannerButton': {
      'tr': 'Hemen Başvur',
      'en': 'Apply Now',
      'ar': 'قدّم الآن',
      'es': 'Solicitar ahora',
      'pt': 'Inscreva-se agora',
      'ru': 'Подать заявку',
      'fr': 'Postuler maintenant',
      'de': 'Jetzt bewerben',
    },
    'factory.title': {
      'tr': 'EMAN Fabrika Komuta Merkezi',
      'en': 'EMAN Factory Command Center',
      'ar': 'مركز قيادة معمل EMAN',
    },
    'factory.subtitle': {
      'tr': 'Canlı üretim, kalite, stok, bakım ve sevkiyat görünümü.',
      'en':
          'Live production, quality, inventory, maintenance and shipment overview.',
      'ar': 'نظرة مباشرة على الإنتاج والجودة والمخزون والصيانة والشحن.',
    },
    'factory.online': {
      'tr': 'Fabrika Çevrimiçi',
      'en': 'Factory Online',
      'ar': 'المعمل متصل',
    },
    'executive.title': {
      'tr': 'EMAN Yönetim Merkezi',
      'en': 'EMAN Executive Center',
      'ar': 'مركز إدارة EMAN',
    },
  };

  static String text(String key, String languageCode) {
    final translations = _values[key];
    if (translations == null) return key;
    return translations[languageCode] ?? translations[defaultCode] ?? key;
  }

  static bool hasTurkishSource(String key) =>
      _values[key]?.containsKey(defaultCode) ?? false;
}

class AppLocaleScope extends InheritedWidget {
  const AppLocaleScope({
    required this.languageCode,
    required super.child,
    super.key,
  });

  final String languageCode;

  static AppLocaleScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppLocaleScope>();
    assert(scope != null, 'AppLocaleScope is missing above this context.');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppLocaleScope oldWidget) =>
      languageCode != oldWidget.languageCode;
}

extension AppTranslationX on BuildContext {
  String t(String key) =>
      AppI18n.text(key, AppLocaleScope.of(this).languageCode);
}
