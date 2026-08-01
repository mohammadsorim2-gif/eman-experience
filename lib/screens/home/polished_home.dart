import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/app_i18n.dart';

class PolishedHome extends StatefulWidget {
  const PolishedHome({super.key});

  @override
  State<PolishedHome> createState() => _PolishedHomeState();
}

class _PolishedHomeState extends State<PolishedHome>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int _activeProduct = 0;

  static const products = [
    'assets/products/friocups/9g-orange-flavored-powder-drink-friocups.png',
    'assets/products/friocups/9g-mango-flavored-powder-drink-friocups.png',
    'assets/products/friocups/9g-berries-flavored-powder-drink-friocups.png',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
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
          _metrics(context),
          _capabilities(context),
          _showcase(context),
          _cta(context),
        ],
      ),
    );
  }

  Widget _hero(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 700),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF031B2D), Color(0xFF063D61), Color(0xFF0876AD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => CustomPaint(
                painter: _MeshPainter(_controller.value),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 62),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1280),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 920;
                    final text = _HeroText(compact: compact);
                    final visual = _InteractiveProductVisual(
                      compact: compact,
                      controller: _controller,
                      product: products[_activeProduct],
                      activeIndex: _activeProduct,
                      onSelected: (index) => setState(() => _activeProduct = index),
                    );
                    if (compact) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [text, const SizedBox(height: 42), visual],
                      );
                    }
                    return Row(
                      children: [
                        Expanded(flex: 11, child: text),
                        const SizedBox(width: 54),
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

  Widget _metrics(BuildContext context) {
    final items = [
      ('40+', context.t('home.badgeCountriesLabel'), Icons.language_rounded),
      ('250+', context.t('home.cardWholesaleTitle'), Icons.widgets_rounded),
      ('24/7', context.t('home.cardFactoryTitle'), Icons.precision_manufacturing_rounded),
      ('1', context.t('app.platform'), Icons.hub_rounded),
    ];
    return Transform.translate(
      offset: const Offset(0, -28),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1160),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 42,
                    offset: Offset(0, 16),
                    color: Color(0x1F052A45),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 820 ? 4 : 2;
                  final width = (constraints.maxWidth - (columns - 1) * 10) / columns;
                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: items
                        .map((item) => SizedBox(
                              width: width,
                              child: _MetricCard(
                                value: item.$1,
                                label: item.$2,
                                icon: item.$3,
                              ),
                            ))
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
      (Icons.business_center_rounded, 'home.cardWholesaleTitle', 'home.cardWholesaleText', const Color(0xFF0879B8)),
      (Icons.connect_without_contact_rounded, 'home.cardPartnerTitle', 'home.cardPartnerText', const Color(0xFF7657D9)),
      (Icons.precision_manufacturing_rounded, 'home.cardFactoryTitle', 'home.cardFactoryText', const Color(0xFFE87A35)),
      (Icons.insights_rounded, 'home.cardExecutiveTitle', 'home.cardExecutiveText', const Color(0xFF159776)),
    ];
    return Container(
      color: const Color(0xFFF4F8FB),
      padding: const EdgeInsets.fromLTRB(28, 48, 28, 92),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionTitle(
                eyebrow: context.t('app.platform'),
                title: context.t('home.capabilitiesTitle'),
                subtitle: context.t('home.capabilitiesSubtitle'),
              ),
              const SizedBox(height: 32),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 1080
                      ? 4
                      : constraints.maxWidth >= 650
                          ? 2
                          : 1;
                  final width = (constraints.maxWidth - (columns - 1) * 18) / columns;
                  return Wrap(
                    spacing: 18,
                    runSpacing: 18,
                    children: items
                        .map((item) => SizedBox(
                              width: width,
                              child: _HoverCapability(
                                icon: item.$1,
                                title: context.t(item.$2),
                                body: context.t(item.$3),
                                accent: item.$4,
                              ),
                            ))
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

  Widget _showcase(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 88),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 900;
              final copy = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(
                    eyebrow: context.t('home.cardWholesaleTitle'),
                    title: context.t('home.exploreProducts'),
                    subtitle: context.t('home.cardWholesaleText'),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _SoftChip(Icons.verified_rounded, context.t('home.proofFactory')),
                      _SoftChip(Icons.public_rounded, context.t('home.proofGlobal')),
                      _SoftChip(Icons.payments_rounded, context.t('home.proofCommission')),
                    ],
                  ),
                  const SizedBox(height: 28),
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                    label: Text(context.t('home.exploreProducts')),
                  ),
                ],
              );
              final visual = _ProductRail(products: products);
              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [copy, const SizedBox(height: 38), visual],
                );
              }
              return Row(
                children: [
                  Expanded(flex: 5, child: copy),
                  const SizedBox(width: 48),
                  Expanded(flex: 6, child: visual),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _cta(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 58),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(34),
              gradient: const LinearGradient(
                colors: [Color(0xFF04253D), Color(0xFF0870A5)],
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 760;
                final content = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t('home.partnerBannerTitle'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: compact ? 31 : 40,
                        height: 1.12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.t('home.partnerBannerText'),
                      style: const TextStyle(
                        color: Color(0xFFD4E7F2),
                        fontSize: 16,
                        height: 1.65,
                      ),
                    ),
                  ],
                );
                final button = FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: EmanExperienceApp.gold,
                    foregroundColor: EmanExperienceApp.navy,
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.north_east_rounded, size: 18),
                  label: Text(context.t('home.partnerBannerButton')),
                );
                if (compact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [content, const SizedBox(height: 24), button],
                  );
                }
                return Row(
                  children: [Expanded(child: content), const SizedBox(width: 30), button],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  const _HeroText({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .09),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withValues(alpha: .14)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome_rounded, size: 15, color: Color(0xFFFFD477)),
              const SizedBox(width: 8),
              Text(
                context.t('home.eyebrow'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .9,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text(
          context.t('home.heroTitle'),
          style: TextStyle(
            color: Colors.white,
            fontSize: compact ? 46 : 68,
            height: 1.02,
            letterSpacing: compact ? -1 : -1.7,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 22),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Text(
            context.t('home.heroSubtitle'),
            style: const TextStyle(
              color: Color(0xFFD4E7F2),
              fontSize: 17,
              height: 1.65,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Wrap(
          spacing: 11,
          runSpacing: 11,
          children: [
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: EmanExperienceApp.navy,
              ),
              onPressed: () {},
              icon: const Icon(Icons.grid_view_rounded, size: 18),
              label: Text(context.t('home.exploreProducts')),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0x66FFFFFF)),
              ),
              onPressed: () {},
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
              label: Text(context.t('home.becomePartner')),
            ),
          ],
        ),
      ],
    );
  }
}

