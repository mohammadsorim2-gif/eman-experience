import 'package:flutter/widgets.dart';

/// Turkish-first localization registry.
///
/// Every key must exist in Turkish. Missing translations always fall back to
/// Turkish, never English. UI text should be retrieved through [context.t].
class AppI18n {
  const AppI18n._();

  static const defaultCode = 'tr';

  static const Map<String, Map<String, String>> _values = {
    'app.title': {
      'tr': 'EMAN ONE',
      'en': 'EMAN ONE',
      'ar': 'EMAN ONE',
      'es': 'EMAN ONE',
      'pt': 'EMAN ONE',
      'ru': 'EMAN ONE',
      'fr': 'EMAN ONE',
      'de': 'EMAN ONE',
    },
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
      'tr': 'Ana Sayfa', 'en': 'Home', 'ar': 'الرئيسية', 'es': 'Inicio',
      'pt': 'Início', 'ru': 'Главная', 'fr': 'Accueil', 'de': 'Startseite',
    },
    'nav.products': {
      'tr': 'Ürünler', 'en': 'Products', 'ar': 'المنتجات', 'es': 'Productos',
      'pt': 'Produtos', 'ru': 'Продукты', 'fr': 'Produits', 'de': 'Produkte',
    },
    'nav.partner': {
      'tr': 'Satış Ortağı Ol', 'en': 'Become a Partner', 'ar': 'كن شريك مبيعات',
      'es': 'Ser socio', 'pt': 'Seja parceiro', 'ru': 'Стать партнёром',
      'fr': 'Devenir partenaire', 'de': 'Partner werden',
    },
    'nav.partnerDashboard': {
      'tr': 'Partner Paneli', 'en': 'Partner Dashboard', 'ar': 'لوحة الشريك',
      'es': 'Panel del socio', 'pt': 'Painel do parceiro',
      'ru': 'Панель партнёра', 'fr': 'Espace partenaire', 'de': 'Partnerbereich',
    },
    'nav.factory': {
      'tr': 'EMAN Fabrika', 'en': 'EMAN Factory', 'ar': 'إدارة المعمل',
      'es': 'Fábrica EMAN', 'pt': 'Fábrica EMAN', 'ru': 'Фабрика EMAN',
      'fr': 'Usine EMAN', 'de': 'EMAN Werk',
    },
    'nav.executive': {
      'tr': 'Yönetim Merkezi', 'en': 'Executive Center', 'ar': 'مركز الإدارة',
      'es': 'Centro ejecutivo', 'pt': 'Centro executivo',
      'ru': 'Центр управления', 'fr': 'Centre exécutif', 'de': 'Management Center',
    },
    'nav.admin': {
      'tr': 'Yönetici Paneli', 'en': 'Admin', 'ar': 'لوحة الإدارة',
      'es': 'Administración', 'pt': 'Administração',
      'ru': 'Администрирование', 'fr': 'Administration', 'de': 'Administration',
    },
    'common.language': {
      'tr': 'Dil', 'en': 'Language', 'ar': 'اللغة', 'es': 'Idioma',
      'pt': 'Idioma', 'ru': 'Язык', 'fr': 'Langue', 'de': 'Sprache',
    },
    'common.search': {
      'tr': 'Ara', 'en': 'Search', 'ar': 'بحث', 'es': 'Buscar',
      'pt': 'Pesquisar', 'ru': 'Поиск', 'fr': 'Rechercher', 'de': 'Suchen',
    },
    'common.save': {
      'tr': 'Kaydet', 'en': 'Save', 'ar': 'حفظ', 'es': 'Guardar',
      'pt': 'Salvar', 'ru': 'Сохранить', 'fr': 'Enregistrer', 'de': 'Speichern',
    },
    'common.cancel': {
      'tr': 'İptal', 'en': 'Cancel', 'ar': 'إلغاء', 'es': 'Cancelar',
      'pt': 'Cancelar', 'ru': 'Отмена', 'fr': 'Annuler', 'de': 'Abbrechen',
    },
    'factory.title': {
      'tr': 'EMAN Fabrika Komuta Merkezi',
      'en': 'EMAN Factory Command Center',
      'ar': 'مركز قيادة معمل EMAN',
      'es': 'Centro de Control de Fábrica EMAN',
      'pt': 'Centro de Comando da Fábrica EMAN',
      'ru': 'Центр управления фабрикой EMAN',
      'fr': 'Centre de commande de l’usine EMAN',
      'de': 'EMAN Werksleitstand',
    },
    'factory.subtitle': {
      'tr': 'Canlı üretim, kalite, stok, bakım ve sevkiyat görünümü.',
      'en': 'Live production, quality, inventory, maintenance and shipment overview.',
      'ar': 'نظرة مباشرة على الإنتاج والجودة والمخزون والصيانة والشحن.',
      'es': 'Vista en vivo de producción, calidad, inventario, mantenimiento y envíos.',
      'pt': 'Visão em tempo real da produção, qualidade, estoque, manutenção e expedição.',
      'ru': 'Оперативный обзор производства, качества, запасов, обслуживания и отгрузок.',
      'fr': 'Vue en direct de la production, qualité, stock, maintenance et expéditions.',
      'de': 'Live-Übersicht über Produktion, Qualität, Bestand, Wartung und Versand.',
    },
    'factory.online': {
      'tr': 'Fabrika Çevrimiçi', 'en': 'Factory Online', 'ar': 'المعمل متصل',
      'es': 'Fábrica en línea', 'pt': 'Fábrica online', 'ru': 'Фабрика онлайн',
      'fr': 'Usine en ligne', 'de': 'Werk online',
    },
    'executive.title': {
      'tr': 'EMAN Yönetim Merkezi', 'en': 'EMAN Executive Center',
      'ar': 'مركز إدارة EMAN', 'es': 'Centro Ejecutivo EMAN',
      'pt': 'Centro Executivo EMAN', 'ru': 'Центр управления EMAN',
      'fr': 'Centre exécutif EMAN', 'de': 'EMAN Management Center',
    },
  };

  static String text(String key, String languageCode) {
    final translations = _values[key];
    if (translations == null) return key;
    return translations[languageCode] ?? translations[defaultCode] ?? key;
  }

  static bool hasTurkishSource(String key) => _values[key]?.containsKey(defaultCode) ?? false;
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
  bool updateShouldNotify(AppLocaleScope oldWidget) => languageCode != oldWidget.languageCode;
}

extension AppTranslationX on BuildContext {
  String t(String key) => AppI18n.text(key, AppLocaleScope.of(this).languageCode);
}
