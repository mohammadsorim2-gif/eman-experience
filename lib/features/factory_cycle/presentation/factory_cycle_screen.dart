import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../data/factory_cycle_repository.dart';

class FactoryCycleScreen extends StatefulWidget {
  const FactoryCycleScreen({super.key, this.initialTab = 0});
  final int initialTab;

  @override
  State<FactoryCycleScreen> createState() => _FactoryCycleScreenState();
}

class _FactoryCycleScreenState extends State<FactoryCycleScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  late final FactoryCycleRepository _repo;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this, initialIndex: widget.initialTab.clamp(0, 3));
    _repo = FactoryCycleRepository(FirebaseFirestore.instance);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Factory Execution', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF173A33))),
          const SizedBox(height: 4),
          const Text('Production orders → batches → quality release → shipping', style: TextStyle(color: Color(0xFF71847F))),
          const SizedBox(height: 18),
          TabBar(controller: _tabs, isScrollable: true, tabs: const [
            Tab(icon: Icon(Icons.precision_manufacturing_outlined), text: 'Production Orders'),
            Tab(icon: Icon(Icons.qr_code_2_rounded), text: 'Batches'),
            Tab(icon: Icon(Icons.verified_outlined), text: 'Quality'),
            Tab(icon: Icon(Icons.local_shipping_outlined), text: 'Shipping'),
          ]),
        ]),
      ),
      Expanded(child: TabBarView(controller: _tabs, children: [
        _OrdersTab(repo: _repo),
        _BatchesTab(repo: _repo),
        _QualityTab(repo: _repo),
        _ShippingTab(repo: _repo),
      ])),
    ]);
  }
}

class _OrdersTab extends StatelessWidget {
  const _OrdersTab({required this.repo});
  final FactoryCycleRepository repo;

  @override
  Widget build(BuildContext context) => _Workspace(
    title: 'Production Orders',
    actionLabel: 'New order',
    onAction: () => _showOrderDialog(context, repo),
    child: StreamBuilder<List<ProductionOrder>>(
      stream: repo.watchOrders(),
      builder: (context, snapshot) => _buildStreamState(
        snapshot,
        empty: 'No production orders yet.',
        builder: (orders) => ListView.separated(
          itemCount: orders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, index) {
            final order = orders[index];
            return _EntityCard(
              icon: Icons.assignment_outlined,
              title: '${order.number} · ${order.productName}',
              subtitle: '${order.quantityKg.toStringAsFixed(0)} kg · Recipe ${order.recipeId.isEmpty ? 'not set' : order.recipeId}',
              status: order.status.name,
              trailing: order.status == ProductionStatus.planned
                  ? FilledButton.tonal(onPressed: () => _showBatchDialog(context, repo, order), child: const Text('Start batch'))
                  : PopupMenuButton<ProductionStatus>(
                      onSelected: (status) => repo.setOrderStatus(order.id, status),
                      itemBuilder: (_) => ProductionStatus.values.map((status) => PopupMenuItem(value: status, child: Text(status.name))).toList(),
                    ),
            );
          },
        ),
      ),
    ),
  );
}

class _BatchesTab extends StatelessWidget {
  const _BatchesTab({required this.repo});
  final FactoryCycleRepository repo;

  @override
  Widget build(BuildContext context) => _Workspace(
    title: 'Batch Traceability',
    child: StreamBuilder<List<FactoryBatch>>(
      stream: repo.watchBatches(),
      builder: (context, snapshot) => _buildStreamState(
        snapshot,
        empty: 'No batches have been created.',
        builder: (items) => ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, index) {
            final batch = items[index];
            return _EntityCard(
              icon: Icons.qr_code_2_rounded,
              title: '${batch.code} · ${batch.productName}',
              subtitle: '${batch.quantityKg.toStringAsFixed(0)} kg · Order ${batch.productionOrderId}',
              status: batch.status.name,
              trailing: batch.status == BatchStatus.inProduction
                  ? FilledButton.tonal(onPressed: () => repo.submitBatchToQuality(batch), child: const Text('Send to QC'))
                  : const Icon(Icons.chevron_right_rounded),
            );
          },
        ),
      ),
    ),
  );
}