class _InteractiveProductVisual extends StatelessWidget {
  const _InteractiveProductVisual({
    required this.compact,
    required this.controller,
    required this.product,
    required this.activeIndex,
    required this.onSelected,
  });

  final bool compact;
  final AnimationController controller;
  final String product;
  final int activeIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: compact ? 430 : 530,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: Colors.white.withValues(alpha: .15)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              final y = math.sin(controller.value * math.pi * 2) * 9;
              return Transform.translate(offset: Offset(0, y), child: child);
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 420),
              child: Image.asset(
                product,
                key: ValueKey(product),
                height: compact ? 280 : 350,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.local_drink_rounded,
                  size: 72,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xCC031B2D),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (index) {
                  final active = index == activeIndex;
                  return GestureDetector(
                    onTap: () => onSelected(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: active ? 30 : 10,
                      height: 10,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: active ? EmanExperienceApp.gold : Colors.white38,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.value, required this.label, required this.icon});
  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(19),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFE6F3FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 19, color: EmanExperienceApp.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
                Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Color(0xFF687B87))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HoverCapability extends StatefulWidget {
  const _HoverCapability({required this.icon, required this.title, required this.body, required this.accent});
  final IconData icon;
  final String title;
  final String body;
  final Color accent;

  @override
  State<_HoverCapability> createState() => _HoverCapabilityState();
}

class _HoverCapabilityState extends State<_HoverCapability> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        transform: Matrix4.translationValues(0, hovering ? -7 : 0, 0),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: hovering ? widget.accent.withValues(alpha: .42) : const Color(0xFFE5EDF2)),
          boxShadow: hovering
              ? [BoxShadow(blurRadius: 28, offset: const Offset(0, 14), color: widget.accent.withValues(alpha: .13))]
              : const [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: widget.accent.withValues(alpha: .11),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(widget.icon, size: 21, color: widget.accent),
            ),
            const SizedBox(height: 19),
            Text(widget.title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: EmanExperienceApp.navy)),
            const SizedBox(height: 9),
            Text(widget.body, style: const TextStyle(height: 1.55, color: Color(0xFF617482))),
            const SizedBox(height: 15),
            Icon(Icons.arrow_outward_rounded, size: 18, color: widget.accent),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.eyebrow, required this.title, required this.subtitle});
  final String eyebrow;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(eyebrow.toUpperCase(), style: const TextStyle(fontSize: 11, letterSpacing: 1.3, fontWeight: FontWeight.w800, color: EmanExperienceApp.blue)),
        const SizedBox(height: 11),
        Text(title, style: const TextStyle(fontSize: 36, height: 1.12, fontWeight: FontWeight.w800, color: EmanExperienceApp.navy)),
        const SizedBox(height: 11),
        Text(subtitle, style: const TextStyle(fontSize: 16, height: 1.6, color: Color(0xFF617482))),
      ],
    );
  }
}

class _ProductRail extends StatelessWidget {
  const _ProductRail({required this.products});
  final List<String> products;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 390,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFF4F9FC), Color(0xFFE9F4FA)]),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(products.length, (index) {
          return Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 500 + index * 160),
              curve: Curves.easeOutBack,
              builder: (context, value, child) => Transform.translate(
                offset: Offset(0, (1 - value) * 45 - (index == 1 ? 20 : 0)),
                child: Opacity(opacity: value.clamp(0, 1), child: child),
              ),
              child: Image.asset(
                products[index],
                height: index == 1 ? 320 : 275,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const Icon(Icons.local_drink_rounded, size: 58),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _SoftChip extends StatelessWidget {
  const _SoftChip(this.icon, this.text);
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F6F9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: EmanExperienceApp.blue),
          const SizedBox(width: 7),
          Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _MeshPainter extends CustomPainter {
  const _MeshPainter(this.progress);
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: .045)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < 6; i++) {
      final radius = 90.0 + i * 62;
      final x = size.width * .78 + math.sin(progress * math.pi * 2 + i) * 20;
      final y = size.height * .38 + math.cos(progress * math.pi * 2 + i) * 18;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MeshPainter oldDelegate) => oldDelegate.progress != progress;
}
