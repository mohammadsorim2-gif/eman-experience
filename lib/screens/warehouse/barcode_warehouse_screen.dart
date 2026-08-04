import 'package:flutter/material.dart';

class BarcodeWarehouseScreen extends StatefulWidget {
  const BarcodeWarehouseScreen({required this.languageCode, super.key});

  final String languageCode;

  @override
  State<BarcodeWarehouseScreen> createState() => _BarcodeWarehouseScreenState();
}

class _BarcodeWarehouseScreenState extends State<BarcodeWarehouseScreen> {
  final _scanController = TextEditingController();
  final List<_ScanRecord> _records = [
    const _ScanRecord(code: 'LOT-OR-240804-01', item: 'Orange 25 g sachets', action: 'receipt', quantity: 120),
    const _ScanRecord(code: 'RM-SUGAR-0826', item: 'Sugar', action: 'issue', quantity: 500),
  ];

  String _tx({required String ar, required String tr, required String en}) =>
      switch (widget.languageCode) {'ar' => ar, 'tr' => tr, _ => en};

  void _addRecord(String action) {
    final code = _scanController.text.trim();
    if (code.isEmpty) return;
    setState(() {
      _records.insert(0, _ScanRecord(code: code, item: _tx(ar: 'عنصر ممسوح', tr: 'Taranan ürün', en: 'Scanned item'), action: action, quantity: 1));
      _scanController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_tx(ar: 'مستودع الباركود', tr: 'Barkod deposu', en: 'Barcode warehouse'))),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: _scanController,
                    autofocus: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.qr_code_scanner_rounded),
                      labelText: _tx(ar: 'امسح الباركود أو QR', tr: 'Barkod veya QR tara', en: 'Scan barcode or QR'),
                    ),
                    onSubmitted: (_) => _addRecord('receipt'),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton.icon(onPressed: () => _addRecord('receipt'), icon: const Icon(Icons.download_rounded), label: Text(_tx(ar: 'استلام', tr: 'Giriş', en: 'Receive'))),
                      FilledButton.tonalIcon(onPressed: () => _addRecord('issue'), icon: const Icon(Icons.upload_rounded), label: Text(_tx(ar: 'صرف', tr: 'Çıkış', en: 'Issue'))),
                      OutlinedButton.icon(onPressed: () => _addRecord('count'), icon: const Icon(Icons.inventory_2_outlined), label: Text(_tx(ar: 'جرد', tr: 'Sayım', en: 'Count'))),
                      OutlinedButton.icon(onPressed: () => _addRecord('ship'), icon: const Icon(Icons.local_shipping_outlined), label: Text(_tx(ar: 'شحن', tr: 'Sevkiyat', en: 'Ship'))),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(_tx(ar: 'آخر الحركات', tr: 'Son hareketler', en: 'Recent movements'), style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          for (final record in _records)
            Card(
              child: ListTile(
                leading: CircleAvatar(child: Icon(_iconFor(record.action))),
                title: Text(record.item),
                subtitle: Text('${record.code} • ${record.action}'),
                trailing: Text('${record.quantity}'),
              ),
            ),
        ],
      ),
    );
  }

  IconData _iconFor(String action) => switch (action) {
        'receipt' => Icons.download_rounded,
        'issue' => Icons.upload_rounded,
        'count' => Icons.inventory_2_outlined,
        _ => Icons.local_shipping_outlined,
      };
}

class _ScanRecord {
  const _ScanRecord({required this.code, required this.item, required this.action, required this.quantity});
  final String code;
  final String item;
  final String action;
  final int quantity;
}
