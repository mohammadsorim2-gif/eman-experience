import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/app_i18n.dart';

class LocalizedHome extends StatelessWidget {
  const LocalizedHome({super.key});

  static const _products = [
    'assets/products/friocups/9g-orange-flavored-powder-drink-friocups.png',
    'assets/products/friocups/9g-mango-flavored-powder-drink-friocups.png',
    'assets/products/friocups/9g-berries-flavored-powder-drink-friocups.png',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _hero(context),
        _capabilities(context),
        _partnerBanner(context),
      ],
    );
  }

  Widget _hero(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 72),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFEAF7FF), Color(0xFFFFF4DD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 900;
              final copy = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.t('home.eyebrow'),
                    style: const TextStyle(
                      color: EmanExperienceApp.blue,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.8,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    context.t('home.heroTitle'),
                    style: TextStyle(
                      fontSize: compact ? 48 : 72,
                      height: .98,
                      fontWeight: FontWeight.w900,
                      color: EmanExperienceApp.navy,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    context.t('home.heroSubtitle'),
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.6,
                      color: Color(0xFF536C7B),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.inventory_2_outlined),
                        label: Text(context.t('home.exploreProducts')),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.person_add_alt_outlined),
                        label: Text(context.t('home.becomePartner')),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Wrap(
                    spacing: 18,
                    runSpacing: 12,
                    children: [
                      _Proof(icon: Icons.public, text: context.t('home.proofGlobal')),
                      _Proof(icon: Icons.factory_outlined, text: context.t('home.proofFactory')),
                      _Proof(icon: Icons.payments_outlined, text: context.t('home.proofCommission')),
                    ],
                  ),
                ],
              );

              final visual = Container(
                height: compact ? 440 : 560,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(38),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 45,
                      color: Color(0x1A000000),
                      offset: Offset(0, 20),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 24,
                      right: 24,
                      child: _Badge(
                        icon: Icons.language,
                        value: context.t('home.badgeCountriesValue'),
                        label: context.t('home.badgeCountriesLabel'),
                      ),
                    ),
                    Positioned(
                      bottom: 24,
                      left: 24,
                      child: _Badge(
                        icon: Icons.handshake_outlined,
                        value: context.t('home.badgePartnersValue'),
                        label: context.t('home.badgePartnersLabel'),
                      ),
                    ),
                    Image.asset(
                      _products.first,
                      height: compact ? 285 : 365,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.local_drink,
                        size: 150,
                        color: EmanExperienceApp.blue,
                      ),
                    ),
                  ],
                ),
              );

              if (compact) {
                return Column(
                  children: [copy, const SizedBox(height: 42), visual],
                );
              }

              return Row(
                children: [
                  Expanded(child: copy),
                  const SizedBox(width: 56),
                  Expanded(child: visual),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _capabilities(BuildContext context) {
    final items = [
      (Icons.storefront_outlined, 'home.cardWholesaleTitle', 'home.cardWholesaleText'),
      (Icons.groups_outlined, 'home.cardPartnerTitle', 'home.cardPartnerText'),
      (Icons.factory_outlined, 'home.cardFactoryTitle', 'home.cardFactoryText'),
      (Icons.monitor_heart_outlined, 'home.cardExecutiveTitle', 'home.cardExecutiveText'),
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 76),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.t('home.capabilitiesTitle'),
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: EmanExperienceApp.navy,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                context.t('home.capabilitiesSubtitle'),
                style: const TextStyle(fontSize: 17, color: Color(0xFF617684)),
              ),
              const SizedBox(height: 30),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 1050
                      ? 4
                      : constraints.maxWidth >= 600
                          ? 2
                          : 1;
                  final width =
                      (constraints.maxWidth - ((columns - 1) * 18)) / columns;
                  return Wrap(
                    spacing: 18,
                    runSpacing: 18,
                    children: items.map((item) {
                      return SizedBox(
                        width: width,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: const Color(0xFFE9F6FF),
                                  child: Icon(item.$1, color: EmanExperienceApp.blue),
                                ),
                                const SizedBox(height: 22),
                                Text(
                                  context.t(item.$2),
                                  style: const TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w900,
                                    color: EmanExperienceApp.navy,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  context.t(item.$3),
                                  style: const TextStyle(height: 1.55),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _partnerBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(28, 0, 28, 40),
      padding: const EdgeInsets.all(38),
      decoration: BoxDecoration(
        color: EmanExperienceApp.navy,
        borderRadius: BorderRadius.circular(32),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 760;
          final text = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.t('home.partnerBannerTitle'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                context.t('home.partnerBannerText'),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 17,
                  height: 1.5,
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
            icon: const Icon(Icons.arrow_forward),
            label: Text(context.t('home.partnerBannerButton')),
          );
          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [text, const SizedBox(height: 24), button],
            );
          }
          return Row(
            children: [Expanded(child: text), const SizedBox(width: 28), button],
          );
        },
      ),
    );
  }
}

class _Proof extends StatelessWidget {
  const _Proof({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: EmanExperienceApp.blue),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
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
      width: 170,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: EmanExperienceApp.navy,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: EmanExperienceApp.gold),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
