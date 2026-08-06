import 'package:flutter/material.dart';

class EmanExperienceApp extends StatelessWidget {
  const EmanExperienceApp({super.key});

  static const ink = Color(0xFF071A2D);
  static const blue = Color(0xFF146CFF);
  static const cyan = Color(0xFF4ED6C8);
  static const canvas = Color(0xFFF3F6F8);
  static const muted = Color(0xFF5D6A76);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eman — Beverage Manufacturing Partner',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: canvas,
        colorScheme: ColorScheme.fromSeed(
          seedColor: blue,
          primary: blue,
          surface: Colors.white,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: ink,
            fontSize: 72,
            height: .98,
            fontWeight: FontWeight.w800,
            letterSpacing: -3.2,
          ),
          displayMedium: TextStyle(
            color: ink,
            fontSize: 48,
            height: 1.02,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.8,
          ),
          headlineMedium: TextStyle(
            color: ink,
            fontSize: 26,
            height: 1.15,
            fontWeight: FontWeight.w700,
            letterSpacing: -.6,
          ),
          bodyLarge: TextStyle(color: muted, fontSize: 18, height: 1.65),
          bodyMedium: TextStyle(color: muted, fontSize: 15, height: 1.55),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: const BorderSide(color: Color(0xFFD4DCE3)),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _capabilitiesKey = GlobalKey();
  final _portfolioKey = GlobalKey();
  final _processKey = GlobalKey();
  final _partnershipKey = GlobalKey();

