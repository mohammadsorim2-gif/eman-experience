import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'localization.dart';

class EmanExperienceApp extends StatefulWidget {
  const EmanExperienceApp({super.key});

  @override
  State<EmanExperienceApp> createState() => _EmanExperienceAppState();
}

class _EmanExperienceAppState extends State<EmanExperienceApp> {
  static const _languageKey = 'eman_language';
  String _language = 'en';

  @override
  void initState() {
    super.initState();
    _restoreLanguage();
  }

  Future<void> _restoreLanguage() async {
    final preferences = await SharedPreferences.getInstance();
    final requested = Uri.base.queryParameters['lang'];
    final saved = preferences.getString(_languageKey);
    final resolved =
        requested != null && EmanLocalization.supported.contains(requested)
        ? requested
        : saved;
    if (resolved != null &&
        EmanLocalization.supported.contains(resolved) &&
        mounted) {
      setState(() => _language = resolved);
    }
  }

  Future<void> _setLanguage(String language) async {
    setState(() => _language = language);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_languageKey, language);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Locale(_language);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: EmanLocalization.supported
          .map(Locale.new)
          .toList(growable: false),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateTitle: (_) => EmanLocalization(_language).text('seoTitle'),
      theme: EmanTheme.theme,
      home: Directionality(
        textDirection: _language == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: EmanHomePage(
          language: _language,
          onLanguageChanged: _setLanguage,
        ),
      ),
    );
  }
}

abstract final class EmanTheme {
  static const blue = Color(0xFF006BB7);
  static const navy = Color(0xFF072C4C);
  static const paleBlue = Color(0xFFEAF4FA);
  static const mist = Color(0xFFF5F7F8);
  static const line = Color(0xFFDDE5EA);
  static const muted = Color(0xFF62717C);

