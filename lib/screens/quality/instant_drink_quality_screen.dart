import 'package:flutter/material.dart';

class InstantDrinkQualityScreen extends StatelessWidget {
  const InstantDrinkQualityScreen({required this.languageCode, super.key});
  final String languageCode;

  String tx(String ar, String tr, String en) =>
      languageCode == 'ar' ? ar : languageCode == 'tr' ? tr : en;

  @override
  Widget build(BuildContext context) {
    final checks = [
      ('B-260804-01', tx('الطعم واللون', 'Tat ve renk', 'Taste and color'), 'PASS'),
      ('B-260804-01', tx('وزن الظرف', 'Saşe ağırlığı', 'Sachet weight'), 'PASS'),
      ('B-260804-03', tx('إحكام الإغلاق', 'Sızdırmazlık', 'Seal integrity'), 'HOLD'),
      ('B-260804-03', tx('قابلية الذوبان', 'Çözünürlük', 'Solubility'), 'PASS'),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(tx('الجودة والمختبر', 'Kalite ve laboratuvar', 'Quality and laboratory'))),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Wrap(spacing: 12, runSpacing: 12, children: [
            _Metric(label: tx('دفعات اليوم', 'Bugünkü partiler', 'Today batches'), value: '3'),
            _Metric(label: tx('ناجحة', 'Onaylandı', 'Passed'), value: '2'),
            _Metric(label: tx('قيد الحجز', 'Beklemede', 'On hold'), value: '1'),
            _Metric(label: tx('فحوصات منفذة', 'Test sayısı', 'Checks completed'), value: '18'),
          ]),
          const SizedBox(height: 20),
          Card(
            child: Column(children: [
              for (final check in checks)
                ListTile(
                  leading: Icon(check.$3 == 'PASS' ? Icons.verified_rounded : Icons.pause_circle_rounded),
                  title: Text(check.$2),
                  subtitle: Text(check.$1),
                  trailing: Chip(label: Text(check.$3)),
                ),
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add_task_rounded),
        label: Text(tx('فحص جديد', 'Yeni test', 'New inspection')),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 220,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(value, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 6),
              Text(label),
            ]),
          ),
        ),
      );
}