  void _scrollTo(GlobalKey key) {
    final target = key.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      alignment: .04,
    );
  }

  void _openInquiry([String interest = 'General partnership']) {
    showDialog<void>(
      context: context,
      barrierColor: EmanExperienceApp.ink.withValues(alpha: .72),
      builder: (_) => InquiryDialog(initialInterest: interest),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SelectionArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _announcement()),
            SliverToBoxAdapter(child: _navigation()),
            SliverToBoxAdapter(child: _hero()),
            SliverToBoxAdapter(child: _trustStrip()),
            SliverToBoxAdapter(key: _capabilitiesKey, child: _capabilities()),
            SliverToBoxAdapter(key: _portfolioKey, child: _portfolio()),
            SliverToBoxAdapter(child: _marketReach()),
            SliverToBoxAdapter(key: _processKey, child: _process()),
            SliverToBoxAdapter(key: _partnershipKey, child: _partnership()),
            const SliverToBoxAdapter(child: SiteFooter()),
          ],
        ),
      ),
    );
  }

  Widget _announcement() {
    return Container(
      color: EmanExperienceApp.ink,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: const Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        children: [
          Icon(Icons.public, color: EmanExperienceApp.cyan, size: 16),
          Text(
            'Now onboarding distribution and private-label partners for 2026',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: .2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _navigation() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: SizedBox(
            height: 82,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 860;
                return Row(
                  children: [
                    const EmanMark(dark: true),
                    const Spacer(),
                    if (!compact) ...[
                      _navLink(
                        'Capabilities',
                        () => _scrollTo(_capabilitiesKey),
                      ),
                      _navLink('Portfolio', () => _scrollTo(_portfolioKey)),
                      _navLink('How we work', () => _scrollTo(_processKey)),
                      _navLink('Company', () => _scrollTo(_partnershipKey)),
                      const SizedBox(width: 18),
                    ],
                    FilledButton(
                      onPressed: _openInquiry,
                      child: Text(compact ? 'Get in touch' : 'Start a project'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _navLink(String label, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: EmanExperienceApp.ink,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
      child: Text(label),
    );
  }

  Widget _hero() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 50, 24, 86),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 900;
              final copy = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Eyebrow('BEVERAGE INNOVATION · BUILT TO SCALE'),
                  const SizedBox(height: 26),
                  Text(
                    'From bold idea\nto global shelf.',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: compact ? 52 : 76,
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text(
                    'Eman develops, manufactures and exports high-performing '
                    'powdered beverages for ambitious brands and distributors.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton.icon(
                        onPressed: _openInquiry,
                        icon: const Icon(Icons.arrow_outward, size: 19),
                        label: const Text('Build your product'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _scrollTo(_portfolioKey),
                        icon: const Icon(Icons.grid_view_rounded, size: 18),
                        label: const Text('Explore portfolio'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Wrap(
                    spacing: 26,
                    runSpacing: 12,
                    children: [
                      MiniProof(
                        icon: Icons.verified_user_outlined,
                        label: 'Quality-led production',
                      ),
                      MiniProof(
                        icon: Icons.language,
                        label: 'Export-ready operations',
                      ),
                    ],
                  ),
                ],
              );
              final visual = const ProductStage();
              if (compact) {
                return Column(
                  children: [
                    copy,
                    const SizedBox(height: 58),
                    const SizedBox(height: 540, child: ProductStage()),
                  ],
                );
              }
              return SizedBox(
                height: 650,
                child: Row(
                  children: [
                    Expanded(flex: 10, child: copy),
                    const SizedBox(width: 64),
                    Expanded(flex: 9, child: visual),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _trustStrip() {
    return Container(
      color: EmanExperienceApp.ink,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: const Wrap(
            alignment: WrapAlignment.spaceBetween,
            runAlignment: WrapAlignment.center,
            spacing: 44,
            runSpacing: 26,
            children: [
              TrustItem(value: '20+', label: 'Markets served'),
              TrustItem(value: '4', label: 'Portfolio brands'),
              TrustItem(value: '30+', label: 'Flavor concepts'),
              TrustItem(value: 'B2B', label: 'Partner-first model'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _capabilities() {
    const cards = [
      CapabilityData(
        number: '01',
        icon: Icons.science_outlined,
        title: 'Product development',
        text:
            'Build differentiated flavor profiles, formats and specifications '
            'around your consumer and commercial goals.',
      ),
      CapabilityData(
        number: '02',
        icon: Icons.precision_manufacturing_outlined,
        title: 'Scaled manufacturing',
        text:
            'Move from validated concept to consistent production with a '
            'quality-led manufacturing partner.',
      ),
      CapabilityData(
        number: '03',
        icon: Icons.inventory_2_outlined,
        title: 'Private label',
        text:
            'Create a complete branded proposition with packaging, portfolio '
            'architecture and go-to-market support.',
      ),
      CapabilityData(
        number: '04',
        icon: Icons.local_shipping_outlined,
        title: 'Export enablement',
        text:
            'Prepare products and documentation for efficient international '
            'distribution and market entry.',
      ),
    ];
    return SectionShell(
      dark: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionIntro(
            eyebrow: 'WHAT WE DO',
            title: 'One partner from concept\nto commercialization.',
            text:
                'A connected operating model reduces handoffs, protects quality '
                'and gets your beverage proposition to market with confidence.',
          ),
          const SizedBox(height: 52),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1040
                  ? 4
                  : constraints.maxWidth >= 620
                  ? 2
                  : 1;
              final width =
                  (constraints.maxWidth - (columns - 1) * 18) / columns;
              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: cards
                    .map(
                      (card) => SizedBox(
                        width: width,
                        child: CapabilityCard(
                          data: card,
                          onPressed: () => _openInquiry(card.title),
                        ),
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

  Widget _portfolio() {
    const products = [
      PortfolioData(
        brand: 'VALORE',
        format: 'Instant drink sachets',
        flavor: 'Citrus collection',
        color: Color(0xFFFFC84B),
        accent: Color(0xFFFF7A45),
        icon: Icons.wb_sunny_outlined,
      ),
      PortfolioData(
        brand: 'FRIO CUPS',
        format: 'Single-serve refreshment',
        flavor: 'Tropical collection',
        color: Color(0xFF43D4C4),
        accent: Color(0xFF087F8C),
        icon: Icons.local_drink_outlined,
      ),
      PortfolioData(
        brand: 'ROYA C',
        format: 'Foodservice solutions',
        flavor: 'Professional range',
        color: Color(0xFF8BA7FF),
        accent: Color(0xFF3049B5),
        icon: Icons.restaurant_outlined,
      ),
      PortfolioData(
        brand: 'FULL FRESH',
        format: 'Flavored powder drinks',
        flavor: 'Family collection',
        color: Color(0xFFFF849E),
        accent: Color(0xFFA92058),
        icon: Icons.favorite_outline,
      ),
    ];
    return SectionShell(
      background: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Expanded(
                child: SectionIntro(
                  eyebrow: 'OUR PORTFOLIO',
                  title: 'Formats built for\nreal-world demand.',
                  text:
                      'A flexible product platform for retail, foodservice and '
                      'distribution channels.',
                ),
              ),
              if (MediaQuery.sizeOf(context).width > 760)
                TextButton.icon(
                  onPressed: () => _openInquiry('Portfolio and distribution'),
                  iconAlignment: IconAlignment.end,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Discuss distribution'),
                ),
            ],
          ),
          const SizedBox(height: 52),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 950 ? 2 : 1;
              final width =
                  (constraints.maxWidth - (columns - 1) * 20) / columns;
              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: products
                    .map(
                      (product) => SizedBox(
                        width: width,
                        child: PortfolioCard(
                          data: product,
                          onPressed: () =>
                              _openInquiry('${product.brand} distribution'),
                        ),
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

  Widget _marketReach() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 110),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Container(
            decoration: BoxDecoration(
              color: EmanExperienceApp.ink,
              borderRadius: BorderRadius.circular(28),
            ),
            clipBehavior: Clip.antiAlias,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 800;
                final copy = Padding(
                  padding: EdgeInsets.all(compact ? 34 : 62),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Eyebrow('BUILT FOR INTERNATIONAL BUSINESS'),
                      const SizedBox(height: 22),
                      Text(
                        'Local insight.\nGlobal ambition.',
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontSize: compact ? 40 : 54,
                            ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'We help partners translate regional taste, channel and '
                        'price-point needs into scalable beverage propositions.',
                        style: TextStyle(
                          color: Color(0xFFB7C2CC),
                          fontSize: 17,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                );
                const map = MarketGraphic();
                return compact
                    ? Column(
                        children: [
                          copy,
                          const SizedBox(height: 350, child: map),
                        ],
                      )
                    : SizedBox(
                        height: 490,
                        child: Row(
                          children: [
                            Expanded(child: copy),
                            const Expanded(child: map),
                          ],
                        ),
                      );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _process() {
    const steps = [
      ProcessData(
        '01',
        'Align',
        'We define the market, consumer, channel and commercial brief.',
      ),
      ProcessData(
        '02',
        'Create',
        'Our team shapes the formulation, format and brand proposition.',
      ),
      ProcessData(
        '03',
        'Validate',
        'Samples, specifications and production requirements are confirmed.',
      ),
      ProcessData(
        '04',
        'Scale',
        'Manufacturing and export coordination move the product to market.',
      ),
    ];
    return SectionShell(
      dark: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionIntro(
            eyebrow: 'HOW WE WORK',
            title: 'Clarity at every stage.',
            text:
                'A pragmatic development path designed for faster decisions and '
                'stronger commercial outcomes.',
          ),
          const SizedBox(height: 56),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 920 ? 4 : 1;
              final width =
                  (constraints.maxWidth - (columns - 1) * 36) / columns;
              return Wrap(
                spacing: 36,
                runSpacing: 32,
                children: steps
                    .map(
                      (step) => SizedBox(
                        width: width,
                        child: ProcessStep(data: step),
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

  Widget _partnership() {
    return Container(
      color: EmanExperienceApp.blue,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 110),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              const Eyebrow('LET’S BUILD WHAT’S NEXT', light: true),
              const SizedBox(height: 28),
              Text(
                'A better beverage business\nstarts with the right partner.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontSize: MediaQuery.sizeOf(context).width < 620 ? 40 : 58,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Tell us where you want to compete. We’ll show you how to get there.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFDDE9FF),
                  fontSize: 18,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 36),
              FilledButton.icon(
                onPressed: _openInquiry,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: EmanExperienceApp.ink,
                ),
                icon: const Icon(Icons.arrow_outward),
                label: const Text('Start the conversation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductStage extends StatelessWidget {
  const ProductStage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE6F0F4), Color(0xFFDAF0ED)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -100,
            top: -80,
            child: Container(
              width: 310,
              height: 310,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white54, width: 54),
              ),
            ),
          ),
          Positioned(
            left: 28,
            top: 28,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Text(
                'POWDERED BEVERAGE PLATFORM',
                style: TextStyle(
                  color: EmanExperienceApp.ink,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          const Align(alignment: Alignment(0, .15), child: ProductPack()),
          const Positioned(
            right: 28,
            bottom: 28,
            child: StatTile(value: '30+', label: 'flavor concepts'),
          ),
          const Positioned(
            left: 28,
            bottom: 28,
            child: StatTile(value: '4', label: 'flexible brands'),
          ),
        ],
      ),
    );
  }
}

class ProductPack extends StatelessWidget {
  const ProductPack({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -.06,
      child: Container(
        width: 248,
        height: 358,
        decoration: BoxDecoration(
          color: EmanExperienceApp.blue,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(28),
            bottomRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: EmanExperienceApp.ink.withValues(alpha: .24),
              blurRadius: 40,
              offset: const Offset(12, 24),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: -84,
              top: 76,
              child: Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: EmanExperienceApp.cyan,
                ),
              ),
            ),
            Positioned(
              right: -60,
              bottom: -50,
              child: Container(
                width: 180,
                height: 180,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFC84B),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EmanMark(),
                  Spacer(),
                  Text(
                    'CITRUS',
                    style: TextStyle(
                      color: EmanExperienceApp.ink,
                      fontSize: 38,
                      height: .9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.8,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'INSTANT POWDER DRINK',
                    style: TextStyle(
                      color: EmanExperienceApp.ink,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmanMark extends StatelessWidget {
  const EmanMark({super.key, this.dark = false});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final foreground = dark ? EmanExperienceApp.ink : Colors.white;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: dark ? EmanExperienceApp.blue : Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.water_drop_rounded,
            color: dark ? Colors.white : EmanExperienceApp.blue,
            size: 17,
          ),
        ),
        const SizedBox(width: 9),
        Text(
          'EMAN',
          style: TextStyle(
            color: foreground,
            fontSize: 19,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class MiniProof extends StatelessWidget {
  const MiniProof({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: EmanExperienceApp.blue, size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: EmanExperienceApp.ink,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class StatTile extends StatelessWidget {
  const StatTile({super.key, required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: EmanExperienceApp.ink,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: EmanExperienceApp.muted,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class TrustItem extends StatelessWidget {
  const TrustItem({super.key, required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      child: Row(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF9FADB9),
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionShell extends StatelessWidget {
  const SectionShell({
    super.key,
    required this.child,
    this.background,
    this.dark = false,
  });

  final Widget child;
  final Color? background;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          background ??
          (dark ? EmanExperienceApp.ink : EmanExperienceApp.canvas),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 110),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: child,
        ),
      ),
    );
  }
}

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.light = false});

  final String text;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 2,
          color: light ? Colors.white : EmanExperienceApp.blue,
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              color: light ? Colors.white : EmanExperienceApp.blue,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

class SectionIntro extends StatelessWidget {
  const SectionIntro({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.text,
  });

  final String eyebrow;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 820;
        final heading = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Eyebrow(eyebrow),
            const SizedBox(height: 20),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(fontSize: compact ? 39 : 50),
            ),
          ],
        );
        final detail = Text(text, style: Theme.of(context).textTheme.bodyLarge);
        return compact
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [heading, const SizedBox(height: 22), detail],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(flex: 3, child: heading),
                  const SizedBox(width: 80),
                  Expanded(flex: 2, child: detail),
                ],
              );
      },
    );
  }
}

class CapabilityData {
  const CapabilityData({
    required this.number,
    required this.icon,
    required this.title,
    required this.text,
  });

  final String number;
  final IconData icon;
  final String title;
  final String text;
}

class CapabilityCard extends StatefulWidget {
  const CapabilityCard({
    super.key,
    required this.data,
    required this.onPressed,
  });

  final CapabilityData data;
  final VoidCallback onPressed;

  @override
  State<CapabilityCard> createState() => _CapabilityCardState();
}

class _CapabilityCardState extends State<CapabilityCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _hovered ? -6 : 0, 0),
        height: 330,
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: _hovered ? EmanExperienceApp.ink : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFDDE3E8)),
          boxShadow: [
            if (_hovered)
              BoxShadow(
                color: EmanExperienceApp.ink.withValues(alpha: .18),
                blurRadius: 28,
                offset: const Offset(0, 15),
              ),
          ],
        ),
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _hovered
                          ? EmanExperienceApp.blue
                          : const Color(0xFFEAF1FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.data.icon,
                      color: _hovered ? Colors.white : EmanExperienceApp.blue,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.data.number,
                    style: TextStyle(
                      color: _hovered
                          ? Colors.white38
                          : const Color(0xFFADB7C0),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                widget.data.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: _hovered ? Colors.white : EmanExperienceApp.ink,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                widget.data.text,
                style: TextStyle(
                  color: _hovered
                      ? const Color(0xFFAFBCC7)
                      : EmanExperienceApp.muted,
                  fontSize: 14,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 18),
              Icon(
                Icons.arrow_forward,
                color: _hovered
                    ? EmanExperienceApp.cyan
                    : EmanExperienceApp.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PortfolioData {
  const PortfolioData({
    required this.brand,
    required this.format,
    required this.flavor,
    required this.color,
    required this.accent,
    required this.icon,
  });

  final String brand;
  final String format;
  final String flavor;
  final Color color;
  final Color accent;
  final IconData icon;
}

class PortfolioCard extends StatelessWidget {
  const PortfolioCard({super.key, required this.data, required this.onPressed});

  final PortfolioData data;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 390,
      decoration: BoxDecoration(
        color: data.color.withValues(alpha: .22),
        borderRadius: BorderRadius.circular(22),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -65,
            top: -75,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: data.color.withValues(alpha: .55),
              ),
            ),
          ),
          Positioned(
            right: 44,
            bottom: 24,
            child: Transform.rotate(
              angle: .08,
              child: Container(
                width: 150,
                height: 230,
                decoration: BoxDecoration(
                  color: data.accent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(22),
                    bottomRight: Radius.circular(22),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: data.accent.withValues(alpha: .28),
                      blurRadius: 28,
                      offset: const Offset(8, 14),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(data.icon, color: Colors.white, size: 52),
                    const SizedBox(height: 18),
                    Text(
                      data.brand,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .8),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      data.brand,
                      style: const TextStyle(
                        color: EmanExperienceApp.ink,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 240,
                    child: Text(
                      data.format,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(fontSize: 28),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data.flavor,
                    style: const TextStyle(
                      color: EmanExperienceApp.muted,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 18),
                  IconButton.filled(
                    onPressed: onPressed,
                    style: IconButton.styleFrom(
                      backgroundColor: EmanExperienceApp.ink,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.arrow_outward),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MarketGraphic extends StatelessWidget {
  const MarketGraphic({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: CustomPaint(painter: DotGridPainter())),
        const MarketPoint(alignment: Alignment(-.62, -.2), label: 'Europe'),
        const MarketPoint(alignment: Alignment(.16, -.08), label: 'MENA'),
        const MarketPoint(alignment: Alignment(.58, .38), label: 'Asia'),
        Align(
          alignment: const Alignment(-.08, .15),
          child: Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: EmanExperienceApp.blue.withValues(alpha: .18),
              shape: BoxShape.circle,
              border: Border.all(
                color: EmanExperienceApp.cyan.withValues(alpha: .65),
              ),
            ),
            child: const Center(child: EmanMark()),
          ),
        ),
      ],
    );
  }
}

class DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF294057);
    const gap = 18.0;
    for (double x = 9; x < size.width; x += gap) {
      for (double y = 9; y < size.height; y += gap) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MarketPoint extends StatelessWidget {
  const MarketPoint({super.key, required this.alignment, required this.label});

  final Alignment alignment;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 14)],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: EmanExperienceApp.cyan,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: const TextStyle(
                color: EmanExperienceApp.ink,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProcessData {
  const ProcessData(this.number, this.title, this.text);

  final String number;
  final String title;
  final String text;
}

class ProcessStep extends StatelessWidget {
  const ProcessStep({super.key, required this.data});

  final ProcessData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 3,
          decoration: BoxDecoration(
            color: data.number == '01'
                ? EmanExperienceApp.blue
                : const Color(0xFFD5DDE3),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          data.number,
          style: const TextStyle(
            color: EmanExperienceApp.blue,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        Text(data.title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        Text(data.text, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class InquiryDialog extends StatefulWidget {
  const InquiryDialog({super.key, required this.initialInterest});

  final String initialInterest;

  @override
  State<InquiryDialog> createState() => _InquiryDialogState();
}

class _InquiryDialogState extends State<InquiryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _company = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _name.dispose();
    _company.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitted = true);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 650),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: _submitted ? _success() : _form(),
        ),
      ),
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Start a conversation',
                    style: TextStyle(
                      color: EmanExperienceApp.ink,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Interest: ${widget.initialInterest}',
              style: const TextStyle(color: EmanExperienceApp.blue),
            ),
            const SizedBox(height: 26),
            _field(_name, 'Your name', Icons.person_outline),
            const SizedBox(height: 14),
            _field(_company, 'Company', Icons.business_outlined),
            const SizedBox(height: 14),
            _field(_email, 'Work email', Icons.mail_outline, email: true),
            const SizedBox(height: 14),
            TextFormField(
              controller: _message,
              maxLines: 4,
              decoration: _decoration(
                'Tell us about your market or project',
                Icons.notes_outlined,
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.arrow_outward),
                label: const Text('Send partnership brief'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool email = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: email ? TextInputType.emailAddress : TextInputType.text,
      decoration: _decoration(label, icon),
      validator: (value) {
        final input = value?.trim() ?? '';
        if (input.isEmpty) return 'Please complete this field';
        if (email && (!input.contains('@') || !input.contains('.'))) {
          return 'Enter a valid work email';
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
      fillColor: const Color(0xFFF4F7F9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _success() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: const BoxDecoration(
            color: Color(0xFFE5F8F4),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            color: Color(0xFF078F79),
            size: 36,
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'Brief received',
          style: TextStyle(
            color: EmanExperienceApp.ink,
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Thank you. Our partnership team will review your opportunity and '
          'follow up with the right next step.',
          textAlign: TextAlign.center,
          style: TextStyle(color: EmanExperienceApp.muted, height: 1.6),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Back to the website'),
        ),
      ],
    );
  }
}

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: EmanExperienceApp.ink,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 700;
              const brand = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EmanMark(),
                  SizedBox(height: 16),
                  Text(
                    'Beverage innovation, manufacturing\nand export partnerships.',
                    style: TextStyle(color: Color(0xFF9DABB7), height: 1.55),
                  ),
                ],
              );
              const legal = Text(
                '© 2026 Eman Experience  ·  B2B partnerships',
                style: TextStyle(color: Color(0xFF7C8D9B), fontSize: 12),
              );
              return compact
                  ? const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [brand, SizedBox(height: 36), legal],
                    )
                  : const Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [brand, Spacer(), legal],
                    );
            },
          ),
        ),
      ),
    );
  }
}
