import 'package:flutter/material.dart';

class FinishedGoodsShippingScreen extends StatefulWidget {
  const FinishedGoodsShippingScreen({required this.languageCode, super.key});

  final String languageCode;

  @override
  State<FinishedGoodsShippingScreen> createState() => _FinishedGoodsShippingScreenState();
}

class _FinishedGoodsShippingScreenState extends State<FinishedGoodsShippingScreen> {
  final _lots = <_FinishedLot>[
    const _FinishedLot('LOT-OR-240804', 'Orange 30 g', 620, 18, _ShippingStatus.available),
    const _FinishedLot('LOT-MA-240803', 'Mango 30 g', 430, 14, _ShippingStatus.reserved),
    const _FinishedLot('LOT-ST-240802', 'Strawberry 30 g', 280, 9, _ShippingStatus.loading),
  ];

  String _tx(String ar, String tr, String en) =>
      switch (widget.languageCode) {'ar' => ar, 'tr' => tr, _ => en};

  @override
  Widget build(BuildContext context) {
    final total = _lots.fold<int>(0, (sum, lot) => sum + lot.cartons);
    return Scaffold(
      appBar: AppBar(title: Text(_tx('المخزون النهائي والشحن', 'Bitmiş ürün ve sevkiyat', 'Finished goods & shipping'))),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(Icons.inventory_2_rounded, size: 36),
                  const SizedBox(width: 16),
                  Text('${_tx('إجمالي الكراتين الجاهزة', 'Toplam hazır koli', 'Total ready cartons')}: $total', style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          for (var index = 0; index < _lots.length; index++)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(18),
                title: Text('${_lots[index].lot} · ${_lots[index].product}'),
                subtitle: Text('${_lots[index].cartons} ${_tx('كرتون', 'koli', 'cartons')} · ${_lots[index].pallets} ${_tx('طبليات', 'palet', 'pallets')}'),
                trailing: DropdownButton<_ShippingStatus>(
                  value: _lots[index].status,
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _lots[index] = _lots[index].copyWith(status: value));
                  },
                  items: [
                    for (final status in _ShippingStatus.values)
                      DropdownMenuItem(value: status, child: Text(_statusLabel(status))),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _statusLabel(_ShippingStatus status) => switch (status) {
        _ShippingStatus.available => _tx('متاح', 'Mevcut', 'Available'),
        _ShippingStatus.reserved => _tx('محجوز', 'Rezerve', 'Reserved'),
        _ShippingStatus.loading => _tx('قيد التحميل', 'Yükleniyor', 'Loading'),
        _ShippingStatus.shipped => _tx('تم الشحن', 'Sevk edildi', 'Shipped'),
      };
}

enum _ShippingStatus { available, reserved, loading, shipped }

class _FinishedLot {
  const _FinishedLot(this.lot, this.product, this.cartons, this.pallets, this.status);
  final String lot;
  final String product;
  final int cartons;
  final int pallets;
  final _ShippingStatus status;

  _FinishedLot copyWith({_ShippingStatus? status}) =>
      _FinishedLot(lot, product, cartons, pallets, status ?? this.status);
}
