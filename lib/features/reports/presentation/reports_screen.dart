import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('productionOrders').snapshots(),
        builder: (context, ordersSnapshot) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('batches').snapshots(),
          builder: (context, batchesSnapshot) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('qualityInspections').snapshots(),
            builder: (context, qualitySnapshot) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('shipments').snapshots(),
              builder: (context, shipmentSnapshot) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('rawMaterials').snapshots(),
                builder: (context, materialsSnapshot) {
                  final loading = !ordersSnapshot.hasData || !batchesSnapshot.hasData || !qualitySnapshot.hasData || !shipmentSnapshot.hasData || !materialsSnapshot.hasData;
                  if (loading) return const Center(child: CircularProgressIndicator());
                  final orders = ordersSnapshot.data!.docs;
                  final batches = batchesSnapshot.data!.docs;
                  final quality = qualitySnapshot.data!.docs;
                  final shipments = shipmentSnapshot.data!.docs;
                  final materials = materialsSnapshot.data!.docs;

                  double productionKg = 0;
                  for (final doc in batches) {
                    if (doc.data()['status'] == 'released') productionKg += (doc.data()['quantityKg'] as num?)?.toDouble() ?? 0;
                  }
                  final completedOrders = orders.where((doc) => doc.data()['status'] == 'completed').length;
                  final passedQc = quality.where((doc) => doc.data()['status'] == 'passed').length;
                  final failedQc = quality.where((doc) => doc.data()['status'] == 'failed').length;
                  final qualityTotal = passedQc + failedQc;
                  final passRate = qualityTotal == 0 ? 0.0 : (passedQc / qualityTotal) * 100;
                  final delivered = shipments.where((doc) => doc.data()['status'] == 'delivered').length;
                  final lowStock = materials.where((doc) {
                    final data = doc.data();
                    final current = (data['currentStock'] as num?)?.toDouble() ?? 0;
                    final reorder = (data['reorderLevel'] as num?)?.toDouble() ?? 0;
                    return current <= reorder;
                  }).length;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Executive Reports', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF173A33))),
                      const SizedBox(height: 5),
                      const Text('Live operational performance calculated from Firestore.', style: TextStyle(color: Color(0xFF71847F))),
                      const SizedBox(height: 22),
                      LayoutBuilder(builder: (_, constraints) {
                        final count = constraints.maxWidth >= 1250 ? 4 : constraints.maxWidth >= 700 ? 2 : 1;
                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: count,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: count == 1 ? 2.6 : 1.8,
                          children: [
                            _MetricCard(label: 'Released production', value: '${productionKg.toStringAsFixed(0)} kg', icon: Icons.precision_manufacturing_outlined),
                            _MetricCard(label: 'Completed orders', value: '$completedOrders', icon: Icons.task_alt_outlined),
                            _MetricCard(label: 'Quality pass rate', value: '${passRate.toStringAsFixed(1)}%', icon: Icons.verified_outlined),
                            _MetricCard(label: 'Delivered shipments', value: '$delivered', icon: Icons.local_shipping_outlined),
                          ],
                        );
                      }),
                      const SizedBox(height: 20),
                      LayoutBuilder(builder: (_, constraints) {
                        final stacked = constraints.maxWidth < 900;
                        final production = _ReportPanel(
                          title: 'Production pipeline',
                          child: Column(children: [
                            _ProgressRow(label: 'Draft', value: _count(orders, 'draft'), total: orders.length),
                            _ProgressRow(label: 'Planned', value: _count(orders, 'planned'), total: orders.length),
                            _ProgressRow(label: 'Running', value: _count(orders, 'running'), total: orders.length),
                            _ProgressRow(label: 'Completed', value: completedOrders, total: orders.length),
                          ]),
                        );
                        final qualityPanel = _ReportPanel(
                          title: 'Quality performance',
                          child: Column(children: [
                            _ProgressRow(label: 'Pending', value: _count(quality, 'pending'), total: quality.length),
                            _ProgressRow(label: 'Passed', value: passedQc, total: quality.length),
                            _ProgressRow(label: 'Failed', value: failedQc, total: quality.length),
                            const SizedBox(height: 8),
                            _AlertLine(icon: Icons.inventory_2_outlined, label: 'Low-stock materials', value: '$lowStock'),
                          ]),
                        );
                        return stacked ? Column(children: [production, const SizedBox(height: 16), qualityPanel]) : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: production), const SizedBox(width: 16), Expanded(child: qualityPanel)]);
                      }),
                      const SizedBox(height: 20),
                      _ReportPanel(
                        title: 'Shipping status',
                        child: Wrap(spacing: 12, runSpacing: 12, children: [
                          for (final status in const ['planned', 'loading', 'dispatched', 'delivered', 'cancelled'])
                            _StatusBox(label: status, value: _count(shipments, status)),
                        ]),
                      ),
                    ]),
                  );
                },
              ),
            ),
          ),
        ),
      );

  static int _count(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs, String status) => docs.where((doc) => doc.data()['status'] == status).length;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(18), child: Row(children: [
        Container(width: 48, height: 48, decoration: BoxDecoration(color: const Color(0xFFE5F5F0), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: const Color(0xFF146C5A))),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)), Text(label, style: const TextStyle(color: Color(0xFF71847F)))])),
      ])));
}

class _ReportPanel extends StatelessWidget {
  const _ReportPanel({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)), const SizedBox(height: 18), child])));
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({required this.label, required this.value, required this.total});
  final String label;
  final int value;
  final int total;

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : value / total;
    return Padding(padding: const EdgeInsets.only(bottom: 14), child: Column(children: [
      Row(children: [Expanded(child: Text(label)), Text('$value / $total', style: const TextStyle(fontWeight: FontWeight.w800))]),
      const SizedBox(height: 7),
      LinearProgressIndicator(value: ratio, minHeight: 8, borderRadius: BorderRadius.circular(20)),
    ]));
  }
}

class _AlertLine extends StatelessWidget {
  const _AlertLine({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFFFF7E7), borderRadius: BorderRadius.circular(12)), child: Row(children: [Icon(icon, color: const Color(0xFFE48535)), const SizedBox(width: 10), Expanded(child: Text(label)), Text(value, style: const TextStyle(fontWeight: FontWeight.w900))]));
}

class _StatusBox extends StatelessWidget {
  const _StatusBox({required this.label, required this.value});
  final String label;
  final int value;
  @override
  Widget build(BuildContext context) => Container(width: 150, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFF4F7F6), borderRadius: BorderRadius.circular(14)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('$value', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text(label, style: const TextStyle(color: Color(0xFF71847F)))]));
}