class _QualityTab extends StatelessWidget {
  const _QualityTab({required this.repo});
  final FactoryCycleRepository repo;

  @override
  Widget build(BuildContext context) => _Workspace(
    title: 'Quality Inspections',
    child: StreamBuilder<List<QualityInspection>>(
      stream: repo.watchInspections(),
      builder: (context, snapshot) => _buildStreamState(
        snapshot,
        empty: 'No quality inspections pending.',
        builder: (items) => ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, index) {
            final item = items[index];
            return _EntityCard(
              icon: Icons.fact_check_outlined,
              title: 'Inspection · ${item.batchCode}',
              subtitle: 'pH ${item.ph?.toStringAsFixed(2) ?? '—'} · Brix ${item.brix?.toStringAsFixed(2) ?? '—'}',
              status: item.status.name,
              trailing: item.status == QualityStatus.pending
                  ? FilledButton.tonal(onPressed: () => _showInspectionDialog(context, repo, item), child: const Text('Inspect'))
                  : const Icon(Icons.verified_rounded),
            );
          },
        ),
      ),
    ),
  );
}

class _ShippingTab extends StatelessWidget {
  const _ShippingTab({required this.repo});
  final FactoryCycleRepository repo;

  @override
  Widget build(BuildContext context) => _Workspace(
    title: 'Shipping Operations',
    actionLabel: 'New shipment',
    onAction: () => _showShipmentDialog(context, repo),
    child: StreamBuilder<List<Shipment>>(
      stream: repo.watchShipments(),
      builder: (context, snapshot) => _buildStreamState(
        snapshot,
        empty: 'No shipments scheduled.',
        builder: (items) => ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, index) {
            final item = items[index];
            return _EntityCard(
              icon: Icons.local_shipping_outlined,
              title: '${item.number} · ${item.customer}',
              subtitle: '${item.batchCode} · ${item.quantityKg.toStringAsFixed(0)} kg',
              status: item.status.name,
              trailing: PopupMenuButton<ShipmentStatus>(
                onSelected: (status) => repo.setShipmentStatus(item.id, status),
                itemBuilder: (_) => ShipmentStatus.values.map((status) => PopupMenuItem(value: status, child: Text(status.name))).toList(),
              ),
            );
          },
        ),
      ),
    ),
  );
}

class _Workspace extends StatelessWidget {
  const _Workspace({required this.title, required this.child, this.actionLabel, this.onAction});
  final String title;
  final Widget child;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(22),
    child: Column(children: [
      Row(children: [
        Expanded(child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800))),
        if (onAction != null) FilledButton.icon(onPressed: onAction, icon: const Icon(Icons.add_rounded), label: Text(actionLabel!)),
      ]),
      const SizedBox(height: 16),
      Expanded(child: child),
    ]),
  );
}

class _EntityCard extends StatelessWidget {
  const _EntityCard({required this.icon, required this.title, required this.subtitle, required this.status, required this.trailing});
  final IconData icon;
  final String title;
  final String subtitle;
  final String status;
  final Widget trailing;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(children: [
        Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFFE6F5F0), borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: const Color(0xFF146C5A))),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Color(0xFF71847F), fontSize: 13)),
        ])),
        Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: const Color(0xFFF0F4F3), borderRadius: BorderRadius.circular(99)), child: Text(status, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
        const SizedBox(width: 10),
        trailing,
      ]),
    ),
  );
}

Widget _buildStreamState<T>(AsyncSnapshot<List<T>> snapshot, {required String empty, required Widget Function(List<T>) builder}) {
  if (snapshot.hasError) return Center(child: Text('Unable to load data: ${snapshot.error}'));
  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
  if (snapshot.data!.isEmpty) return Center(child: Text(empty));
  return builder(snapshot.data!);
}

