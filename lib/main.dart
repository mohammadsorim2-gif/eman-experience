import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/app_i18n.dart';
import 'core/app_language.dart';
import 'screens/executive/advanced_executive_dashboard.dart';
import 'screens/factory/advanced_factory_dashboard.dart';
import 'screens/home/polished_home.dart';
import 'screens/localized/localized_dashboards.dart';
import 'screens/partner/advanced_partner_dashboard.dart';
import 'screens/products/advanced_product_catalog.dart';
import 'screens/public/localized_commerce_pages.dart';
import 'screens/rfq/localized_rfq_builder.dart';

void main() => runApp(const EmanOneApp());

class EmanOneApp extends StatefulWidget {
  const EmanOneApp({super.key});

  @override
  State<EmanOneApp> createState() => _EmanOneAppState();
}

class _EmanOneAppState extends State<EmanOneApp> {
  AppLanguage _language = AppLanguage.defaultLanguage;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final preferences = await SharedPreferences.getInstance();
    final language = AppLanguage.fromCode(
      preferences.getString('app_language'),
    );
    if (mounted) setState(() => _language = language);
  }

  Future<void> _setLanguage(AppLanguage language) async {
    setState(() => _language = language);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('app_language', language.code);
  }

  ThemeData _theme() {
    final arabic = const {'ar', 'fa', 'ur'}.contains(_language.code);
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: EmanExperienceApp.blue,
        primary: EmanExperienceApp.blue,
      ),
      scaffoldBackgroundColor: EmanExperienceApp.background,
      fontFamily: arabic ? 'DINNextLTArabic' : 'NotoSans',
      fontFamilyFallback: arabic
          ? const ['Tahoma', 'Arial', 'sans-serif']
          : const ['Segoe UI', 'Roboto', 'Arial', 'sans-serif'],
      iconTheme: const IconThemeData(size: 20),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: Color(0xFFE4ECF1)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        useIndicator: true,
        indicatorColor: Color(0xFFE8F4FA),
        selectedIconTheme: IconThemeData(
          size: 21,
          color: EmanExperienceApp.blue,
        ),
        unselectedIconTheme: IconThemeData(size: 20, color: Color(0xFF6B7E89)),
        selectedLabelTextStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: EmanExperienceApp.navy,
        ),
        unselectedLabelTextStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Color(0xFF607480),
        ),
      ),
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(
        fontFamily: arabic ? 'DINNextLTArabic' : 'NotoSans',
        fontFamilyFallback: arabic
            ? const ['Tahoma', 'Arial', 'sans-serif']
            : const ['Segoe UI', 'Roboto', 'Arial', 'sans-serif'],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppI18n.text('app.title', _language.code),
      locale: _language.locale,
      supportedLocales: AppLanguage.supported
          .map((item) => item.locale)
          .toList(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        if (deviceLocale == null) return AppLanguage.defaultLanguage.locale;
        final supported = AppLanguage.supported.any(
          (language) => language.code == deviceLocale.languageCode,
        );
        return supported
            ? AppLanguage.fromCode(deviceLocale.languageCode).locale
            : AppLanguage.defaultLanguage.locale;
      },
      builder: (context, child) => AppLocaleScope(
        languageCode: _language.code,
        child: Directionality(
          textDirection: _language.rtl ? TextDirection.rtl : TextDirection.ltr,
          child: child ?? const SizedBox.shrink(),
        ),
      ),
      theme: _theme(),
      home: EmanOneShell(language: _language, onLanguageChanged: _setLanguage),
    );
  }
}

