import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/app_i18n.dart';

class PolishedHome extends StatelessWidget {
  const PolishedHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          _HeroSection(),
          _MetricStrip(),
          _FeatureGrid(),
          _FactoryPreview(),
          _BottomBanner(),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 72, 28, 86),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF031B2D), Color(0xFF075A89)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 900;
              final copy = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Pill(icon: Icons.public_rounded, label: context.t('home.eyebrow')),
                  const SizedBox(height: 22),
                  Text(
                    context.t('home.heroTitle'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: compact ? 42 : 64,
                      height: 1.04,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 18),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 620),
                    child: Text(
                      context.t('home.heroSubtitle'),
                      style: const TextStyle(
                        color: Color(0xFFD7E9F3),
                        fontSize: 16,
                        height: 1.7,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: EmanExperienceApp.navy,
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.grid_view_rounded, size: 17),
                        label: Text(context.t('home.exploreProducts')),
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Color(0x66FFFFFF)),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.handshake_outlined, size: 17),
                        label: Text(context.t('home.becomePartner')),
                      ),
                    ],
                  ),
                ],
              );

              final visual = Container(
                height: compact ? 340 : 430,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withValues(alpha: .14)),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 24,
                      right: 24,
                      child: _GlassBadge(
                        icon: Icons.verified_rounded,
                        text: context.t('home.proofFactory'),
                      ),
                    ),
                    Image.asset(
                      'assets/products/friocups/9g-orange-flavored-powder-drink-friocups.png',
                      height: compact ? 240 : 320,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.local_drink_rounded,
                        size: 96,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      left: 24,
                      bottom: 24,
                      child: _GlassBadge(
                        icon: Icons.language_rounded,
                        text: context.t('home.proofGlobal'),
                      ),
                    ),
                  ],
                ),
              );

              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [copy, const SizedBox(height: 34), visual],
                );
              }
              return Row(
                children: [
                  Expanded(flex: 11, child: copy),
                  const SizedBox(width: 54),
                  Expanded(flex: 9, child: visual),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MetricStrip extends StatelessWidget {
  const _MetricStrip();

  @override
  Widget build(BuildContext context) {
    final items = [
      ('40+', context.t('home.badgeCountriesLabel'), Icons.public_rounded),
      ('250+', context.t('home.cardWholesaleTitle'), Icons.inventory_2_outlined),
      ('24/7', context.t('home.cardFactoryTitle'), Icons.factory_outlined),
      ('1', context.t('app.platform'), Icons.hub_outlined),
    ];
    return Container(
      color: const Color(0xFFF4F8FB),
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 18),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 760 ? 4 : 2;
              final width = (constraints.maxWidth - (columns - 1) * 12) / columns;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: items
                    .map((item) => SizedBox(
                          width: width,
                          child: _MetricCard(value: item.$1, label: item.$2, icon: item.$3),
                        ))
                    .toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid();

  @override
  Widget build(BuildContext context) {
    final features = [
      (Icons.storefront_outlined, 'home.cardWholesaleTitle', 'home.cardWholesaleText', const Color(0xFF0879B8)),
      (Icons.handshake_outlined, 'home.cardPartnerTitle', 'home.cardPartnerText', const Color(0xFF7657D9)),
      (Icons.precision_manufacturing_outlined, 'home.cardFactoryTitle', 'home.cardFactoryText', const Color(0xFFE87A35)),
      (Icons.insights_outlined, 'home.cardExecutiveTitle', 'home.cardExecutiveText', const Color(0xFF159776)),
    ];
    return Container(
      color: const Color(0xFFF4F8FB),
      padding: const EdgeInsets.fromLTRB(28, 42, 28, 84),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.t('home.capabilitiesTitle'),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                context.t('home.capabilitiesSubtitle'),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: const Color(0xFF687A86)),
              ),
              const SizedBox(height: 28),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 1040 ? 4 : constraints.maxWidth >= 620 ? 2 : 1;
                  final width = (constraints.maxWidth - (columns - 1) * 14) / columns;
                  return Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    children: features
                        .map((item) => SizedBox(
                              width: width,
                              child: _FeatureCard(
                                icon: item.$1,
                                title: context.t(item.$2),
                                body: context.t(item.$3),
                                color: item.$4,
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
}

class _FactoryPreview extends StatelessWidget {
  const _FactoryPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 82),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 860;
              final text = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.t('home.cardFactoryTitle'),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.t('home.cardFactoryText'),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: const Color(0xFF687A86), height: 1.6),
                  ),
                  const SizedBox(height: 22),
                  const Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _MiniChip(icon: Icons.inventory_2_outlined, text: 'Inventory'),
                      _MiniChip(icon: Icons.science_outlined, text: 'Recipes'),
                      _MiniChip(icon: Icons.verified_outlined, text: 'Quality'),
                      _MiniChip(icon: Icons.local_shipping_outlined, text: 'Shipping'),
                    ],
                  ),
                ],
              );
              final panel = Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7FAFC),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE2EAF0)),
                ),
                child: const Column(
                  children: [
                    _ProgressRow(label: 'Production plan', value: .82),
                    SizedBox(height: 16),
                    _ProgressRow(label: 'Warehouse readiness', value: .71),
                    SizedBox(height: 16),
                    _ProgressRow(label: 'Order fulfillment', value: .93),
                  ],
                ),
              );
              if (compact) {
                return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [text, const SizedBox(height: 28), panel]);
              }
              return Row(children: [Expanded(child: text), const SizedBox(width: 48), Expanded(child: panel)]);
            },
          ),
        ),
      ),
    );
  }
}

