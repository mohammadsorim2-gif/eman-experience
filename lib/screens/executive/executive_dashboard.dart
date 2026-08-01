import 'package:flutter/material.dart';

import '../../app.dart';

class ExecutiveDashboard extends StatelessWidget {
  const ExecutiveDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        const Text(
          'Executive Command Center',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w900,
            color: EmanExperienceApp.navy,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'One live view for sales, partners, production, quality, warehouse and shipping.',
          style: TextStyle(fontSize: 17, color: Color(0xFF607482)),
        ),
        const SizedBox(height: 28),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 1100
                ? 4
                : constraints.maxWidth >= 620
                    ? 2
                    : 1;
            final width =
                (constraints.maxWidth - ((columns - 1) * 18)) / columns;
            return Wrap(
              spacing: 18,
              runSpacing: 18,
              children: const [
                _ExecutiveMetric('Partner pipeline', '\$1.82M', '+18% this month', Icons.public),
                _ExecutiveMetric('Confirmed orders', '34', '12 entered production', Icons.handshake_outlined),
                _ExecutiveMetric('Factory utilization', '87%', '4 active lines', Icons.factory_outlined),
                _ExecutiveMetric('Ready to ship', '11', '4 containers booked', Icons.local_shipping_outlined),
              ].map((item) => SizedBox(width: width, child: item)).toList(),
            );
          },
        ),
        const SizedBox(height: 26),
        LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < 980;
            const sales = _SalesToFactoryBoard();
            const attention = _ExecutiveAttention();
            if (stacked) {
              return const Column(
                children: [sales, SizedBox(height: 18), attention],
              );
            }
            return const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: sales),
                SizedBox(width: 18),
                Expanded(flex: 2, child: attention),
              ],
            );
          },
        ),
        const SizedBox(height: 26),
        const _GlobalPerformance(),
      ],
    );
  }
}

class _ExecutiveMetric extends StatelessWidget {
  const _ExecutiveMetric(this.title, this.value, this.note, this.icon);

  final String title;
  final String value;
  final String note;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFEAF6FF),
              child: Icon(icon, color: EmanExperienceApp.blue),
            ),
            const SizedBox(height: 18),
            Text(title, style: const TextStyle(color: Color(0xFF667A86))),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: EmanExperienceApp.navy,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              note,
              style: const TextStyle(
                color: Color(0xFF168A61),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SalesToFactoryBoard extends StatelessWidget {
  const _SalesToFactoryBoard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Sales-to-factory pipeline', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
            SizedBox(height: 20),
            _PipelineRow('Nova Market Group', 'Brazil', 'Frio Cups mixed container', 'Production', .72),
            Divider(),
            _PipelineRow('Atlas Distribution', 'Morocco', 'Valore 10 g assortment', 'Materials reserved', .48),
            Divider(),
            _PipelineRow('Golden Foods', 'Saudi Arabia', 'Private label orange', 'Quality release', .86),
            Divider(),
            _PipelineRow('Baltic Foods', 'Lithuania', 'Roya C foodservice', 'Quotation', .24),
          ],
        ),
      ),
    );
  }
}

class _PipelineRow extends StatelessWidget {
  const _PipelineRow(this.company, this.country, this.order, this.stage, this.progress);

  final String company;
  final String country;
  final String order;
  final String stage;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(company, style: const TextStyle(fontWeight: FontWeight.w900))),
              Chip(label: Text(stage)),
            ],
          ),
          Text('$country · $order', style: const TextStyle(color: Color(0xFF677985))),
          const SizedBox(height: 9),
          LinearProgressIndicator(value: progress, minHeight: 8, borderRadius: BorderRadius.circular(20)),
        ],
      ),
    );
  }
}

class _ExecutiveAttention extends StatelessWidget {
  const _ExecutiveAttention();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Needs executive attention', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
            SizedBox(height: 18),
            _AttentionTile(Icons.inventory_2_outlined, 'Raw material risk', 'Citric acid coverage is below 4 days', true),
            Divider(),
            _AttentionTile(Icons.payments_outlined, 'Commission approval', 'Two completed partner deals awaiting approval', false),
            Divider(),
            _AttentionTile(Icons.science_outlined, 'Quality hold', 'Three lots awaiting laboratory release', false),
            Divider(),
            _AttentionTile(Icons.local_shipping_outlined, 'Shipping deadline', 'Container EX-2048 must be confirmed today', true),
          ],
        ),
      ),
    );
  }
}

class _AttentionTile extends StatelessWidget {
  const _AttentionTile(this.icon, this.title, this.detail, this.urgent);

  final IconData icon;
  final String title;
  final String detail;
  final bool urgent;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: urgent ? const Color(0xFFFFECE8) : const Color(0xFFEAF6FF),
        child: Icon(icon, color: urgent ? const Color(0xFFD74B33) : EmanExperienceApp.blue),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(detail),
    );
  }
}

class _GlobalPerformance extends StatelessWidget {
  const _GlobalPerformance();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Global performance by region', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
            const SizedBox(height: 18),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth >= 900
                    ? (constraints.maxWidth - 54) / 4
                    : constraints.maxWidth >= 520
                        ? (constraints.maxWidth - 18) / 2
                        : constraints.maxWidth;
                const regions = [
                  ('Middle East', '42%', '\$760K'),
                  ('Europe', '27%', '\$486K'),
                  ('Africa', '19%', '\$342K'),
                  ('Latin America', '12%', '\$216K'),
                ];
                return Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: regions.map((region) {
                    return SizedBox(
                      width: width,
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F9FC),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(region.$1, style: const TextStyle(fontWeight: FontWeight.w900)),
                            const SizedBox(height: 8),
                            Text(region.$2, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: EmanExperienceApp.blue)),
                            Text(region.$3, style: const TextStyle(color: Color(0xFF667985))),
                          ],
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
    );
  }
}
