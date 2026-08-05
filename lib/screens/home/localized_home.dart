import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/app_i18n.dart';

class LocalizedHome extends StatefulWidget {
  const LocalizedHome({super.key});

  @override
  State<LocalizedHome> createState() => _LocalizedHomeState();
}

class _LocalizedHomeState extends State<LocalizedHome>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _products = [
    'assets/products/friocups/9g-orange-flavored-powder-drink-friocups.png',
    'assets/products/friocups/9g-mango-flavored-powder-drink-friocups.png',
    'assets/products/friocups/9g-berries-flavored-powder-drink-friocups.png',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _hero(context),
          _metricsStrip(context),
          _capabilities(context),
          _productShowcase(context),
          _partnerBanner(context),
        ],
      ),
    );
  }

  Widget _hero(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 720),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF021C31), Color(0xFF073E62), Color(0xFF0C6FA8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) =>
                  CustomPaint(painter: _OrbitPainter(_controller.value)),
            ),
          ),
          Positioned(
            top: -100,
            right: -80,
            child: _GlowOrb(size: 360, color: const Color(0x5526BDF5)),
          ),
          Positioned(
            bottom: -140,
            left: -80,
            child: _GlowOrb(size: 420, color: const Color(0x44FFC857)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 64),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1320),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 930;
                    final copy = _HeroCopy(compact: compact);
                    final visual = _HeroVisual(
                      compact: compact,
                      controller: _controller,
                      products: _products,
                    );

                    if (compact) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [copy, const SizedBox(height: 46), visual],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(flex: 11, child: copy),
                        const SizedBox(width: 48),
                        Expanded(flex: 9, child: visual),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricsStrip(BuildContext context) {
    final metrics = [
      (
        context.t('home.badgeCountriesValue'),
        context.t('home.badgeCountriesLabel'),
        Icons.public,
      ),
      (
        context.t('home.badgePartnersValue'),
        context.t('home.badgePartnersLabel'),
        Icons.handshake_outlined,
      ),
      (
        '250+',
        context.t('home.cardWholesaleTitle'),
        Icons.inventory_2_outlined,
      ),
      ('24/7', context.t('home.cardFactoryTitle'), Icons.factory_outlined),
    ];

    return Transform.translate(
      offset: const Offset(0, -34),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 50,
                    offset: Offset(0, 18),
                    color: Color(0x1B052A45),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 900 ? 4 : 2;
                  final width =
                      (constraints.maxWidth - ((columns - 1) * 12)) / columns;
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: metrics
                        .map(
                          (item) => SizedBox(
                            width: width,
                            child: _MetricTile(
                              value: item.$1,
                              label: item.$2,
                              icon: item.$3,
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _capabilities(BuildContext context) {
    final items = [
      (
        Icons.storefront_outlined,
        'home.cardWholesaleTitle',
        'home.cardWholesaleText',
        const Color(0xFF0B7BC1),
      ),
      (
        Icons.groups_outlined,
        'home.cardPartnerTitle',
        'home.cardPartnerText',
        const Color(0xFF6D5CE7),
      ),
      (
        Icons.factory_outlined,
        'home.cardFactoryTitle',
        'home.cardFactoryText',
        const Color(0xFFEF7A31),
      ),
      (
        Icons.monitor_heart_outlined,
        'home.cardExecutiveTitle',
        'home.cardExecutiveText',
        const Color(0xFF15A277),
      ),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(28, 46, 28, 92),
      color: const Color(0xFFF4F8FB),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(
                eyebrow: context.t('app.platform'),
                title: context.t('home.capabilitiesTitle'),
                subtitle: context.t('home.capabilitiesSubtitle'),
              ),
              const SizedBox(height: 34),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 1080
                      ? 4
                      : constraints.maxWidth >= 650
                      ? 2
                      : 1;
                  final width =
                      (constraints.maxWidth - ((columns - 1) * 20)) / columns;
                  return Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: items
                        .map(
                          (item) => SizedBox(
                            width: width,
                            child: _CapabilityCard(
                              icon: item.$1,
                              title: context.t(item.$2),
                              text: context.t(item.$3),
                              accent: item.$4,
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _productShowcase(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 90),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 900;
              final copy = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    eyebrow: context.t('home.cardWholesaleTitle'),
                    title: context.t('home.exploreProducts'),
                    subtitle: context.t('home.cardWholesaleText'),
                  ),
                  const SizedBox(height: 26),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _Pill(
                        icon: Icons.verified_outlined,
                        text: context.t('home.proofFactory'),
                      ),
                      _Pill(
                        icon: Icons.public,
                        text: context.t('home.proofGlobal'),
                      ),
                      _Pill(
                        icon: Icons.payments_outlined,
                        text: context.t('home.proofCommission'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 18,
                      ),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(context.t('home.exploreProducts')),
                  ),
                ],
              );

              final products = Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF4F9FD), Color(0xFFEAF4FB)],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(_products.length, (index) {
                    return Flexible(
                      child: Transform.translate(
                        offset: Offset(0, index == 1 ? -28 : 0),
                        child: Container(
                          height: index == 1 ? 330 : 285,
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(
                            _products[index],
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.local_drink,
                              size: 80,
                              color: EmanExperienceApp.blue,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              );

              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [copy, const SizedBox(height: 40), products],
                );
              }

              return Row(
                children: [
                  Expanded(flex: 5, child: copy),
                  const SizedBox(width: 50),
                  Expanded(flex: 6, child: products),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _partnerBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 54),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Container(
            padding: const EdgeInsets.all(42),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(38),
              gradient: const LinearGradient(
                colors: [Color(0xFF04263F), Color(0xFF075888)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 48,
                  offset: Offset(0, 22),
                  color: Color(0x28052A45),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 760;
                final text = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        context.t('home.cardPartnerTitle').toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFFFFD477),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      context.t('home.partnerBannerTitle'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: compact ? 34 : 44,
                        height: 1.05,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      context.t('home.partnerBannerText'),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 17,
                        height: 1.6,
                      ),
                    ),
                  ],
                );
                final button = FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: EmanExperienceApp.gold,
                    foregroundColor: EmanExperienceApp.navy,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 18,
                    ),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(context.t('home.partnerBannerButton')),
                );

                if (compact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [text, const SizedBox(height: 26), button],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: text),
                    const SizedBox(width: 34),
                    button,
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .09),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withValues(alpha: .14)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.public, size: 18, color: Color(0xFFFFD477)),
              const SizedBox(width: 8),
              Text(
                context.t('home.eyebrow'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          context.t('home.heroTitle'),
          style: TextStyle(
            color: Colors.white,
            fontSize: compact ? 50 : 76,
            height: .98,
            letterSpacing: -2.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 26),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(
            context.t('home.heroSubtitle'),
            style: const TextStyle(
              color: Color(0xFFD2E6F2),
              fontSize: 18,
              height: 1.65,
            ),
          ),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: EmanExperienceApp.navy,
                padding: const EdgeInsets.symmetric(
                  horizontal: 23,
                  vertical: 18,
                ),
              ),
              onPressed: () {},
              icon: const Icon(Icons.inventory_2_outlined),
              label: Text(context.t('home.exploreProducts')),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: .42)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 23,
                  vertical: 18,
                ),
              ),
              onPressed: () {},
              icon: const Icon(Icons.person_add_alt_outlined),
              label: Text(context.t('home.becomePartner')),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 18,
          runSpacing: 12,
          children: [
            _HeroProof(icon: Icons.public, text: context.t('home.proofGlobal')),
            _HeroProof(
              icon: Icons.factory_outlined,
              text: context.t('home.proofFactory'),
            ),
            _HeroProof(
              icon: Icons.payments_outlined,
              text: context.t('home.proofCommission'),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroVisual extends StatelessWidget {
  const _HeroVisual({
    required this.compact,
    required this.controller,
    required this.products,
  });

  final bool compact;
  final AnimationController controller;
  final List<String> products;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: compact ? 500 : 610,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final wave = math.sin(controller.value * math.pi * 2);
          return Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: controller.value * math.pi * 2,
                child: Container(
                  width: compact ? 360 : 460,
                  height: compact ? 360 : 460,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: .13),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              Container(
                width: compact ? 310 : 390,
                height: compact ? 400 : 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(48),
                  color: Colors.white.withValues(alpha: .08),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: .17),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 60,
                      color: Color(0x33000000),
                      offset: Offset(0, 28),
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: Offset(0, wave * 12),
                child: Image.asset(
                  products.first,
                  height: compact ? 330 : 420,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const Icon(
                    Icons.local_drink,
                    size: 160,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: compact ? 24 : 40,
                right: 0,
                child: _FloatingGlassBadge(
                  icon: Icons.language,
                  value: context.t('home.badgeCountriesValue'),
                  label: context.t('home.badgeCountriesLabel'),
                ),
              ),
              Positioned(
                bottom: compact ? 36 : 54,
                left: 0,
                child: _FloatingGlassBadge(
                  icon: Icons.handshake_outlined,
                  value: context.t('home.badgePartnersValue'),
                  label: context.t('home.badgePartnersLabel'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HeroProof extends StatelessWidget {
  const _HeroProof({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 19, color: const Color(0xFFFFD477)),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _FloatingGlassBadge extends StatelessWidget {
  const _FloatingGlassBadge({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xE6FFFFFF),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            blurRadius: 28,
            offset: Offset(0, 12),
            color: Color(0x33000000),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFE5F5FF),
            child: Icon(icon, color: EmanExperienceApp.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: EmanExperienceApp.navy,
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF607482),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFE8F5FD),
            child: Icon(icon, color: EmanExperienceApp.blue),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: EmanExperienceApp.navy,
                  ),
                ),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF647985),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CapabilityCard extends StatefulWidget {
  const _CapabilityCard({
    required this.icon,
    required this.title,
    required this.text,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String text;
  final Color accent;

  @override
  State<_CapabilityCard> createState() => _CapabilityCardState();
}

class _CapabilityCardState extends State<_CapabilityCard> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        transform: Matrix4.translationValues(0, hovered ? -8 : 0, 0),
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: hovered
                ? widget.accent.withValues(alpha: .35)
                : const Color(0xFFE2EBF1),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: hovered ? 36 : 18,
              offset: Offset(0, hovered ? 18 : 8),
              color: hovered
                  ? widget.accent.withValues(alpha: .13)
                  : const Color(0x12052A45),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: widget.accent.withValues(alpha: .11),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Icon(widget.icon, color: widget.accent),
            ),
            const SizedBox(height: 24),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w500,
                color: EmanExperienceApp.navy,
              ),
            ),
            const SizedBox(height: 11),
            Text(
              widget.text,
              style: const TextStyle(height: 1.6, color: Color(0xFF617684)),
            ),
            const SizedBox(height: 20),
            Icon(Icons.arrow_forward, color: widget.accent, size: 21),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  final String eyebrow;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: const TextStyle(
            color: EmanExperienceApp.blue,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 42,
            height: 1.06,
            fontWeight: FontWeight.w500,
            letterSpacing: -1.2,
            color: EmanExperienceApp.navy,
          ),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 17,
              height: 1.6,
              color: Color(0xFF617684),
            ),
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F7FA),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE0E9EF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: EmanExperienceApp.blue),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  const _OrbitPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: .055);

    final center = Offset(size.width * .73, size.height * .46);
    for (var i = 0; i < 5; i++) {
      final radius = 115.0 + (i * 62);
      canvas.drawCircle(center, radius, paint);
    }

    final dotPaint = Paint()..color = const Color(0x66FFD477);
    for (var i = 0; i < 8; i++) {
      final angle = (progress * math.pi * 2) + (i * math.pi / 4);
      final radius = 135.0 + ((i % 4) * 58);
      canvas.drawCircle(
        center + Offset(math.cos(angle) * radius, math.sin(angle) * radius),
        2.4,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
