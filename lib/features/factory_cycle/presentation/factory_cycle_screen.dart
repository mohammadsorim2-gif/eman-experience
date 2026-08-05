import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../data/factory_cycle_repository.dart';

class FactoryCycleScreen extends StatefulWidget {
  const FactoryCycleScreen({super.key, this.initialTab = 0});
  final int initialTab;

  @override
  State<FactoryCycleScreen> createState() => _FactoryCycleScreenState();
}

class _FactoryCycleScreenState extends State<FactoryCycleScreen>
    with SingleTickerProviderStateMixin {
  late final TabController tabs;
  late final FactoryCycleRepository repo;

  @override
  void initState() {
    super.initState();
    final safeIndex = widget.initialTab < 0 ? 0 : widget.initialTab > 3 ? 3 : widget.initialTab;
    tabs = TabController(length: 4, vsync: this, initialIndex: safeIndex);
    repo = FactoryCycleRepository(FirebaseFirestore.instance);
  }

  @override
  void dispose() {
    tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Factory Execution', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF173A33))),
            const SizedBox(height: 4),
            const Text('Production orders → batches → quality release → shipping', style: TextStyle(color: Color(0xFF71847F))),
            const SizedBox(height: 16),
            TabBar(controller: tabs, isScrollable: true, tabs: const [
              Tab(icon: Icon(Icons.precision_manufacturing_outlined), text: 'Production'),
              Tab(icon: Icon(Icons.qr_code_2_rounded), text: 'Batches'),
              Tab(icon: Icon(Icons.verified_outlined), text: 'Quality'),
              Tab(icon: Icon(Icons.local_shipping_outlined), text: 'Shipping'),
            ]),
          ]),
        ),
        Expanded(child: TabBarView(controller: tabs, children: [
          _Orders(repo),
          _Batches(repo),
          _Quality(repo),
          _Shipping(repo),
        ])),
      ]);
}

class _Orders extends StatelessWidget {
  const _Orders(this.repo);
  final FactoryCycleRepository repo;

  @override
  Widget build(BuildContext context) => _Workspace(
        title: 'Production Orders',
        action: FilledButton.icon(onPressed: () => _orderDialog(context, repo), icon: const Icon(Icons.add), label: const Text('New order')),
        child: StreamBuilder<List<ProductionOrder>>(
          stream: repo.watchOrders(),
          builder: (_, s) => _stream(s, 'No production orders.', (items) => ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final x = items[i];
                  return _Tile(
                    icon: Icons.assignment_outlined,
                    title: '${x.number} · ${x.productName}',
                    subtitle: '${x.quantityKg.toStringAsFixed(0)} kg · Recipe ${x.recipeId.isEmpty ? '—' : x.recipeId}',
                    status: x.status.name,
                    action: x.status == ProductionStatus.planned
                        ? FilledButton.tonal(onPressed: () => _startBatch(context, repo, x), child: const Text('Start batch'))
                        : PopupMenuButton<ProductionStatus>(onSelected: (v) => repo.setOrderStatus(x.id, v), itemBuilder: (_) => ProductionStatus.values.map((v) => PopupMenuItem(value: v, child: Text(v.name))).toList()),
                  );
                },
              )),
        ),
      );
}

class _Batches extends StatelessWidget {
  const _Batches(this.repo);
  final FactoryCycleRepository repo;

  @override
  Widget build(BuildContext context) => _Workspace(
        title: 'Batch Traceability',
        child: StreamBuilder<List<FactoryBatch>>(
          stream: repo.watchBatches(),
          builder: (_, s) => _stream(s, 'No batches created.', (items) => ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final x = items[i];
                  return _Tile(
                    icon: Icons.qr_code_2_rounded,
                    title: '${x.code} · ${x.productName}',
                    subtitle: '${x.quantityKg.toStringAsFixed(0)} kg · Order ${x.productionOrderId}',
                    status: x.status.name,
                    action: x.status == BatchStatus.inProduction ? FilledButton.tonal(onPressed: () => repo.submitBatchToQuality(x), child: const Text('Send to QC')) : const Icon(Icons.chevron_right),
                  );
                },
              )),
        ),
      );
}

