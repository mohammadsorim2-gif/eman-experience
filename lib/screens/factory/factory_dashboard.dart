import 'package:flutter/material.dart';

import '../../app.dart';

class FactoryDashboard extends StatelessWidget {
  const FactoryDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        Wrap(
          spacing: 18,
          runSpacing: 18,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const SizedBox(
              width: 620,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EMAN Factory Command Center',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: EmanExperienceApp.navy,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Live production, quality, inventory, maintenance and shipment overview.',
                    style: TextStyle(fontSize: 17, color: Color(0xFF617684)),
                  ),
                ],
              ),
            ),
            const Chip(
              avatar: Icon(Icons.circle, size: 12, color: Color(0xFF16A36A)),
              label: Text('Factory Online'),
            ),
          ],
        ),
        const SizedBox(height: 28),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth >= 1100
                ? (constraints.maxWidth - 54) / 4
                : constraints.maxWidth >= 620
                    ? (constraints.maxWidth - 18) / 2
                    : constraints.maxWidth;
            return Wrap(
              spacing: 18,
              runSpacing: 18,
              children: const [
                _FactoryMetric(
                  title: 'Active production orders',
                  value: '18',
                  note: '6 due today',
                  icon: Icons.precision_manufacturing_outlined,
                  width: 250,
                ),
                _FactoryMetric(
                  title: 'Output today',
                  value: '42.8 t',
                  note: '94% of plan',
                  icon: Icons.insights_outlined,
                  width: 250,
                ),
                _FactoryMetric(
                  title: 'Quality pass rate',
                  value: '98.7%',
                  note: '3 lots on hold',
                  icon: Icons.verified_outlined,
                  width: 250,
                ),
                _FactoryMetric(
                  title: 'Ready to ship',
                  value: '11',
                  note: '4 containers booked',
                  icon: Icons.local_shipping_outlined,
                  width: 250,
                ),
              ].map((item) => SizedBox(width: width, child: item)).toList(),
            );
          },
        ),
        const SizedBox(height: 26),
        LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < 980;
            final production = const _ProductionBoard();
            final alerts = const _FactoryAlerts();
            if (stacked) {
              return const Column(
                children: [production, SizedBox(height: 18), alerts],
              );
            }
            return const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: production),
                SizedBox(width: 18),
                Expanded(flex: 2, child: alerts),
              ],
            );
          },
        ),
        const SizedBox(height: 26),
        const _OperationsGrid(),
        const SizedBox(height: 26),
        const _OrderFlow(),
      ],
    );
  }
}

class _FactoryMetric extends StatelessWidget {
  const _FactoryMetric({
    required this.title,
    required this.value,
    required this.note,
    required this.icon,
    required this.width,
  });

  final String title;
  final String value;
  final String note;
  final IconData icon;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFE9F6FF),
              child: Icon(icon, color: EmanExperienceApp.blue),
            ),
            const SizedBox(height: 20),
            Text(title, style: const TextStyle(color: Color(0xFF677A86))),
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

class _ProductionBoard extends StatelessWidget {
  const _ProductionBoard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Live production lines',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 20),
            _LineRow(name: 'Powder Line A', order: 'Valore Orange 10 g', progress: .78, status: 'Running'),
            Divider(),
            _LineRow(name: 'Powder Line B', order: 'Frio Cups Mango 9 g', progress: .51, status: 'Running'),
            Divider(),
            _LineRow(name: 'Bulk Line', order: 'Roya C Cocktail 2.5 kg', progress: .33, status: 'Setup'),
            Divider(),
            _LineRow(name: 'Packing Line C', order: 'Full Fresh Strawberry', progress: .92, status: 'Finishing'),
          ],
        ),
      ),
    );
  }
}

class _LineRow extends StatelessWidget {
  const _LineRow({
    required this.name,
    required this.order,
    required this.progress,
    required this.status,
  });

  final String name;
  final String order;
  final double progress;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(name, style: const TextStyle(fontWeight: FontWeight.w900)),
              ),
              Chip(label: Text(status)),
            ],
          ),
          Text(order, style: const TextStyle(color: Color(0xFF667985))),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            minHeight: 9,
            borderRadius: BorderRadius.circular(20),
          ),
          const SizedBox(height: 5),
          Text('${(progress * 100).round()}% complete'),
        ],
      ),
    );
  }
}

class _FactoryAlerts extends StatelessWidget {
  const _FactoryAlerts();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Priority alerts', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
            SizedBox(height: 18),
            _AlertTile(icon: Icons.inventory_2_outlined, title: 'Citric acid below safety stock', detail: 'Estimated coverage: 3.5 days', urgent: true),
            Divider(),
            _AlertTile(icon: Icons.science_outlined, title: 'Three lots awaiting laboratory release', detail: 'Quality team notified', urgent: false),
            Divider(),
            _AlertTile(icon: Icons.build_outlined, title: 'Packing Line B maintenance due', detail: 'Scheduled today at 18:00', urgent: false),
            Divider(),
            _AlertTile(icon: Icons.local_shipping_outlined, title: 'Container booking confirmation needed', detail: 'Shipment EX-2048', urgent: true),
          ],
        ),
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  const _AlertTile({required this.icon, required this.title, required this.detail, required this.urgent});

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

class _OperationsGrid extends StatelessWidget {
  const _OperationsGrid();

  static const items = [
    ('Production planning', Icons.calendar_month_outlined, 'Orders, capacity and shifts'),
    ('Raw materials', Icons.inventory_outlined, 'Stock, reservations and shortages'),
    ('Quality & laboratory', Icons.science_outlined, 'Lots, tests and release status'),
    ('Packaging', Icons.all_inbox_outlined, 'Materials, artwork and line setup'),
    ('Warehouse', Icons.warehouse_outlined, 'Finished goods and locations'),
    ('Maintenance', Icons.handyman_outlined, 'Preventive plans and breakdowns'),
    ('Employees', Icons.badge_outlined, 'Attendance, shifts and productivity'),
    ('Shipping', Icons.local_shipping_outlined, 'Containers, documents and dispatch'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1100 ? 4 : constraints.maxWidth >= 650 ? 2 : 1;
        final width = (constraints.maxWidth - (columns - 1) * 18) / columns;
        return Wrap(
          spacing: 18,
          runSpacing: 18,
          children: items.map((item) {
            return SizedBox(
              width: width,
              child: Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(item.$2, size: 32, color: EmanExperienceApp.blue),
                        const SizedBox(height: 18),
                        Text(item.$1, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 7),
                        Text(item.$3, style: const TextStyle(color: Color(0xFF667985))),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _OrderFlow extends StatelessWidget {
  const _OrderFlow();

  static const steps = [
    ('Deal won', Icons.handshake_outlined),
    ('Manufacturing order', Icons.assignment_outlined),
    ('Materials reserved', Icons.inventory_2_outlined),
    ('Production', Icons.precision_manufacturing_outlined),
    ('Quality release', Icons.verified_outlined),
    ('Warehouse', Icons.warehouse_outlined),
    ('Shipment', Icons.local_shipping_outlined),
    ('Partner commission', Icons.payments_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Connected order lifecycle', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (var i = 0; i < steps.length; i++) ...[
                  Chip(avatar: Icon(steps[i].$2, size: 18), label: Text(steps[i].$1)),
                  if (i != steps.length - 1) const Icon(Icons.arrow_forward, color: Color(0xFF8FA0AA)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
