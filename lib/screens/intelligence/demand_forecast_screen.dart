import 'package:flutter/material.dart';

class DemandForecastScreen extends StatelessWidget {
  const DemandForecastScreen({required this.languageCode, super.key});
  final String languageCode;

  String tx({required String ar, required String tr, required String en}) => switch (languageCode) {
        'ar' => ar,
        'tr' => tr,
        _ => en,
      };

  @override
  Widget build(BuildContext context) {
    final forecasts = [
      const _Forecast('Orange 20 g', 128000, 18, 96, 8),
      const _Forecast('Mango 20 g', 103000, 11, 82, 6),
      const _Forecast('Strawberry 20 g', 94000, -4, 108, 3),
      const _Forecast('Pineapple 20 g', 68000, 7, 74, 5),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(tx(ar: 'التنبؤ بالطلب وخطة الإنتاج', tr: 'Talep tahmini ve üretim planı', en: 'Demand forecast & production plan'))),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(tx(ar: 'توصية النظام للأسبوع القادم', tr: 'Gelecek hafta sistem önerisi', en: 'System recommendation for next week'), style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
                Text(tx(ar: 'رفع إنتاج البرتقال والمانجو، وتخفيض الفراولة مؤقتًا، مع شراء نكهة البرتقال ورول تغليف إضافي.', tr: 'Portakal ve mango üretimini artırın, çileği geçici azaltın; portakal aroması ve ek ambalaj rulosu satın alın.', en: 'Increase orange and mango output, temporarily reduce strawberry, and purchase orange flavor plus additional packaging film.')),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          for (final item in forecasts)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(item.product, style: Theme.of(context).textTheme.titleMedium)),
                    Chip(label: Text('${item.growth >= 0 ? '+' : ''}${item.growth}%')),
                  ]),
                  const SizedBox(height: 12),
                  Wrap(spacing: 24, runSpacing: 10, children: [
                    _Metric(label: tx(ar: 'الطلب المتوقع', tr: 'Tahmini talep', en: 'Forecast demand'), value: '${item.forecastUnits}'),
                    _Metric(label: tx(ar: 'تغطية المخزون', tr: 'Stok kapsama', en: 'Stock coverage'), value: '${item.stockCoverage}%'),
                    _Metric(label: tx(ar: 'دفعات مقترحة', tr: 'Önerilen partiler', en: 'Suggested batches'), value: '${item.suggestedBatches}'),
                  ]),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: (item.stockCoverage / 120).clamp(0, 1)),
                ]),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () {}, icon: const Icon(Icons.auto_awesome_rounded), label: Text(tx(ar: 'إنشاء خطة', tr: 'Plan oluştur', en: 'Generate plan'))),
    );
  }
}

class _Forecast {
  const _Forecast(this.product, this.forecastUnits, this.growth, this.stockCoverage, this.suggestedBatches);
  final String product;
  final int forecastUnits;
  final int growth;
  final int stockCoverage;
  final int suggestedBatches;
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => SizedBox(width: 180, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: Theme.of(context).textTheme.titleLarge), Text(label)]));
}