class _BottomBanner extends StatelessWidget {
  const _BottomBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 56),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Container(
            padding: const EdgeInsets.all(34),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(colors: [Color(0xFF04253D), Color(0xFF0870A5)]),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 700;
                final copy = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t('home.partnerBannerTitle'),
                      style: TextStyle(color: Colors.white, fontSize: compact ? 28 : 38, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      context.t('home.partnerBannerText'),
                      style: const TextStyle(color: Color(0xFFD7E9F3), height: 1.6),
                    ),
                  ],
                );
                final button = FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: EmanExperienceApp.gold, foregroundColor: EmanExperienceApp.navy),
                  onPressed: () {},
                  icon: const Icon(Icons.north_east_rounded, size: 17),
                  label: Text(context.t('home.partnerBannerButton')),
                );
                if (compact) {
                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [copy, const SizedBox(height: 20), button]);
                }
                return Row(children: [Expanded(child: copy), const SizedBox(width: 24), button]);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .09),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withValues(alpha: .14)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 15, color: const Color(0xFFFFD477)), const SizedBox(width: 7), Text(label, style: const TextStyle(color: Colors.white, fontSize: 12))]),
      );
}

class _GlassBadge extends StatelessWidget {
  const _GlassBadge({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: .12), borderRadius: BorderRadius.circular(12)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 15, color: Colors.white), const SizedBox(width: 7), Text(text, style: const TextStyle(color: Colors.white, fontSize: 12))]),
      );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.value, required this.label, required this.icon});
  final String value;
  final String label;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE2EAF0))),
        child: Row(children: [Container(width: 34, height: 34, decoration: BoxDecoration(color: const Color(0xFFEAF4FA), borderRadius: BorderRadius.circular(10)), child: Icon(icon, size: 17, color: const Color(0xFF0879B8))), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)), Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Color(0xFF687A86)))]) )]),
      );
}

class _FeatureCard extends StatefulWidget {
  const _FeatureCard({required this.icon, required this.title, required this.body, required this.color});
  final IconData icon;
  final String title;
  final String body;
  final Color color;
  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool hover = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => setState(() => hover = true),
        onExit: (_) => setState(() => hover = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          transform: Matrix4.translationValues(0, hover ? -4 : 0, 0),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: hover ? widget.color.withValues(alpha: .35) : const Color(0xFFE2EAF0)), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: hover ? .06 : .025), blurRadius: hover ? 18 : 8, offset: const Offset(0, 6))]),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 34, height: 34, decoration: BoxDecoration(color: widget.color.withValues(alpha: .10), borderRadius: BorderRadius.circular(10)), child: Icon(widget.icon, size: 18, color: widget.color)), const SizedBox(height: 18), Text(widget.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)), const SizedBox(height: 7), Text(widget.body, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF687A86), height: 1.5))]),
        ),
      );
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7), decoration: BoxDecoration(color: const Color(0xFFF4F8FB), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE2EAF0))), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 15, color: const Color(0xFF0879B8)), const SizedBox(width: 6), Text(text, style: const TextStyle(fontSize: 12))]));
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({required this.label, required this.value});
  final String label;
  final double value;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))), Text('${(value * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.w700))]), const SizedBox(height: 8), ClipRRect(borderRadius: BorderRadius.circular(99), child: LinearProgressIndicator(value: value, minHeight: 8))]);
}