Future<void> _showOrderDialog(BuildContext context, FactoryCycleRepository repo) async {
  final product = TextEditingController();
  final recipe = TextEditingController();
  final quantity = TextEditingController();
  await showDialog<void>(context: context, builder: (dialogContext) => AlertDialog(
    title: const Text('New production order'),
    content: SizedBox(width: 430, child: Column(mainAxisSize: MainAxisSize.min, children: [
      TextField(controller: product, decoration: const InputDecoration(labelText: 'Product name')),
      const SizedBox(height: 12),
      TextField(controller: recipe, decoration: const InputDecoration(labelText: 'Recipe ID')),
      const SizedBox(height: 12),
      TextField(controller: quantity, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Quantity kg')),
    ])),
    actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')), FilledButton(onPressed: () async {
      final value = double.tryParse(quantity.text);
      if (product.text.trim().isEmpty || value == null || value <= 0) return;
      await repo.createOrder(productName: product.text, recipeId: recipe.text, quantityKg: value, plannedStart: DateTime.now());
      if (dialogContext.mounted) Navigator.pop(dialogContext);
    }, child: const Text('Create'))],
  ));
}

Future<void> _showBatchDialog(BuildContext context, FactoryCycleRepository repo, ProductionOrder order) async {
  final expiry = DateTime.now().add(const Duration(days: 365));
  try {
    await repo.createBatchFromOrder(order, expiryAt: expiry);
    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Batch created and production started.')));
  } catch (error) {
    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error')));
  }
}

Future<void> _showInspectionDialog(BuildContext context, FactoryCycleRepository repo, QualityInspection inspection) async {
  final ph = TextEditingController();
  final brix = TextEditingController();
  final notes = TextEditingController();
  await showDialog<void>(context: context, builder: (dialogContext) => AlertDialog(
    title: Text('Inspect ${inspection.batchCode}'),
    content: SizedBox(width: 430, child: Column(mainAxisSize: MainAxisSize.min, children: [
      TextField(controller: ph, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'pH')),
      const SizedBox(height: 12),
      TextField(controller: brix, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Brix')),
      const SizedBox(height: 12),
      TextField(controller: notes, maxLines: 3, decoration: const InputDecoration(labelText: 'Notes')),
    ])),
    actions: [
      TextButton(onPressed: () async { await repo.completeInspection(inspection, passed: false, ph: double.tryParse(ph.text), brix: double.tryParse(brix.text), notes: notes.text); if (dialogContext.mounted) Navigator.pop(dialogContext); }, child: const Text('Reject')),
      FilledButton(onPressed: () async { await repo.completeInspection(inspection, passed: true, ph: double.tryParse(ph.text), brix: double.tryParse(brix.text), notes: notes.text); if (dialogContext.mounted) Navigator.pop(dialogContext); }, child: const Text('Release')),
    ],
  ));
}

Future<void> _showShipmentDialog(BuildContext context, FactoryCycleRepository repo) async {
  final customer = TextEditingController();
  final batch = TextEditingController();
  final quantity = TextEditingController();
  await showDialog<void>(context: context, builder: (dialogContext) => AlertDialog(
    title: const Text('New shipment'),
    content: SizedBox(width: 430, child: Column(mainAxisSize: MainAxisSize.min, children: [
      TextField(controller: customer, decoration: const InputDecoration(labelText: 'Customer')),
      const SizedBox(height: 12),
      TextField(controller: batch, decoration: const InputDecoration(labelText: 'Released batch code')),
      const SizedBox(height: 12),
      TextField(controller: quantity, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Quantity kg')),
    ])),
    actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')), FilledButton(onPressed: () async {
      final value = double.tryParse(quantity.text);
      if (customer.text.trim().isEmpty || batch.text.trim().isEmpty || value == null || value <= 0) return;
      try {
        await repo.createShipment(customer: customer.text, batchCode: batch.text, quantityKg: value, scheduledAt: DateTime.now());
        if (dialogContext.mounted) Navigator.pop(dialogContext);
      } catch (error) {
        if (dialogContext.mounted) ScaffoldMessenger.of(dialogContext).showSnackBar(SnackBar(content: Text('$error')));
      }
    }, child: const Text('Schedule'))],
  ));
}
