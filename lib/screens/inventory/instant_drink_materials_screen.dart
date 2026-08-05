import 'package:flutter/material.dart';

class InstantDrinkMaterialsScreen extends StatefulWidget {
  const InstantDrinkMaterialsScreen({required this.languageCode, super.key});
  final String languageCode;

  @override
  State<InstantDrinkMaterialsScreen> createState() => _InstantDrinkMaterialsScreenState();
}

class _InstantDrinkMaterialsScreenState extends State<InstantDrinkMaterialsScreen> {
  final items = <_MaterialItem>[
    _MaterialItem('Sugar', 'RM-SUGAR', 18400, 5000, 'kg'),
    _MaterialItem('Citric acid', 'RM-CITRIC', 2100, 800, 'kg'),
    _MaterialItem('Orange flavour', 'FL-ORANGE', 320, 150, 'kg'),
    _MaterialItem('Mango flavour', 'FL-MANGO', 96, 120, 'kg'),
    _MaterialItem('25 g sachet film', 'PK-SACHET25', 780, 250, 'roll'),
    _MaterialItem('Shipping cartons', 'PK-CARTON', 4200, 1500, 'pcs'),
  ];

  String tx(String ar, String tr, String en) =>
      widget.languageCode == 'ar' ? ar : widget.languageCode == 'tr' ? tr : en;

  @override
  Widget build(BuildContext context) {
    final low = items.where((e) => e.quantity <= e.minimum).length;
    return Scaffold(
      appBar: AppBar(title: Text(tx('مخزون المواد', 'Malzeme stoğu', 'Materials inventory'))),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Wrap(spacing: 12, runSpacing: 12, children: [
            _Summary(title: tx('إجمالي الأصناف', 'Toplam kalem', 'Total items'), value: '${items.length}'),
            _Summary(title: tx('تنبيه مخزون', 'Stok uyarısı', 'Low stock'), value: '$low'),
            _Summary(title: tx('مواد خام', 'Hammadde', 'Raw materials'), value: '4'),
            _Summary(title: tx('مواد تغليف', 'Ambalaj', 'Packaging'), value: '2'),
          ]),
          const SizedBox(height: 20),
          Card(
            child: Column(children: [
              for (final item in items)
                ListTile(
                  leading: CircleAvatar(child: Icon(item.quantity <= item.minimum ? Icons.warning_amber_rounded : Icons.inventory_2_rounded)),
                  title: Text(item.name),
                  subtitle: Text('${item.code} • ${tx('الحد الأدنى', 'Minimum', 'Minimum')}: ${item.minimum} ${item.unit}'),
                  trailing: Text('${item.quantity} ${item.unit}', style: Theme.of(context).textTheme.titleMedium),
                ),
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.swap_vert_rounded),
        label: Text(tx('حركة مخزون', 'Stok hareketi', 'Stock movement')),
      ),
    );
  }
}

class _MaterialItem {
  _MaterialItem(this.name, this.code, this.quantity, this.minimum, this.unit);
  final String name;
  final String code;
  final int quantity;
  final int minimum;
  final String unit;
}

class _Summary extends StatelessWidget {
  const _Summary({required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 220,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(value, style: Theme.of(context).textTheme.headlineMedium),
              Text(title),
            ]),
          ),
        ),
      );
}
