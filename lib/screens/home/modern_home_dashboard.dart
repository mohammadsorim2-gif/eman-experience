import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/app_i18n.dart';

class ModernHomeDashboard extends StatelessWidget {
  const ModernHomeDashboard({required this.onNavigate, super.key});

  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 760;

    return ColoredBox(
      color: const Color(0xFFF5F7FB),
      child: ListView(
        padding: EdgeInsets.fromLTRB(compact ? 16 : 28, 22, compact ? 16 : 28, 48),
        children: [
          _TopWelcome(compact: compact, onNavigate: onNavigate),
          const SizedBox(height: 22),
          _QuickActions(compact: compact, onNavigate: onNavigate),
          const SizedBox(height: 22),
          _KpiGrid(compact: compact),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              final stacked = constraints.maxWidth < 980;
              final activity = const _ActivityPanel();
              final pipeline = _PipelinePanel(onNavigate: onNavigate);
              if (stacked) {
                return Column(
                  children: [pipeline, const SizedBox(height: 18), activity],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: pipeline),
                  const SizedBox(width: 18),
                  const Expanded(flex: 2, child: activity),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TopWelcome extends StatelessWidget {
  const _TopWelcome({required this.compact, required this.onNavigate});

  final bool compact;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(compact ? 22 : 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF062A46), Color(0xFF0A6DA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth < 760;
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome_rounded, size: 16, color: Color(0xFFFFD477)),
                    const SizedBox(width: 7),
                    Text(
                      context.t('app.platform'),
                      style: theme.textTheme.labelMedium?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text(
                context.t('home.heroTitle'),
                style: theme.textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  height: 1.12,
                ),
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Text(
                  context.t('home.heroSubtitle'),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFFD8E8F2),
                    height: 1.55,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: EmanExperienceApp.navy,
                    ),
                    onPressed: () => onNavigate(1),
                    icon: const Icon(Icons.grid_view_rounded),
                    label: Text(context.t('home.exploreProducts')),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0x66FFFFFF)),
                    ),
                    onPressed: () => onNavigate(3),
                    icon: const Icon(Icons.request_quote_rounded),
                    label: const Text('RFQ'),
                  ),
                ],
              ),
            ],
          );

          final visual = Container(
            width: stacked ? double.infinity : 290,
            height: stacked ? 180 : 230,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .09),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: .14)),
            ),
            child: Stack(
              children: [
                const Positioned(
                  right: 24,
                  top: 26,
                  child: Icon(Icons.public_rounded, size: 84, color: Color(0x33FFFFFF)),
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('40+', style: theme.textTheme.displaySmall?.copyWith(color: Colors.white)),
                      const SizedBox(height: 2),
                      Text(
                        context.t('home.badgeCountriesLabel'),
                        style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFFD8E8F2)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );

          if (stacked) {
            return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [copy, const SizedBox(height: 24), visual]);
          }
          return Row(children: [Expanded(child: copy), const SizedBox(width: 34), visual]);
        },
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.compact, required this.onNavigate});

  final bool compact;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.add_business_rounded, context.t('home.becomePartner'), const Color(0xFF6E5AE6), 2),
      (Icons.request_quote_rounded, 'RFQ', const Color(0xFF0B8DB5), 3),
      (Icons.precision_manufacturing_rounded, context.t('nav.factory'), const Color(0xFFE57A32), 5),
      (Icons.insights_rounded, context.t('nav.executive'), const Color(0xFF1C9A73), 6),
    ];
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _surfaceDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.t('app.platform'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = compact ? 2 : 4;
              final cardWidth = (constraints.maxWidth - (columns - 1) * 12) / columns;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: items.map((item) => SizedBox(
                  width: cardWidth,
                  child: _ActionTile(
                    icon: item.$1,
                    label: item.$2,
                    accent: item.$3,
                    onTap: () => onNavigate(item.$4),
                  ),
                )).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatefulWidget {
  const _ActionTile({required this.icon, required this.label, required this.accent, required this.onTap});
  final IconData icon;
  final String label;
  final Color accent;
  final VoidCallback onTap;

  @override
  State<_ActionTile> createState() => _ActionTileState();
}

class _ActionTileState extends State<_ActionTile> {
  bool hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: AnimatedScale(
        scale: hover ? 1.025 : 1,
        duration: const Duration(milliseconds: 170),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: widget.onTap,
            child: Ink(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: hover ? widget.accent.withValues(alpha: .10) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: widget.accent.withValues(alpha: .18)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(color: widget.accent.withValues(alpha: .12), borderRadius: BorderRadius.circular(13)),
                    child: Icon(widget.icon, color: widget.accent, size: 22),
                  ),
                  const SizedBox(width: 11),
                  Expanded(child: Text(widget.label, maxLines: 2, overflow: TextOverflow.ellipsis)),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 13),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.compact});
  final bool compact;
  @override
  Widget build(BuildContext context) {
    final items = [
      ('24', context.t('nav.products'), '+8%', Icons.inventory_2_rounded, const Color(0xFF0B8DB5)),
      ('12', 'RFQ', '+3', Icons.request_quote_rounded, const Color(0xFF6E5AE6)),
      ('8', context.t('nav.partnerDashboard'), '+2', Icons.handshake_rounded, const Color(0xFF1C9A73)),
      ('92%', context.t('nav.factory'), '+4%', Icons.precision_manufacturing_rounded, const Color(0xFFE57A32)),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = compact ? 2 : 4;
        final width = (constraints.maxWidth - (columns - 1) * 14) / columns;
        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: items.map((item) => SizedBox(
            width: width,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: _surfaceDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: item.$5.withValues(alpha: .12), borderRadius: BorderRadius.circular(13)),
                      child: Icon(item.$4, color: item.$5, size: 21),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(color: const Color(0xFFEAF8F3), borderRadius: BorderRadius.circular(999)),
                      child: Text(item.$3, style: const TextStyle(fontSize: 11, color: Color(0xFF167A5B))),
                    ),
                  ]),
                  const SizedBox(height: 18),
                  Text(item.$1, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text(item.$2, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          )).toList(),
        );
      },
    );
  }
}

