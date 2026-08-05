import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/app_i18n.dart';

class PolishedHome extends StatelessWidget {
  const PolishedHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF6F8FB),
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
            sliver: SliverToBoxAdapter(child: _Header(context: context)),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            sliver: SliverToBoxAdapter(child: _Metrics(context: context)),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            sliver: SliverToBoxAdapter(child: _QuickActions(context: context)),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
            sliver: SliverToBoxAdapter(child: _Workspace(context: context)),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.context});
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 760;
        final title = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.t('home.eyebrow'),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: EmanExperienceApp.blue,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              context.t('home.heroTitle'),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -.5,
                  ),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Text(
                context.t('home.heroSubtitle'),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.55,
                    ),
              ),
            ),
          ],
        );

        final actions = Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(context.t('home.exploreProducts')),
            ),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.person_add_alt_1_outlined, size: 18),
              label: Text(context.t('home.becomePartner')),
            ),
          ],
        );

        return Container(
          padding: EdgeInsets.all(compact ? 20 : 26),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE4E9F0)),
          ),
          child: compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [title, const SizedBox(height: 20), actions],
                )
              : Row(
                  children: [
                    Expanded(child: title),
                    const SizedBox(width: 24),
                    actions,
                  ],
                ),
        );
      },
    );
  }
}

class _Metrics extends StatelessWidget {
  const _Metrics({required this.context});
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final items = [
      _Metric('24', context.t('home.cardFactoryTitle'), Icons.factory_outlined, const Color(0xFF7C3AED), '+8%'),
      _Metric('18', context.t('home.cardWholesaleTitle'), Icons.receipt_long_outlined, const Color(0xFF2563EB), '+12%'),
      _Metric('96.4%', context.t('home.cardExecutiveTitle'), Icons.insights_outlined, const Color(0xFF059669), '+2.1%'),
      _Metric('7', context.t('home.cardPartnerTitle'), Icons.notifications_none_rounded, const Color(0xFFF97316), '3 critical'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1050 ? 4 : constraints.maxWidth >= 600 ? 2 : 1;
        final width = (constraints.maxWidth - (columns - 1) * 12) / columns;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: items.map((item) => SizedBox(width: width, child: _MetricCard(item: item))).toList(),
        );
      },
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.context});
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.add_box_outlined, context.t('home.cardWholesaleTitle'), const Color(0xFF2563EB)),
      (Icons.precision_manufacturing_outlined, context.t('home.cardFactoryTitle'), const Color(0xFF7C3AED)),
      (Icons.inventory_2_outlined, context.t('home.proofFactory'), const Color(0xFF059669)),
      (Icons.manage_search_rounded, context.t('home.exploreProducts'), const Color(0xFFF97316)),
    ];

    return _Section(
      title: context.t('app.platform'),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: items
            .map(
              (item) => _ActionChip(icon: item.$1, label: item.$2, color: item.$3),
            )
            .toList(),
      ),
    );
  }
}

class _Workspace extends StatelessWidget {
  const _Workspace({required this.context});
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = constraints.maxWidth < 900;
        final activity = _Section(
          title: context.t('home.capabilitiesTitle'),
          child: Column(
            children: const [
              _Activity(icon: Icons.factory_outlined, title: 'Batch EM-24018', subtitle: 'Mixing completed • 8 minutes ago', color: Color(0xFF7C3AED)),
              _Activity(icon: Icons.verified_outlined, title: 'Quality approved', subtitle: 'LOT-240805-07 • 22 minutes ago', color: Color(0xFF059669)),
              _Activity(icon: Icons.local_shipping_outlined, title: 'Shipment prepared', subtitle: 'Order SO-1842 • 41 minutes ago', color: Color(0xFF2563EB)),
            ],
          ),
        );
        final overview = _Section(
          title: context.t('home.cardExecutiveTitle'),
          child: const Column(
            children: [
              _Progress(label: 'Production plan', value: .82),
              SizedBox(height: 18),
              _Progress(label: 'Warehouse readiness', value: .71),
              SizedBox(height: 18),
              _Progress(label: 'Order fulfillment', value: .93),
            ],
          ),
        );

        if (stacked) {
          return Column(children: [activity, const SizedBox(height: 12), overview]);
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Expanded(flex: 6, child: activity), const SizedBox(width: 12), Expanded(flex: 4, child: overview)],
        );
      },
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE4E9F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _MetricCard extends StatefulWidget {
  const _MetricCard({required this.item});
  final _Metric item;
  @override
  State<_MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<_MetricCard> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.translationValues(0, hovered ? -3 : 0, 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: hovered ? item.color.withValues(alpha: .35) : const Color(0xFFE4E9F0)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: hovered ? .06 : .025), blurRadius: hovered ? 18 : 8, offset: const Offset(0, 6))],
        ),
        child: Row(
          children: [
            Container(width: 34, height: 34, decoration: BoxDecoration(color: item.color.withValues(alpha: .1), borderRadius: BorderRadius.circular(10)), child: Icon(item.icon, size: 18, color: item.color)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(item.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ]),
            ),
            Text(item.delta, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: item.color, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _ActionChip extends StatefulWidget {
  const _ActionChip({required this.icon, required this.label, required this.color});
  final IconData icon;
  final String label;
  final Color color;
  @override
  State<_ActionChip> createState() => _ActionChipState();
}

class _ActionChipState extends State<_ActionChip> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: hovered ? widget.color.withValues(alpha: .1) : const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: hovered ? widget.color.withValues(alpha: .28) : const Color(0xFFE4E9F0))),
        child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(widget.icon, size: 17, color: widget.color), const SizedBox(width: 8), Text(widget.label, style: Theme.of(context).textTheme.labelLarge)]),
      ),
    );
  }
}

class _Activity extends StatelessWidget {
  const _Activity({required this.icon, required this.title, required this.subtitle, required this.color});
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Container(width: 32, height: 32, decoration: BoxDecoration(color: color.withValues(alpha: .1), borderRadius: BorderRadius.circular(9)), child: Icon(icon, size: 17, color: color)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)), const SizedBox(height: 2), Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant))])),
        const Icon(Icons.chevron_right_rounded, size: 18),
      ]),
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({required this.label, required this.value});
  final String label;
  final double value;
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)), Text('${(value * 100).round()}%', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800))]),
      const SizedBox(height: 8),
      ClipRRect(borderRadius: BorderRadius.circular(999), child: LinearProgressIndicator(value: value, minHeight: 8, backgroundColor: const Color(0xFFEAF0F5))),
    ]);
  }
}

class _Metric {
  const _Metric(this.value, this.label, this.icon, this.color, this.delta);
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final String delta;
}