class _Quality extends StatelessWidget {
  const _Quality(this.repo);
  final FactoryCycleRepository repo;

  @override
  Widget build(BuildContext context) => _Workspace(
        title: 'Quality Inspections',
        child: StreamBuilder<List<QualityInspection>>(
          stream: repo.watchInspections(),
          builder: (_, s) => _stream(s, 'No inspections.', (items) => ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final x = items[i];
                  return _Tile(
                    icon: Icons.fact_check_outlined,
                    title: 'Inspection · ${x.batchCode}',
                    subtitle: 'pH ${x.ph?.toStringAsFixed(2) ?? '—'} · Brix ${x.brix?.toStringAsFixed(2) ?? '—'}',
                    status: x.status.name,
                    action: x.status == QualityStatus.pending ? FilledButton.tonal(onPressed: () => _qualityDialog(context, repo, x), child: const Text('Inspect')) : const Icon(Icons.verified_rounded),
                  );
                },
              )),
        ),
      );
}

class _Shipping extends StatelessWidget {
  const _Shipping(this.repo);
  final FactoryCycleRepository repo;

  @override
  Widget build(BuildContext context) => _Workspace(
        title: 'Shipping Operations',
        action: FilledButton.icon(onPressed: () => _shipmentDialog(context, repo), icon: const Icon(Icons.add), label: const Text('New shipment')),
        child: StreamBuilder<List<Shipment>>(
          stream: repo.watchShipments(),
          builder: (_, s) => _stream(s, 'No shipments.', (items) => ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final x = items[i];
                  return _Tile(
                    icon: Icons.local_shipping_outlined,
                    title: '${x.number} · ${x.customer}',
                    subtitle: '${x.batchCode} · ${x.quantityKg.toStringAsFixed(0)} kg',
                    status: x.status.name,
                    action: PopupMenuButton<ShipmentStatus>(onSelected: (v) => repo.setShipmentStatus(x.id, v), itemBuilder: (_) => ShipmentStatus.values.map((v) => PopupMenuItem(value: v, child: Text(v.name))).toList()),
                  );
                },
              )),
        ),
      );
}

class _Workspace extends StatelessWidget {
  const _Workspace({required this.title, required this.child, this.action});
  final String title;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(22),
        child: Column(children: [
          Row(children: [Expanded(child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800))), if (action != null) action!]),
          const SizedBox(height: 16),
          Expanded(child: child),
        ]),
      );
}

class _Tile extends StatelessWidget {
  const _Tile({required this.icon, required this.title, required this.subtitle, required this.status, required this.action});
  final IconData icon;
  final String title;
  final String subtitle;
  final String status;
  final Widget action;

  @override
  Widget build(BuildContext context) => Card(child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(builder: (_, c) {
          final compact = c.maxWidth < 620;
          final info = Row(children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFFE6F5F0), borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: const Color(0xFF146C5A))),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(color: Color(0xFF71847F), fontSize: 13))])),
          ]);
          final end = Row(mainAxisSize: MainAxisSize.min, children: [Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: const Color(0xFFF0F4F3), borderRadius: BorderRadius.circular(99)), child: Text(status, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))), const SizedBox(width: 8), action]);
          return compact ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [info, const SizedBox(height: 12), end]) : Row(children: [Expanded(child: info), end]);
        }),
      ));
}

Widget _stream<T>(AsyncSnapshot<List<T>> s, String empty, Widget Function(List<T>) body) {
  if (s.hasError) return Center(child: Text('Unable to load data: ${s.error}'));
  if (!s.hasData) return const Center(child: CircularProgressIndicator());
  return s.data!.isEmpty ? Center(child: Text(empty)) : body(s.data!);
}

