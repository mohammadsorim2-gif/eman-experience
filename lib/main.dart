import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/app_i18n.dart';
import 'core/app_language.dart';
import 'core/onboarding/feature_tour.dart';
import 'core/search/global_search.dart';
import 'core/theme/app_typography.dart';
import 'core/theme/app_design_system.dart';
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
      fontFamily: AppTypography.familyFor(_language.code),
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
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      navigationDrawerTheme: NavigationDrawerThemeData(
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
          return AppTypography.navigation(
            languageCode: _language.code,
            selected: states.contains(WidgetState.selected),
          );
        }),
      ),
      navigationRailTheme: NavigationRailThemeData(
        useIndicator: true,
        indicatorColor: const Color(0xFFE8F4FA),
        selectedLabelTextStyle: AppTypography.navigation(
          languageCode: _language.code,
          selected: true,
        ),
        unselectedLabelTextStyle: AppTypography.navigation(
          languageCode: _language.code,
        ),
      ),
    );
    return AppDesignSystem.apply(
      base.copyWith(textTheme: AppTypography.textTheme(arabic: arabic)),
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
  bool _tourScheduled = false;

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
    (Icons.home_rounded, 'nav.home', Color(0xFF0879B8)),
    (Icons.grid_view_rounded, 'nav.products', Color(0xFF7657D9)),
    (Icons.person_add_alt_1_rounded, 'nav.partner', Color(0xFF159776)),
    (Icons.request_quote_rounded, 'RFQ', Color(0xFFE87A35)),
    (Icons.space_dashboard_rounded, 'nav.partnerDashboard', Color(0xFF3B68D9)),
    (Icons.precision_manufacturing_rounded, 'nav.factory', Color(0xFFD94F70)),
    (Icons.insights_rounded, 'nav.executive', Color(0xFF8A58C7)),
    (Icons.admin_panel_settings_rounded, 'nav.admin', Color(0xFF536773)),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_tourScheduled) return;
    _tourScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _showTour());
  }

  String _label(String key) {
    if (key == 'RFQ') return key;
    return AppI18n.text(key, widget.language.code);
  }

  String _ui({required String tr, required String ar, required String en}) {
    return switch (widget.language.code) {
      'tr' => tr,
      'ar' => ar,
      _ => en,
    };
  }

  Widget _currentPage() => KeyedSubtree(
    key: ValueKey('${widget.language.code}-$currentIndex'),
    child: pages[currentIndex],
  );

  void _openDestination(int index) {
    if (index < 0 || index >= pages.length) return;
    setState(() => currentIndex = index);
  }

  List<AppSearchItem> _searchItems() {
    final subtitles = [
      _ui(
        tr: 'Ana sayfa ve hızlı erişim',
        ar: 'الصفحة الرئيسية والوصول السريع',
        en: 'Home and quick access',
      ),
      _ui(
        tr: 'Ürünleri keşfedin ve karşılaştırın',
        ar: 'استكشف المنتجات وقارن بينها',
        en: 'Explore and compare products',
      ),
      _ui(
        tr: 'Global satış ortağı olun',
        ar: 'انضم كشريك مبيعات عالمي',
        en: 'Become a global sales partner',
      ),
      _ui(
        tr: 'Teklif talebi oluşturun',
        ar: 'أنشئ طلب عرض سعر',
        en: 'Create a request for quotation',
      ),
      _ui(
        tr: 'Siparişler, komisyonlar ve belgeler',
        ar: 'الطلبات والعمولات والمستندات',
        en: 'Orders, commissions and documents',
      ),
      _ui(
        tr: 'Canlı üretim ve makine takibi',
        ar: 'الإنتاج المباشر ومتابعة الآلات',
        en: 'Live production and machine monitoring',
      ),
      _ui(
        tr: 'KPI, analiz ve yönetim içgörüleri',
        ar: 'المؤشرات والتحليلات والرؤى الإدارية',
        en: 'KPIs, analytics and executive insights',
      ),
      _ui(
        tr: 'Kullanıcılar, roller ve içerik',
        ar: 'المستخدمون والصلاحيات والمحتوى',
        en: 'Users, roles and content',
      ),
    ];
    return List.generate(destinationData.length, (index) {
      final item = destinationData[index];
      return AppSearchItem(
        title: _label(item.$2),
        subtitle: subtitles[index],
        icon: item.$1,
        accent: item.$3,
        destinationIndex: index,
        keywords: [item.$2, subtitles[index]],
      );
    });
  }

  Future<void> _openSearch() async {
    await showGlobalSearch(
      context: context,
      items: _searchItems(),
      onOpen: _openDestination,
      hint: _ui(
        tr: 'Ürün, RFQ, fabrika, yönetim ara...',
        ar: 'ابحث عن منتج، عرض سعر، معمل، إدارة...',
        en: 'Search products, RFQ, factory, management...',
      ),
      emptyLabel: _ui(
        tr: 'Sonuç bulunamadı',
        ar: 'لا توجد نتائج',
        en: 'No results found',
      ),
    );
  }

  Future<void> _showTour() async {
    await showFeatureTourIfNeeded(
      context: context,
      steps: [
        FeatureTourStep(
          title: _ui(
            tr: 'EMAN ONE’a hoş geldiniz',
            ar: 'مرحبًا بك في EMAN ONE',
            en: 'Welcome to EMAN ONE',
          ),
          body: _ui(
            tr: 'Satış, ürünler, üretim ve yönetimi tek platformdan yönetin.',
            ar: 'أدر المبيعات والمنتجات والإنتاج والإدارة من منصة واحدة.',
            en: 'Manage sales, products, production and management in one platform.',
          ),
          icon: Icons.auto_awesome_rounded,
          accent: const Color(0xFF0879B8),
        ),
        FeatureTourStep(
          title: _ui(
            tr: 'Her şeye anında ulaşın',
            ar: 'الوصول الفوري إلى كل شيء',
            en: 'Reach everything instantly',
          ),
          body: _ui(
            tr: 'Global arama ile ürünlere, RFQ’ya ve panellere saniyeler içinde gidin.',
            ar: 'استخدم البحث الشامل للوصول إلى المنتجات وطلبات الأسعار واللوحات خلال ثوانٍ.',
            en: 'Use global search to reach products, RFQs and dashboards in seconds.',
          ),
          icon: Icons.manage_search_rounded,
          accent: const Color(0xFF7657D9),
        ),
        FeatureTourStep(
          title: _ui(
            tr: 'Global satış ağı',
            ar: 'شبكة مبيعات عالمية',
            en: 'Global sales network',
          ),
          body: _ui(
            tr: 'Dünyanın her yerinden partnerler satış yapabilir ve komisyon kazanabilir.',
            ar: 'يمكن للشركاء من أي مكان في العالم البيع وكسب العمولة.',
            en: 'Partners anywhere in the world can sell and earn commission.',
          ),
          icon: Icons.public_rounded,
          accent: const Color(0xFF159776),
        ),
        FeatureTourStep(
          title: _ui(
            tr: 'Canlı fabrika ve yönetim',
            ar: 'إدارة المعمل بشكل مباشر',
            en: 'Live factory and management',
          ),
          body: _ui(
            tr: 'Üretimi, makineleri, KPI’ları ve kararları tek ekrandan takip edin.',
            ar: 'تابع الإنتاج والآلات والمؤشرات والقرارات من شاشة واحدة.',
            en: 'Track production, machines, KPIs and decisions from one screen.',
          ),
          icon: Icons.precision_manufacturing_rounded,
          accent: const Color(0xFFE87A35),
        ),
      ],
      nextLabel: _ui(tr: 'Devam', ar: 'التالي', en: 'Next'),
      finishLabel: _ui(tr: 'Başla', ar: 'ابدأ', en: 'Get started'),
      skipLabel: _ui(tr: 'Atla', ar: 'تخطي', en: 'Skip'),
    );
  }

  Widget _coloredIcon(IconData icon, Color accent, {required bool selected}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: selected ? 40 : 36,
      height: selected ? 40 : 36,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: selected ? .18 : .10),
        borderRadius: BorderRadius.circular(selected ? 14 : 12),
      ),
      child: Icon(icon, color: accent, size: selected ? 22 : 20),
    );
  }

  Widget _searchButton({bool compact = false}) {
    return Tooltip(
      message: _ui(
        tr: 'Her yerde ara',
        ar: 'بحث شامل',
        en: 'Search everywhere',
      ),
      child: Material(
        color: const Color(0xFFF1F6F9),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _openSearch,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 10 : 13,
              vertical: compact ? 9 : 11,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.search_rounded,
                  size: 19,
                  color: Color(0xFF0879B8),
                ),
                if (!compact) ...[
                  const SizedBox(width: 8),
                  Text(
                    _ui(tr: 'Ara', ar: 'بحث', en: 'Search'),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.sizeOf(context).width >= 980;
    if (desktop) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              extended: true,
              minExtendedWidth: 236,
              backgroundColor: Colors.white,
              selectedIndex: currentIndex,
              onDestinationSelected: _openDestination,
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
                    const SizedBox(height: 10),
                    _searchButton(),
                  ],
                ),
              ),
              destinations: destinationData
                  .map(
                    (item) => NavigationRailDestination(
                      icon: _coloredIcon(item.$1, item.$3, selected: false),
                      selectedIcon: _coloredIcon(
                        item.$1,
                        item.$3,
                        selected: true,
                      ),
                      label: Text(
                        _label(item.$2),
                        style: AppTypography.navigation(
                          languageCode: widget.language.code,
                        ),
                      ),
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
          _searchButton(compact: true),
          const SizedBox(width: 6),
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
          _openDestination(value);
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _searchButton(),
          ),
          ...destinationData.map(
            (item) => NavigationDrawerDestination(
              icon: _coloredIcon(item.$1, item.$3, selected: false),
              selectedIcon: _coloredIcon(item.$1, item.$3, selected: true),
              label: Text(
                _label(item.$2),
                style: AppTypography.navigation(
                  languageCode: widget.language.code,
                ),
              ),
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