class _PipelinePanel extends StatelessWidget {
  const _PipelinePanel({required this.onNavigate});
  final ValueChanged<int> onNavigate;
  @override
  Widget build(BuildContext context) {
    final rows = [
      ('RFQ-2408', 'Valori Orange 9g', 'Review', const Color(0xFF6E5AE6)),
      ('ORD-1182', 'FrioCups Mango', 'Production', const Color(0xFFE57A32)),
      ('SHP-442', 'Private Label Mix', 'Ready', const Color(0xFF1C9A73)),
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _surfaceDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text('Pipeline', style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            TextButton(onPressed: () => onNavigate(3), child: const Text('RFQ')),
          ]),
          const SizedBox(height: 8),
          ...rows.map((row) => Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              Container(width: 10, height: 10, decoration: BoxDecoration(color: row.$4, shape: BoxShape.circle)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(row.$1), const SizedBox(height: 3), Text(row.$2, style: Theme.of(context).textTheme.bodySmall)])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(color: row.$4.withValues(alpha: .10), borderRadius: BorderRadius.circular(999)),
                child: Text(row.$3, style: TextStyle(fontSize: 11, color: row.$4)),
              ),
            ]),
          )),
        ],
      ),
    );
  }
}

class _ActivityPanel extends StatelessWidget {
  const _ActivityPanel();
  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.check_circle_rounded, const Color(0xFF1C9A73), 'RFQ approved', '5 min'),
      (Icons.factory_rounded, const Color(0xFFE57A32), 'Production updated', '18 min'),
      (Icons.description_rounded, const Color(0xFF0B8DB5), 'Document uploaded', '42 min'),
      (Icons.person_add_alt_1_rounded, const Color(0xFF6E5AE6), 'New partner request', '1 h'),
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _surfaceDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Activity', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: item.$2.withValues(alpha: .12), borderRadius: BorderRadius.circular(13)), child: Icon(item.$1, color: item.$2, size: 20)),
              const SizedBox(width: 11),
              Expanded(child: Text(item.$3)),
              Text(item.$4, style: Theme.of(context).textTheme.bodySmall),
            ]),
          )),
        ],
      ),
    );
  }
}

BoxDecoration _surfaceDecoration() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(22),
  border: Border.all(color: const Color(0xFFE7ECF2)),
  boxShadow: const [BoxShadow(color: Color(0x0D062A46), blurRadius: 24, offset: Offset(0, 10))],
);