  static ThemeData get theme {
    const baseText = TextStyle(fontFamily: 'Arial');
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: blue,
        primary: blue,
        surface: Colors.white,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Arial',
          color: navy,
          fontSize: 72,
          height: 1.02,
          fontWeight: FontWeight.w800,
          letterSpacing: -2.6,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Arial',
          color: navy,
          fontSize: 48,
          height: 1.08,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.4,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Arial',
          color: navy,
          fontSize: 26,
          height: 1.2,
          fontWeight: FontWeight.w700,
          letterSpacing: -.4,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Arial',
          color: navy,
          fontSize: 19,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Arial',
          color: muted,
          fontSize: 18,
          height: 1.65,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Arial',
          color: muted,
          fontSize: 15,
          height: 1.55,
        ),
      ).apply(bodyColor: muted, displayColor: navy),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: navy,
          textStyle: baseText.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          textStyle: baseText.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: navy,
          padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          side: const BorderSide(color: navy),
          textStyle: baseText.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class EmanHomePage extends StatefulWidget {
  const EmanHomePage({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  final String language;
  final ValueChanged<String> onLanguageChanged;

  @override
  State<EmanHomePage> createState() => _EmanHomePageState();
}

class _EmanHomePageState extends State<EmanHomePage> {
  final _homeKey = GlobalKey();
  final _brandsKey = GlobalKey();
  final _productsKey = GlobalKey();
  final _manufacturingKey = GlobalKey();
  final _privateLabelKey = GlobalKey();
  final _exportKey = GlobalKey();
  final _contactKey = GlobalKey();

  EmanLocalization get copy => EmanLocalization(widget.language);

  void _scrollTo(GlobalKey key) {
    final target = key.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      alignment: .02,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SelectionArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _topBar()),
            SliverPersistentHeader(
              pinned: true,
              delegate: NavigationDelegate(
                language: widget.language,
                copy: copy,
                onLanguageChanged: widget.onLanguageChanged,
                onNavigate: _navigate,
              ),
            ),
            SliverToBoxAdapter(key: _homeKey, child: _hero()),
            SliverToBoxAdapter(key: _brandsKey, child: _brands()),
            SliverToBoxAdapter(key: _productsKey, child: _products()),
            SliverToBoxAdapter(key: _manufacturingKey, child: _manufacturing()),
            SliverToBoxAdapter(key: _privateLabelKey, child: _privateLabel()),
            SliverToBoxAdapter(key: _exportKey, child: _export()),
            SliverToBoxAdapter(child: _certifications()),
            SliverToBoxAdapter(key: _contactKey, child: _contact()),
            SliverToBoxAdapter(
              child: EmanFooter(copy: copy, onNavigate: _navigate),
            ),
          ],
        ),
      ),
    );
  }

  void _navigate(String destination) {
    final key = switch (destination) {
      'home' => _homeKey,
      'brands' => _brandsKey,
      'products' => _productsKey,
      'manufacturing' => _manufacturingKey,
      'privateLabel' => _privateLabelKey,
      'export' => _exportKey,
      _ => _contactKey,
    };
    _scrollTo(key);
  }

  Widget _topBar() {
    return Container(
      color: EmanTheme.navy,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 9),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  copy.text('topMessage'),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: .3,
                  ),
                ),
              ),
              const Icon(Icons.language, size: 14, color: Colors.white54),
              const SizedBox(width: 7),
              Text(
                copy.text('globalMarkets'),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _hero() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 92),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 940;
              final copyBlock = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EmanEyebrow(copy.text('heroEyebrow')),
                  const SizedBox(height: 24),
                  Text(
                    copy.text('heroTitle'),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: compact ? 48 : 72,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Text(
                      copy.text('heroBody'),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 34),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton(
                        onPressed: () => _scrollTo(_productsKey),
                        child: Text(copy.text('exploreProducts')),
                      ),
                      OutlinedButton(
                        onPressed: () => _scrollTo(_privateLabelKey),
                        child: Text(copy.text('privateLabel')),
                      ),
                    ],
                  ),
                  const SizedBox(height: 42),
                  Wrap(
                    spacing: 30,
                    runSpacing: 12,
                    children: [
                      ProofPoint(
                        icon: Icons.verified_outlined,
                        text: copy.text('qualityAssured'),
                      ),
                      ProofPoint(
                        icon: Icons.public,
                        text: copy.text('exportReady'),
                      ),
                    ],
                  ),
                ],
              );
              const visual = MediaPlaceholder(
                icon: Icons.local_drink_outlined,
                translationKey: 'heroMedia',
                aspectRatio: .9,
                dark: true,
              );
              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    copyBlock,
                    const SizedBox(height: 50),
                    SizedBox(height: 540, child: visual),
                  ],
                );
              }
              return SizedBox(
                height: 650,
                child: Row(
                  children: [
                    Expanded(flex: 9, child: copyBlock),
                    const SizedBox(width: 70),
                    const Expanded(flex: 8, child: visual),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _brands() {
    const brands = ['VALORE', 'FRIO CUPS', 'ROYA C', 'FULL FRESH'];
    return SectionContainer(
      color: EmanTheme.mist,
      child: Column(
        children: [
          EmanEyebrow(copy.text('brandsEyebrow'), centered: true),
          const SizedBox(height: 18),
          Text(
            copy.text('brandsTitle'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 18),
          Text(
            copy.text('brandsBody'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 56),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 900
                  ? 4
                  : constraints.maxWidth >= 520
                  ? 2
                  : 1;
              final width =
                  (constraints.maxWidth - (columns - 1) * 18) / columns;
              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: brands
                    .map(
                      (brand) => SizedBox(
                        width: width,
                        child: BrandTile(name: brand, copy: copy),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _products() {
    final products = [
      ProductInfo(
        category: copy.text('retailRange'),
        title: copy.text('productCitrus'),
        detail: copy.text('productCitrusDetail'),
      ),
      ProductInfo(
        category: copy.text('singleServe'),
        title: copy.text('productTropical'),
        detail: copy.text('productTropicalDetail'),
      ),
      ProductInfo(
        category: copy.text('foodService'),
        title: copy.text('productProfessional'),
        detail: copy.text('productProfessionalDetail'),
      ),
    ];
    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeading(
            eyebrow: copy.text('productsEyebrow'),
            title: copy.text('productsTitle'),
            body: copy.text('productsBody'),
          ),
          const SizedBox(height: 58),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 960 ? 3 : 1;
              final width =
                  (constraints.maxWidth - (columns - 1) * 22) / columns;
              return Wrap(
                spacing: 22,
                runSpacing: 24,
                children: products
                    .map(
                      (product) => SizedBox(
                        width: width,
                        child: ProductCard(product: product, copy: copy),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _manufacturing() {
    return Container(
      color: EmanTheme.navy,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 110),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 900;
              final media = const MediaPlaceholder(
                icon: Icons.precision_manufacturing_outlined,
                translationKey: 'factoryMedia',
                aspectRatio: 1.25,
              );
              final content = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EmanEyebrow(copy.text('manufacturingEyebrow'), light: true),
                  const SizedBox(height: 22),
                  Text(
                    copy.text('manufacturingTitle'),
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontSize: compact ? 40 : 52,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    copy.text('manufacturingBody'),
                    style: const TextStyle(
                      color: Color(0xFFB9C6CF),
                      fontSize: 17,
                      height: 1.65,
                    ),
                  ),
                  const SizedBox(height: 36),
                  FeatureList(
                    items: [
                      copy.text('productionLines'),
                      copy.text('qualityControl'),
                      copy.text('traceability'),
                      copy.text('modernTechnology'),
                    ],
                  ),
                ],
              );
              if (compact) {
                return Column(
                  children: [media, const SizedBox(height: 46), content],
                );
              }
              return Row(
                children: [
                  Expanded(flex: 11, child: media),
                  const SizedBox(width: 70),
                  Expanded(flex: 9, child: content),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _privateLabel() {
    final services = [
      ServiceInfo('OEM', copy.text('oemBody'), Icons.factory_outlined),
      ServiceInfo(
        copy.text('privateLabel'),
        copy.text('privateLabelBody'),
        Icons.sell_outlined,
      ),
      ServiceInfo(
        copy.text('customFormulation'),
        copy.text('customFormulationBody'),
        Icons.science_outlined,
      ),
      ServiceInfo(
        copy.text('packagingSolutions'),
        copy.text('packagingSolutionsBody'),
        Icons.inventory_2_outlined,
      ),
    ];
    return SectionContainer(
      color: EmanTheme.paleBlue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeading(
            eyebrow: copy.text('privateEyebrow'),
            title: copy.text('privateTitle'),
            body: copy.text('privateBody'),
          ),
          const SizedBox(height: 56),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 900 ? 4 : 1;
              final width =
                  (constraints.maxWidth - (columns - 1) * 16) / columns;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: services
                    .map(
                      (service) => SizedBox(
                        width: width,
                        child: ServiceTile(info: service),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 40),
          FilledButton.icon(
            onPressed: () => _scrollTo(_contactKey),
            icon: const Icon(Icons.arrow_outward),
            label: Text(copy.text('discussProject')),
          ),
        ],
      ),
    );
  }

  Widget _export() {
    return SectionContainer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 900;
          final content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EmanEyebrow(copy.text('exportEyebrow')),
              const SizedBox(height: 22),
              Text(
                copy.text('exportTitle'),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 20),
              Text(
                copy.text('exportBody'),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 38),
              Wrap(
                spacing: 34,
                runSpacing: 24,
                children: [
                  ExportStat(value: '20+', label: copy.text('markets')),
                  ExportStat(value: '4', label: copy.text('brands')),
                  ExportStat(value: '30+', label: copy.text('flavors')),
                ],
              ),
            ],
          );
          final map = WorldMapPlaceholder(copy: copy);
          if (compact) {
            return Column(children: [content, const SizedBox(height: 46), map]);
          }
          return Row(
            children: [
              Expanded(flex: 8, child: content),
              const SizedBox(width: 70),
              Expanded(flex: 10, child: map),
            ],
          );
        },
      ),
    );
  }

  Widget _certifications() {
    const icons = [
      Icons.verified_user_outlined,
      Icons.health_and_safety_outlined,
      Icons.eco_outlined,
      Icons.policy_outlined,
    ];
    return SectionContainer(
      color: EmanTheme.mist,
      child: Column(
        children: [
          EmanEyebrow(copy.text('certificationsEyebrow'), centered: true),
          const SizedBox(height: 18),
          Text(
            copy.text('certificationsTitle'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 18),
          Text(
            copy.text('certificationsBody'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 52),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 800
                  ? 4
                  : constraints.maxWidth >= 460
                  ? 2
                  : 1;
              final width =
                  (constraints.maxWidth - (columns - 1) * 16) / columns;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(
                  icons.length,
                  (index) => SizedBox(
                    width: width,
                    child: CertificatePlaceholder(
                      icon: icons[index],
                      copy: copy,
                      index: index + 1,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _contact() {
    return SectionContainer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 920;
          final details = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EmanEyebrow(copy.text('contactEyebrow')),
              const SizedBox(height: 22),
              Text(
                copy.text('contactTitle'),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 20),
              Text(
                copy.text('contactBody'),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 36),
              ContactLine(
                icon: Icons.chat_outlined,
                label: 'WhatsApp',
                value: copy.text('contactPending'),
              ),
              ContactLine(
                icon: Icons.email_outlined,
                label: copy.text('email'),
                value: copy.text('contactPending'),
              ),
              ContactLine(
                icon: Icons.location_on_outlined,
                label: copy.text('address'),
                value: copy.text('contactPending'),
              ),
            ],
          );
          final form = InquiryForm(copy: copy);
          if (compact) {
            return Column(
              children: [details, const SizedBox(height: 50), form],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 8, child: details),
              const SizedBox(width: 80),
              Expanded(flex: 10, child: form),
            ],
          );
        },
      ),
    );
  }
}

class NavigationDelegate extends SliverPersistentHeaderDelegate {
  NavigationDelegate({
    required this.language,
    required this.copy,
    required this.onLanguageChanged,
    required this.onNavigate,
  });

  final String language;
  final EmanLocalization copy;
  final ValueChanged<String> onLanguageChanged;
  final ValueChanged<String> onNavigate;

  @override
  double get minExtent => 82;

  @override
  double get maxExtent => 82;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: Colors.white,
      elevation: overlapsContent ? 3 : 0,
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1320),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 980;
                return Row(
                  children: [
                    const TextLogo(),
                    const Spacer(),
                    if (!compact) ...[
                      NavButton(
                        label: copy.text('products'),
                        onPressed: () => onNavigate('products'),
                      ),
                      NavButton(
                        label: copy.text('manufacturing'),
                        onPressed: () => onNavigate('manufacturing'),
                      ),
                      NavButton(
                        label: copy.text('privateLabel'),
                        onPressed: () => onNavigate('privateLabel'),
                      ),
                      NavButton(
                        label: copy.text('export'),
                        onPressed: () => onNavigate('export'),
                      ),
                      NavButton(
                        label: copy.text('contact'),
                        onPressed: () => onNavigate('contact'),
                      ),
                      const SizedBox(width: 12),
                    ],
                    LanguageSelector(
                      language: language,
                      onChanged: onLanguageChanged,
                    ),
                    if (compact) ...[
                      const SizedBox(width: 8),
                      PopupMenuButton<String>(
                        tooltip: copy.text('menu'),
                        onSelected: onNavigate,
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            value: 'products',
                            child: Text(copy.text('products')),
                          ),
                          PopupMenuItem(
                            value: 'manufacturing',
                            child: Text(copy.text('manufacturing')),
                          ),
                          PopupMenuItem(
                            value: 'privateLabel',
                            child: Text(copy.text('privateLabel')),
                          ),
                          PopupMenuItem(
                            value: 'export',
                            child: Text(copy.text('export')),
                          ),
                          PopupMenuItem(
                            value: 'contact',
                            child: Text(copy.text('contact')),
                          ),
                        ],
                        icon: const Icon(Icons.menu, color: EmanTheme.navy),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant NavigationDelegate oldDelegate) {
    return language != oldDelegate.language;
  }
}

class TextLogo extends StatelessWidget {
  const TextLogo({super.key, this.light = false});

  final bool light;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'EMAN',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 5, height: 34, color: EmanTheme.blue),
          const SizedBox(width: 11),
          Text(
            'EMAN',
            style: TextStyle(
              color: light ? Colors.white : EmanTheme.navy,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.2,
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    super.key,
    required this.language,
    required this.onChanged,
  });

  final String language;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsetsDirectional.only(start: 12, end: 7),
      decoration: BoxDecoration(
        border: Border.all(color: EmanTheme.line),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: language,
          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
          items: EmanLocalization.languageNames.entries
              .map(
                (entry) => DropdownMenuItem(
                  value: entry.key,
                  child: Text(
                    entry.value,
                    style: const TextStyle(
                      color: EmanTheme.navy,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ),
    );
  }
}

class NavButton extends StatelessWidget {
  const NavButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      ),
      child: Text(label),
    );
  }
}

class SectionContainer extends StatelessWidget {
  const SectionContainer({super.key, required this.child, this.color});

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 110),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: child,
        ),
      ),
    );
  }
}

class EmanEyebrow extends StatelessWidget {
  const EmanEyebrow(
    this.text, {
    super.key,
    this.light = false,
    this.centered = false,
  });

  final String text;
  final bool light;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: centered ? MainAxisSize.min : MainAxisSize.max,
      mainAxisAlignment: centered
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 2,
          color: light ? Colors.white : EmanTheme.blue,
        ),
        const SizedBox(width: 11),
        Flexible(
          child: Text(
            text.toUpperCase(),
            style: TextStyle(
              color: light ? Colors.white : EmanTheme.blue,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.55,
            ),
          ),
        ),
      ],
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.body,
  });

  final String eyebrow;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 830;
        final titleBlock = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EmanEyebrow(eyebrow),
            const SizedBox(height: 20),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(fontSize: compact ? 40 : 50),
            ),
          ],
        );
        final description = Text(
          body,
          style: Theme.of(context).textTheme.bodyLarge,
        );
        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [titleBlock, const SizedBox(height: 24), description],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(flex: 7, child: titleBlock),
            const SizedBox(width: 80),
            Expanded(flex: 4, child: description),
          ],
        );
      },
    );
  }
}

