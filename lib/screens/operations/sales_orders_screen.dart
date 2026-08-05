import 'package:flutter/material.dart';

class SalesOrdersScreen extends StatefulWidget {
  const SalesOrdersScreen({required this.languageCode, super.key});

  final String languageCode;

  @override
  State<SalesOrdersScreen> createState() => _SalesOrdersScreenState();
}

class _SalesOrdersScreenState extends State<SalesOrdersScreen> {
  final _orders = <_SalesOrder>[
    const _SalesOrder('SO-24081', 'Anatolia Foods', 'Orange 30 g', 420, _OrderStatus.production),
    const _SalesOrder('SO-24082', 'Levant Trading', 'Mango 30 g', 260, _OrderStatus.approved),
    const _SalesOrder('SO-24083', 'Global Market', 'Strawberry 30 g', 180, _OrderStatus.ready),
  ];

  String _tx(String ar, String tr, String en) =>
      switch (widget.languageCode) {'ar' => ar, 'tr' => tr, _ => en};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_tx('طلبات المبيعات', 'Satış siparişleri', 'Sales orders'))),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          final order = _orders[index];
          final color = switch (order.status) {
            _OrderStatus.approved => Colors.blue,
            _OrderStatus.production => Colors.orange,
            _OrderStatus.ready => Colors.green,
            _OrderStatus.shipped => Colors.teal,
          };
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(18),
              leading: CircleAvatar(
                backgroundColor: color.withValues(alpha: .15),
                child: Icon(Icons.receipt_long_rounded, color: color),
              ),
              title: Text('${order.number} · ${order.customer}'),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text('${order.product} · ${order.cartons} ${_tx('كرتون', 'koli', 'cartons')}'),
              ),
              trailing: PopupMenuButton<_OrderStatus>(
                initialValue: order.status,
                onSelected: (status) => setState(() => _orders[index] = order.copyWith(status: status)),
                itemBuilder: (_) => [
                  for (final status in _OrderStatus.values)
                    PopupMenuItem(value: status, child: Text(_statusLabel(status))),
                ],
                child: Chip(
                  label: Text(_statusLabel(order.status)),
                  side: BorderSide(color: color.withValues(alpha: .35)),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => setState(() => _orders.add(const _SalesOrder('SO-NEW', 'New customer', 'Orange 30 g', 100, _OrderStatus.approved))),
        icon: const Icon(Icons.add_rounded),
        label: Text(_tx('طلب جديد', 'Yeni sipariş', 'New order')),
      ),
    );
  }

  String _statusLabel(_OrderStatus status) => switch (status) {
        _OrderStatus.approved => _tx('معتمد', 'Onaylandı', 'Approved'),
        _OrderStatus.production => _tx('قيد الإنتاج', 'Üretimde', 'In production'),
        _OrderStatus.ready => _tx('جاهز', 'Hazır', 'Ready'),
        _OrderStatus.shipped => _tx('تم الشحن', 'Sevk edildi', 'Shipped'),
      };
}

enum _OrderStatus { approved, production, ready, shipped }

class _SalesOrder {
  const _SalesOrder(this.number, this.customer, this.product, this.cartons, this.status);
  final String number;
  final String customer;
  final String product;
  final int cartons;
  final _OrderStatus status;

  _SalesOrder copyWith({_OrderStatus? status}) =>
      _SalesOrder(number, customer, product, cartons, status ?? this.status);
}
