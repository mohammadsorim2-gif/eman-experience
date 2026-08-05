import 'package:flutter/material.dart';

class BatchTraceabilityScreen extends StatefulWidget {
  const BatchTraceabilityScreen({required this.languageCode, super.key});
  final String languageCode;

  @override
  State<BatchTraceabilityScreen> createState() => _BatchTraceabilityScreenState();
}

class _BatchTraceabilityScreenState extends State<BatchTraceabilityScreen> {
  final controller = TextEditingController(text: 'LOT-260804-ORANGE-01');
  bool searched = true;

  String tx({required String ar, required String tr, required String en}) => switch (widget.languageCode) {
        'ar' => ar,
        'tr' => tr,
        _ => en,
      };

  @override
  Widget build(BuildContext context) {
    final steps = [
      (Icons.inventory_2_rounded, tx(ar: 'المواد الخام', tr: 'Hammaddeler', en: 'Raw materials'), 'Sugar S-108, Citric C-44, Orange flavor F-19'),
      (Icons.science_rounded, tx(ar: 'الخلط', tr: 'Karıştırma', en: 'Mixing'), 'Mixer 2 • 08:10–09:05 • Operator: Mehmet'),
      (Icons.scale_rounded, tx(ar: 'التعبئة والوزن', tr: 'Dolum ve tartım', en: 'Filling & weighing'), 'Line 1 • 20 g • Average 20.03 g'),
      (Icons.verified_rounded, tx(ar: 'الجودة', tr: 'Kalite', en: 'Quality'), 'Taste, color, solubility, seal: PASS'),
      (Icons.all_inbox_rounded, tx(ar: 'التغليف', tr: 'Paketleme', en: 'Packaging'), '2,400 cartons • 96 pallets'),
      (Icons.local_shipping_rounded, tx(ar: 'الشحن', tr: 'Sevkiyat', en: 'Shipping'), 'SO-24081 • Customer: Al Noor Trading'),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(tx(ar: 'تتبع الدفعة واللوط', tr: 'Parti ve lot izlenebilirliği', en: 'Batch & lot traceability'))),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: tx(ar: 'رقم LOT أو الباركود', tr: 'LOT veya barkod', en: 'LOT number or barcode'),
              prefixIcon: const Icon(Icons.qr_code_scanner_rounded),
              suffixIcon: IconButton(onPressed: () => setState(() => searched = controller.text.trim().isNotEmpty), icon: const Icon(Icons.search_rounded)),
            ),
            onSubmitted: (_) => setState(() => searched = controller.text.trim().isNotEmpty),
          ),
          const SizedBox(height: 20),
          if (searched) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Wrap(spacing: 28, runSpacing: 12, children: [
                  _Info(label: tx(ar: 'المنتج', tr: 'Ürün', en: 'Product'), value: tx(ar: 'مشروب برتقال سريع التحضير', tr: 'Portakallı toz içecek', en: 'Instant orange drink')),
                  _Info(label: tx(ar: 'الإنتاج', tr: 'Üretim', en: 'Production'), value: '04/08/2026'),
                  _Info(label: tx(ar: 'الانتهاء', tr: 'Son kullanma', en: 'Expiry'), value: '04/08/2028'),
                  _Info(label: tx(ar: 'الحالة', tr: 'Durum', en: 'Status'), value: tx(ar: 'مفرج عنها', tr: 'Serbest bırakıldı', en: 'Released')),
                ]),
              ),
            ),
            const SizedBox(height: 16),
            for (var i = 0; i < steps.length; i++)
              Card(
                child: ListTile(
                  leading: CircleAvatar(child: Icon(steps[i].$1)),
                  title: Text('${i + 1}. ${steps[i].$2}'),
                  subtitle: Text(steps[i].$3),
                  trailing: const Icon(Icons.check_circle_rounded),
                  onTap: () {},
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => SizedBox(width: 220, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: Theme.of(context).textTheme.labelMedium), const SizedBox(height: 4), Text(value, style: Theme.of(context).textTheme.titleMedium)]));
}
