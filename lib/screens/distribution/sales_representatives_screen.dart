import 'package:flutter/material.dart';

class SalesRepresentativesScreen extends StatefulWidget {
  const SalesRepresentativesScreen({required this.languageCode, super.key});

  final String languageCode;

  @override
  State<SalesRepresentativesScreen> createState() => _SalesRepresentativesScreenState();
}

class _SalesRepresentativesScreenState extends State<SalesRepresentativesScreen> {
  final reps = <_SalesRep>[
    const _SalesRep(name: 'أحمد', area: 'Gaziantep Center', target: 120000, achieved: 94500, visits: 18, collections: 68400),
    const _SalesRep(name: 'عبد السلام', area: 'Industrial Zone', target: 150000, achieved: 131200, visits: 21, collections: 93200),
    const _SalesRep(name: 'زلال', area: 'Export Accounts', target: 180000, achieved: 154300, visits: 12, collections: 126000),
  ];

  String tx({required String ar, required String tr, required String en}) => switch (widget.languageCode) {
        'ar' => ar,
        'tr' => tr,
        _ => en,
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tx(ar: 'المندوبون وخطوط السير', tr: 'Satış temsilcileri ve rotalar', en: 'Sales representatives & routes'))),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _Kpi(label: tx(ar: 'المندوبون', tr: 'Temsilciler', en: 'Representatives'), value: '${reps.length}', icon: Icons.badge_rounded),
              _Kpi(label: tx(ar: 'زيارات اليوم', tr: 'Bugünkü ziyaretler', en: 'Visits today'), value: '${reps.fold<int>(0, (sum, e) => sum + e.visits)}', icon: Icons.route_rounded),
              _Kpi(label: tx(ar: 'التحصيل', tr: 'Tahsilat', en: 'Collections'), value: '${reps.fold<int>(0, (sum, e) => sum + e.collections)} ₺', icon: Icons.payments_rounded),
            ],
          ),
          const SizedBox(height: 20),
          for (final rep in reps)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const CircleAvatar(child: Icon(Icons.person_pin_circle_rounded)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(rep.name, style: Theme.of(context).textTheme.titleMedium), Text(rep.area)])),
                    FilledButton.tonalIcon(onPressed: () {}, icon: const Icon(Icons.map_rounded), label: Text(tx(ar: 'المسار', tr: 'Rota', en: 'Route'))),
                  ]),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(value: (rep.achieved / rep.target).clamp(0, 1)),
                  const SizedBox(height: 8),
                  Text('${tx(ar: 'تحقيق الهدف', tr: 'Hedef gerçekleşme', en: 'Target achievement')}: ${(rep.achieved / rep.target * 100).toStringAsFixed(1)}%'),
                  const SizedBox(height: 12),
                  Wrap(spacing: 18, runSpacing: 8, children: [
                    Text('${tx(ar: 'المبيعات', tr: 'Satış', en: 'Sales')}: ${rep.achieved} ₺'),
                    Text('${tx(ar: 'الزيارات', tr: 'Ziyaret', en: 'Visits')}: ${rep.visits}'),
                    Text('${tx(ar: 'التحصيل', tr: 'Tahsilat', en: 'Collections')}: ${rep.collections} ₺'),
                  ]),
                ]),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () {}, icon: const Icon(Icons.add_location_alt_rounded), label: Text(tx(ar: 'مندوب أو مسار', tr: 'Temsilci veya rota', en: 'Representative or route'))),
    );
  }
}

class _SalesRep {
  const _SalesRep({required this.name, required this.area, required this.target, required this.achieved, required this.visits, required this.collections});
  final String name;
  final String area;
  final int target;
  final int achieved;
  final int visits;
  final int collections;
}

class _Kpi extends StatelessWidget {
  const _Kpi({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => SizedBox(width: 230, child: Card(child: Padding(padding: const EdgeInsets.all(18), child: Row(children: [Icon(icon), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: Theme.of(context).textTheme.titleLarge), Text(label)]))]))));
}