Future<void> _orderDialog(BuildContext context, FactoryCycleRepository repo) async {
  final product = TextEditingController();
  final recipe = TextEditingController();
  final quantity = TextEditingController();
  await showDialog<void>(context: context, builder: (d) => AlertDialog(
        title: const Text('New production order'),
        content: SizedBox(width: 420, child: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: product, decoration: const InputDecoration(labelText: 'Product')), const SizedBox(height: 10), TextField(controller: recipe, decoration: const InputDecoration(labelText: 'Recipe ID')), const SizedBox(height: 10), TextField(controller: quantity, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Quantity kg'))])),
        actions: [TextButton(onPressed: () => Navigator.pop(d), child: const Text('Cancel')), FilledButton(onPressed: () async { final q = double.tryParse(quantity.text); if (product.text.trim().isEmpty || q == null || q <= 0) return; await repo.createOrder(productName: product.text, recipeId: recipe.text, quantityKg: q, plannedStart: DateTime.now()); if (d.mounted) Navigator.pop(d); }, child: const Text('Create'))],
      ));
}

Future<void> _startBatch(BuildContext context, FactoryCycleRepository repo, ProductionOrder order) async {
  try {
    await repo.createBatchFromOrder(order, expiryAt: DateTime.now().add(const Duration(days: 365)));
    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Batch created.')));
  } catch (e) {
    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
  }
}

Future<void> _qualityDialog(BuildContext context, FactoryCycleRepository repo, QualityInspection inspection) async {
  final ph = TextEditingController();
  final brix = TextEditingController();
  final notes = TextEditingController();
  await showDialog<void>(context: context, builder: (d) => AlertDialog(
        title: Text('Inspect ${inspection.batchCode}'),
        content: SizedBox(width: 420, child: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: ph, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'pH')), const SizedBox(height: 10), TextField(controller: brix, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Brix')), const SizedBox(height: 10), TextField(controller: notes, maxLines: 3, decoration: const InputDecoration(labelText: 'Notes'))])),
        actions: [TextButton(onPressed: () async { await repo.completeInspection(inspection, passed: false, ph: double.tryParse(ph.text), brix: double.tryParse(brix.text), notes: notes.text); if (d.mounted) Navigator.pop(d); }, child: const Text('Reject')), FilledButton(onPressed: () async { await repo.completeInspection(inspection, passed: true, ph: double.tryParse(ph.text), brix: double.tryParse(brix.text), notes: notes.text); if (d.mounted) Navigator.pop(d); }, child: const Text('Release'))],
      ));
}

Future<void> _shipmentDialog(BuildContext context, FactoryCycleRepository repo) async {
  final customer = TextEditingController();
  final batch = TextEditingController();
  final quantity = TextEditingController();
  await showDialog<void>(context: context, builder: (d) => AlertDialog(
        title: const Text('New shipment'),
        content: SizedBox(width: 420, child: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: customer, decoration: const InputDecoration(labelText: 'Customer')), const SizedBox(height: 10), TextField(controller: batch, decoration: const InputDecoration(labelText: 'Released batch code')), const SizedBox(height: 10), TextField(controller: quantity, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Quantity kg'))])),
        actions: [TextButton(onPressed: () => Navigator.pop(d), child: const Text('Cancel')), FilledButton(onPressed: () async { final q = double.tryParse(quantity.text); if (customer.text.trim().isEmpty || batch.text.trim().isEmpty || q == null || q <= 0) return; try { await repo.createShipment(customer: customer.text, batchCode: batch.text, quantityKg: q, scheduledAt: DateTime.now()); if (d.mounted) Navigator.pop(d); } catch (e) { if (d.mounted) ScaffoldMessenger.of(d).showSnackBar(SnackBar(content: Text('$e'))); } }, child: const Text('Schedule'))],
      ));
}
