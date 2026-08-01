import 'package:flutter/material.dart';

class AppLanguage {
  const AppLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    this.countryCode,
    this.rtl = false,
  });

  final String code;
  final String name;
  final String nativeName;
  final String? countryCode;
  final bool rtl;

  Locale get locale => Locale(code, countryCode);

  static const supported = <AppLanguage>[
    AppLanguage(code: 'en', name: 'English', nativeName: 'English', countryCode: 'US'),
    AppLanguage(code: 'tr', name: 'Turkish', nativeName: 'Türkçe', countryCode: 'TR'),
    AppLanguage(code: 'ar', name: 'Arabic', nativeName: 'العربية', countryCode: 'SA', rtl: true),
    AppLanguage(code: 'es', name: 'Spanish', nativeName: 'Español', countryCode: 'ES'),
    AppLanguage(code: 'pt', name: 'Portuguese', nativeName: 'Português', countryCode: 'BR'),
    AppLanguage(code: 'ru', name: 'Russian', nativeName: 'Русский', countryCode: 'RU'),
    AppLanguage(code: 'fr', name: 'French', nativeName: 'Français', countryCode: 'FR'),
    AppLanguage(code: 'de', name: 'German', nativeName: 'Deutsch', countryCode: 'DE'),
    AppLanguage(code: 'it', name: 'Italian', nativeName: 'Italiano', countryCode: 'IT'),
    AppLanguage(code: 'nl', name: 'Dutch', nativeName: 'Nederlands', countryCode: 'NL'),
    AppLanguage(code: 'pl', name: 'Polish', nativeName: 'Polski', countryCode: 'PL'),
    AppLanguage(code: 'uk', name: 'Ukrainian', nativeName: 'Українська', countryCode: 'UA'),
    AppLanguage(code: 'fa', name: 'Persian', nativeName: 'فارسی', countryCode: 'IR', rtl: true),
    AppLanguage(code: 'ur', name: 'Urdu', nativeName: 'اردو', countryCode: 'PK', rtl: true),
    AppLanguage(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', countryCode: 'IN'),
    AppLanguage(code: 'bn', name: 'Bengali', nativeName: 'বাংলা', countryCode: 'BD'),
    AppLanguage(code: 'zh', name: 'Chinese', nativeName: '中文', countryCode: 'CN'),
    AppLanguage(code: 'ja', name: 'Japanese', nativeName: '日本語', countryCode: 'JP'),
    AppLanguage(code: 'ko', name: 'Korean', nativeName: '한국어', countryCode: 'KR'),
    AppLanguage(code: 'id', name: 'Indonesian', nativeName: 'Bahasa Indonesia', countryCode: 'ID'),
  ];

  static AppLanguage fromCode(String? code) {
    return supported.firstWhere(
      (language) => language.code == code,
      orElse: () => supported.first,
    );
  }
}

class AppWords {
  const AppWords._();

  static const _labels = <String, Map<String, String>>{
    'home': {
      'en': 'Home', 'tr': 'Ana Sayfa', 'ar': 'الرئيسية', 'es': 'Inicio',
      'pt': 'Início', 'ru': 'Главная', 'fr': 'Accueil', 'de': 'Startseite',
    },
    'products': {
      'en': 'Products', 'tr': 'Ürünler', 'ar': 'المنتجات', 'es': 'Productos',
      'pt': 'Produtos', 'ru': 'Продукты', 'fr': 'Produits', 'de': 'Produkte',
    },
    'partner': {
      'en': 'Become Partner', 'tr': 'Partner Ol', 'ar': 'كن شريكاً',
      'es': 'Ser socio', 'pt': 'Seja parceiro', 'ru': 'Стать партнёром',
      'fr': 'Devenir partenaire', 'de': 'Partner werden',
    },
    'partnerDashboard': {
      'en': 'Partner Dashboard', 'tr': 'Partner Paneli', 'ar': 'لوحة الشريك',
      'es': 'Panel del socio', 'pt': 'Painel do parceiro',
      'ru': 'Панель партнёра', 'fr': 'Espace partenaire', 'de': 'Partnerbereich',
    },
    'factory': {
      'en': 'EMAN Factory', 'tr': 'EMAN Fabrika', 'ar': 'إدارة المعمل',
      'es': 'Fábrica EMAN', 'pt': 'Fábrica EMAN', 'ru': 'Фабрика EMAN',
      'fr': 'Usine EMAN', 'de': 'EMAN Werk',
    },
    'executive': {
      'en': 'Executive Center', 'tr': 'Yönetim Merkezi', 'ar': 'مركز الإدارة',
      'es': 'Centro ejecutivo', 'pt': 'Centro executivo',
      'ru': 'Центр управления', 'fr': 'Centre exécutif', 'de': 'Management Center',
    },
    'admin': {
      'en': 'Admin', 'tr': 'Yönetici', 'ar': 'الإدارة', 'es': 'Administración',
      'pt': 'Administração', 'ru': 'Администрирование', 'fr': 'Administration',
      'de': 'Administration',
    },
    'language': {
      'en': 'Language', 'tr': 'Dil', 'ar': 'اللغة', 'es': 'Idioma',
      'pt': 'Idioma', 'ru': 'Язык', 'fr': 'Langue', 'de': 'Sprache',
    },
  };

  static String get(String key, String languageCode) {
    final values = _labels[key];
    if (values == null) return key;
    return values[languageCode] ?? values['en'] ?? key;
  }
}