class MediaPlaceholder extends StatelessWidget {
  const MediaPlaceholder({
    super.key,
    required this.icon,
    required this.translationKey,
    required this.aspectRatio,
    this.dark = false,
  });

  final IconData icon;
  final String translationKey;
  final double aspectRatio;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final copy = EmanLocalization(locale);
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: dark ? EmanTheme.navy : const Color(0xFF143B5A),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: MediaPatternPainter())),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: Colors.white70, size: 64),
                    const SizedBox(height: 22),
                    Text(
                      copy.text(translationKey),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      copy.text('replaceableMedia'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                        letterSpacing: .5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MediaPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: .055)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var i = 1; i < 7; i++) {
      canvas.drawCircle(
        Offset(size.width * .78, size.height * .22),
        size.shortestSide * i * .1,
        paint,
      );
    }
    canvas.drawLine(Offset.zero, Offset(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ProofPoint extends StatelessWidget {
  const ProofPoint({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: EmanTheme.blue),
        const SizedBox(width: 9),
        Text(
          text,
          style: const TextStyle(
            color: EmanTheme.navy,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class BrandTile extends StatelessWidget {
  const BrandTile({super.key, required this.name, required this.copy});

  final String name;
  final EmanLocalization copy;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: EmanTheme.line),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: EmanTheme.navy,
              fontSize: 21,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            copy.text('logoPlaceholder'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: EmanTheme.muted,
              fontSize: 10,
              letterSpacing: .4,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductInfo {
  const ProductInfo({
    required this.category,
    required this.title,
    required this.detail,
  });

  final String category;
  final String title;
  final String detail;
}

class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.product, required this.copy});

  final ProductInfo product;
  final EmanLocalization copy;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        transform: Matrix4.translationValues(0, _hovered ? -8 : 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: EmanTheme.line),
          boxShadow: [
            BoxShadow(
              color: EmanTheme.navy.withValues(alpha: _hovered ? .13 : .05),
              blurRadius: _hovered ? 32 : 14,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.05,
              child: Container(
                color: EmanTheme.mist,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.local_drink_outlined,
                      size: 76,
                      color: Color(0xFFB6C7D2),
                    ),
                    Positioned(
                      bottom: 20,
                      child: Text(
                        widget.copy.text('productImagePlaceholder'),
                        style: const TextStyle(
                          color: EmanTheme.muted,
                          fontSize: 10,
                          letterSpacing: .5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.category.toUpperCase(),
                    style: const TextStyle(
                      color: EmanTheme.blue,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.product.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.product.detail,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureList extends StatelessWidget {
  const FeatureList({super.key, required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 28,
      runSpacing: 18,
      children: items
          .map(
            (item) => SizedBox(
              width: 210,
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF74C9EE),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class ServiceInfo {
  const ServiceInfo(this.title, this.body, this.icon);

  final String title;
  final String body;
  final IconData icon;
}

class ServiceTile extends StatelessWidget {
  const ServiceTile({super.key, required this.info});

  final ServiceInfo info;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      padding: const EdgeInsets.all(26),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(info.icon, size: 34, color: EmanTheme.blue),
          const Spacer(),
          Text(info.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Text(info.body, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class WorldMapPlaceholder extends StatelessWidget {
  const WorldMapPlaceholder({super.key, required this.copy});

  final EmanLocalization copy;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: Container(
        color: EmanTheme.paleBlue,
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: MapGridPainter())),
            const MapPoint(alignment: Alignment(-.52, -.25)),
            const MapPoint(alignment: Alignment(.03, -.02)),
            const MapPoint(alignment: Alignment(.5, .25)),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.public, size: 64, color: EmanTheme.blue),
                  const SizedBox(height: 14),
                  Text(
                    copy.text('mapPlaceholder'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: EmanTheme.navy,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = EmanTheme.blue.withValues(alpha: .12)
      ..strokeWidth = 1;
    const gap = 24.0;
    for (double x = 0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MapPoint extends StatelessWidget {
  const MapPoint({super.key, required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: EmanTheme.blue,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
      ),
    );
  }
}

class ExportStat extends StatelessWidget {
  const ExportStat({super.key, required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: EmanTheme.navy,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class CertificatePlaceholder extends StatelessWidget {
  const CertificatePlaceholder({
    super.key,
    required this.icon,
    required this.copy,
    required this.index,
  });

  final IconData icon;
  final EmanLocalization copy;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      padding: const EdgeInsets.all(25),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 42, color: EmanTheme.blue),
          const SizedBox(height: 18),
          Text(
            '${copy.text('certificate')} $index',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            copy.text('certificatePlaceholder'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class ContactLine extends StatelessWidget {
  const ContactLine({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            color: EmanTheme.paleBlue,
            child: Icon(icon, color: EmanTheme.blue, size: 21),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: EmanTheme.navy,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }
}

class InquiryForm extends StatefulWidget {
  const InquiryForm({super.key, required this.copy});

  final EmanLocalization copy;

  @override
  State<InquiryForm> createState() => _InquiryFormState();
}

class _InquiryFormState extends State<InquiryForm> {
  final _formKey = GlobalKey<FormState>();
  bool _submitted = false;

  EmanLocalization get copy => widget.copy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.sizeOf(context).width < 500 ? 24 : 36),
      color: EmanTheme.mist,
      child: _submitted
          ? _success()
          : Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _field(copy.text('name'), Icons.person_outline),
                  const SizedBox(height: 14),
                  _field(copy.text('company'), Icons.business_outlined),
                  const SizedBox(height: 14),
                  _field(
                    copy.text('workEmail'),
                    Icons.email_outlined,
                    email: true,
                  ),
                  const SizedBox(height: 14),
                  _field(copy.text('country'), Icons.public),
                  const SizedBox(height: 14),
                  TextFormField(
                    maxLines: 4,
                    decoration: _decoration(
                      copy.text('message'),
                      Icons.notes_outlined,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _submit,
                    child: Text(copy.text('sendInquiry')),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _field(String label, IconData icon, {bool email = false}) {
    return TextFormField(
      keyboardType: email ? TextInputType.emailAddress : TextInputType.text,
      decoration: _decoration(label, icon),
      validator: (value) {
        final input = value?.trim() ?? '';
        if (input.isEmpty) return copy.text('requiredField');
        if (email && (!input.contains('@') || !input.contains('.'))) {
          return copy.text('validEmail');
        }
        return null;
      },
    );
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: EmanTheme.line),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: EmanTheme.line),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitted = true);
  }

  Widget _success() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: EmanTheme.blue,
            size: 62,
          ),
          const SizedBox(height: 20),
          Text(
            copy.text('thankYou'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            copy.text('thankYouBody'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class EmanFooter extends StatelessWidget {
  const EmanFooter({super.key, required this.copy, required this.onNavigate});

  final EmanLocalization copy;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: EmanTheme.navy,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 760;
              final brand = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextLogo(light: true),
                  const SizedBox(height: 18),
                  Text(
                    copy.text('footerText'),
                    style: const TextStyle(
                      color: Color(0xFFABBAC5),
                      height: 1.6,
                    ),
                  ),
                ],
              );
              final links = Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _footerLink(copy.text('products'), 'products'),
                  _footerLink(copy.text('manufacturing'), 'manufacturing'),
                  _footerLink(copy.text('privateLabel'), 'privateLabel'),
                  _footerLink(copy.text('export'), 'export'),
                  _footerLink(copy.text('contact'), 'contact'),
                ],
              );
              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    brand,
                    const SizedBox(height: 36),
                    links,
                    const SizedBox(height: 36),
                    _copyright(),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: brand),
                  Expanded(child: links),
                  _copyright(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _footerLink(String label, String destination) {
    return TextButton(
      onPressed: () => onNavigate(destination),
      style: TextButton.styleFrom(foregroundColor: Colors.white70),
      child: Text(label),
    );
  }

  Widget _copyright() {
    return Text(
      '© 2026 EMAN · ${copy.text('rightsReserved')}',
      style: const TextStyle(color: Colors.white38, fontSize: 11),
    );
  }
}
