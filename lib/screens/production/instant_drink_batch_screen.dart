import 'package:flutter/material.dart';

class InstantDrinkBatchScreen extends StatefulWidget {
  const InstantDrinkBatchScreen({required this.languageCode, super.key});
  final String languageCode;

  @override
  State<InstantDrinkBatchScreen> createState() => _InstantDrinkBatchScreenState();
}

class _InstantDrinkBatchScreenState extends State<InstantDrinkBatchScreen> {
  final batches = <_Batch>[
    _Batch('B-260804-01', 'Orange 25 g', 1200, 780, 'Mixing', 65),
    _Batch('B-260804-02', 'Mango 25 g', 900, 900, 'Completed', 100),
    _Batch('B-260804-03', 'Strawberry 25 g', 1500, 420, 'Filling', 28),
  ];

  String tx(String ar, String tr, String en) =>
      widget.languageCode == 'ar' ? ar : widget.languageCode == 'tr' ? tr : en;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tx('دفعات الإنتاج', 'Üretim partileri', 'Production batches'))),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: batches.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final batch = batches[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(child: Text(batch.code, style: Theme.of(context).textTheme.titleLarge)),
                    Chip(label: Text(batch.stage)),
                  ]),
                  const SizedBox(height: 8),
                  Text(batch.product),
                  const SizedBox(height: 14),
                  LinearProgressIndicator(value: batch.progress / 100),
                  const SizedBox(height: 8),
                  Text('${tx('المنجز', 'Tamamlanan', 'Completed')}: ${batch.completedKg}/${batch.targetKg} kg'),
                  const SizedBox(height: 10),
                  Wrap(spacing: 8, children: [
                    OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.science_rounded), label: Text(tx('فتح الوصفة', 'Reçeteyi aç', 'Open recipe'))),
                    FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.play_arrow_rounded), label: Text(tx('تحديث المرحلة', 'Aşamayı güncelle', 'Update stage'))),
                  ]),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add_rounded),
        label: Text(tx('دفعة جديدة', 'Yeni parti', 'New batch')),
      ),
    );
  }
}

class _Batch {
  _Batch(this.code, this.product, this.targetKg, this.completedKg, this.stage, this.progress);
  final String code;
  final String product;
  final int targetKg;
  final int completedKg;
  final String stage;
  final int progress;
}
