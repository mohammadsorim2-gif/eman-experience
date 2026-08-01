import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/app_i18n.dart';
import 'core/app_language.dart';
import 'screens/executive/executive_dashboard.dart';
import 'screens/factory/factory_dashboard.dart';
import 'screens/home/localized_home.dart';
import 'screens/public/localized_commerce_pages.dart';

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
    final language = AppLanguage.fromCode(preferences.getString('app_language'));
    if (mounted) setState(() => _language = language);
  }

  Future<void> _setLanguage(AppLanguage language) async {
    setState(() => _language = language);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('app_language', language.code);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppI18n.text('app.title', _language.code),
      locale: _language.locale,
      supportedLocales: AppLanguage.supported.map((item) => item.locale).toList(),
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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: EmanExperienceApp.blue,
          primary: EmanExperienceApp.blue,
        ),
        scaffoldBackgroundColor: EmanExperienceApp.background,
        fontFamily: 'Arial',
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Color(0xFFE7EDF3)),
          ),
        ),
      ),
      home: EmanOneShell(
        language: _language,
        onLanguageChanged: _setLanguage,
      ),
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
    LocalizedHome(),
    LocalizedProductsPage(),
    LocalizedBecomePartnerPage(),
    PartnerDashboard(),
    FactoryDashboard(),
    ExecutiveDashboard(),
    AdminPreviewPage(),
  ];

  static const destinationData = [
    (Icons.home_outlined, Icons.home, 'nav.home'),
    (Icons.inventory_2_outlined, Icons.inventory_2, 'nav.products'),
    (Icons.person_add_alt_outlined, Icons.person_add_alt, 'nav.partner'),
    (Icons.dashboard_outlined, Icons.dashboard, 'nav.partnerDashboard'),
    (Icons.factory_outlined, Icons.factory, 'nav.factory'),
    (Icons.monitor_heart_outlined, Icons.monitor_heart, 'nav.executive'),
    (Icons.admin_panel_settings_outlined, Icons.admin_panel_settings, 'nav.admin'),
  ];

  String _label(String key) => AppI18n.text(key, widget.language.code);

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
              minExtendedWidth: 246,
              backgroundColor: Colors.white,
              selectedIndex: currentIndex,
              onDestinationSelected: (value) => setState(() => currentIndex = value),
              leading: Padding(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/logos/Eman logo.png',
                      height: 52,
                      errorBuilder: (_, _, _) => const Text(
                        'EMAN',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _label('app.platform'),
                      style: const TextStyle(
                        fontSize: 10,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF72838E),
                      ),
                    ),
                    const SizedBox(height: 18),
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
                      selectedIcon: Icon(item.$2),
                      label: Text(_label(item.$3)),
                    ),
                  )
                  .toList(),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
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
              height: 38,
              errorBuilder: (_, _, _) => const Text('EMAN'),
            ),
            const SizedBox(width: 10),
            const Text('ONE', style: TextStyle(fontWeight: FontWeight.w900)),
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
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
          ),
          ...destinationData.map(
            (item) => NavigationDrawerDestination(
              icon: Icon(item.$1),
              selectedIcon: Icon(item.$2),
              label: Text(_label(item.$3)),
            ),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
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
      constraints: const BoxConstraints(maxHeight: 520, minWidth: 250),
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
                        color: EmanExperienceApp.blue,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Expanded(child: Text(item.nativeName)),
                  if (item.code == language.code)
                    const Icon(Icons.check, size: 18, color: EmanExperienceApp.blue),
                ],
              ),
            ),
          )
          .toList(),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 10 : 14,
          vertical: compact ? 8 : 10,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F7FA),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE0E9EF)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language, size: 19),
            if (!compact) ...[
              const SizedBox(width: 8),
              Text(language.nativeName, style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
            const SizedBox(width: 4),
            const Icon(Icons.expand_more, size: 18),
          ],
        ),
      ),
    );
  }
}