class EmanOneShell extends StatefulWidget {
  const EmanOneShell({
    required this.language,
    required this.onLanguageChanged,
    super.key,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  State<EmanOneShell> createState() => _EmanOneShellState();
}

class _EmanOneShellState extends State<EmanOneShell> {
  int currentIndex = 0;

  static const pages = [
    PolishedHome(),
    AdvancedProductCatalog(),
    LocalizedBecomePartnerPage(),
    LocalizedRfqBuilder(),
    AdvancedPartnerDashboard(),
    AdvancedFactoryDashboard(),
    AdvancedExecutiveDashboard(),
    LocalizedAdminDashboard(),
  ];

  static const destinationData = [
    (Icons.home_rounded, 'nav.home'),
    (Icons.grid_view_rounded, 'nav.products'),
    (Icons.person_add_alt_1_rounded, 'nav.partner'),
    (Icons.request_quote_rounded, 'RFQ'),
    (Icons.space_dashboard_rounded, 'nav.partnerDashboard'),
    (Icons.precision_manufacturing_rounded, 'nav.factory'),
    (Icons.insights_rounded, 'nav.executive'),
    (Icons.admin_panel_settings_rounded, 'nav.admin'),
  ];

  String _label(String key) {
    if (key == 'RFQ') return key;
    return AppI18n.text(key, widget.language.code);
  }

  Widget _currentPage() => KeyedSubtree(
    key: ValueKey('${widget.language.code}-$currentIndex'),
    child: pages[currentIndex],
  );

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.sizeOf(context).width >= 980;
    if (desktop) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              extended: true,
              minExtendedWidth: 226,
              backgroundColor: Colors.white,
              selectedIndex: currentIndex,
              onDestinationSelected: (value) =>
                  setState(() => currentIndex = value),
              leading: Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/logos/Eman logo.png',
                      height: 46,
                      errorBuilder: (_, _, _) => const Text(
                        'EMAN',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      _label('app.platform'),
                      style: const TextStyle(
                        fontSize: 9,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF72838E),
                      ),
                    ),
                    const SizedBox(height: 15),
                    _LanguageSelector(
                      language: widget.language,
                      onChanged: widget.onLanguageChanged,
                      compact: false,
                    ),
                  ],
                ),
              ),
              destinations: destinationData
                  .map(
                    (item) => NavigationRailDestination(
                      icon: Icon(item.$1),
                      selectedIcon: Icon(item.$1),
                      label: Text(_label(item.$2)),
                    ),
                  )
                  .toList(),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: _currentPage(),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            Image.asset(
              'assets/logos/Eman logo.png',
              height: 34,
              errorBuilder: (_, _, _) => const Text('EMAN'),
            ),
            const SizedBox(width: 8),
            const Text(
              'ONE',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          _LanguageSelector(
            language: widget.language,
            onChanged: widget.onLanguageChanged,
            compact: true,
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: NavigationDrawer(
        selectedIndex: currentIndex,
        onDestinationSelected: (value) {
          setState(() => currentIndex = value);
          Navigator.pop(context);
        },
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 24, 16, 12),
            child: Text(
              _label('app.title'),
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
            ),
          ),
          ...destinationData.map(
            (item) => NavigationDrawerDestination(
              icon: Icon(item.$1, size: 20),
              selectedIcon: Icon(item.$1, size: 20),
              label: Text(_label(item.$2)),
            ),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        child: _currentPage(),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector({
    required this.language,
    required this.onChanged,
    required this.compact,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AppLanguage>(
      tooltip: AppI18n.text('common.language', language.code),
      onSelected: onChanged,
      constraints: const BoxConstraints(maxHeight: 520, minWidth: 240),
      itemBuilder: (context) => AppLanguage.supported
          .map(
            (item) => PopupMenuItem<AppLanguage>(
              value: item,
              child: Row(
                children: [
                  SizedBox(
                    width: 34,
                    child: Text(
                      item.code.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: EmanExperienceApp.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(child: Text(item.nativeName)),
                  if (item.code == language.code)
                    const Icon(
                      Icons.check_rounded,
                      size: 17,
                      color: EmanExperienceApp.blue,
                    ),
                ],
              ),
            ),
          )
          .toList(),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 9 : 12,
          vertical: compact ? 7 : 9,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F6F9),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: const Color(0xFFDFE8ED)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language_rounded, size: 17),
            if (!compact) ...[
              const SizedBox(width: 7),
              Text(
                language.nativeName,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            const SizedBox(width: 3),
            const Icon(Icons.expand_more_rounded, size: 17),
          ],
        ),
      ),
    );
  }
}
