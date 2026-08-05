import 'package:cloud_firestore/cloud_firestore.dart';

enum ProductionStatus { draft, planned, running, completed, cancelled }
enum BatchStatus { created, inProduction, awaitingQuality, released, rejected }
enum QualityStatus { pending, passed, failed }
enum ShipmentStatus { planned, loading, dispatched, delivered, cancelled }

class ProductionOrder {
  const ProductionOrder({required this.id, required this.number, required this.productName, required this.recipeId, required this.quantityKg, required this.status, required this.plannedStart});
  final String id;
  final String number;
  final String productName;
  final String recipeId;
  final double quantityKg;
  final ProductionStatus status;
  final DateTime? plannedStart;

  factory ProductionOrder.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return ProductionOrder(
      id: doc.id,
      number: data['number'] as String? ?? doc.id,
      productName: data['productName'] as String? ?? '',
      recipeId: data['recipeId'] as String? ?? '',
      quantityKg: (data['quantityKg'] as num?)?.toDouble() ?? 0,
      status: ProductionStatus.values.firstWhere((e) => e.name == data['status'], orElse: () => ProductionStatus.draft),
      plannedStart: (data['plannedStart'] as Timestamp?)?.toDate(),
    );
  }
}

class FactoryBatch {
  const FactoryBatch({required this.id, required this.code, required this.productionOrderId, required this.productName, required this.quantityKg, required this.status, required this.manufacturedAt, required this.expiryAt});
  final String id;
  final String code;
  final String productionOrderId;
  final String productName;
  final double quantityKg;
  final BatchStatus status;
  final DateTime? manufacturedAt;
  final DateTime? expiryAt;

  factory FactoryBatch.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return FactoryBatch(
      id: doc.id,
      code: data['code'] as String? ?? doc.id,
      productionOrderId: data['productionOrderId'] as String? ?? '',
      productName: data['productName'] as String? ?? '',
      quantityKg: (data['quantityKg'] as num?)?.toDouble() ?? 0,
      status: BatchStatus.values.firstWhere((e) => e.name == data['status'], orElse: () => BatchStatus.created),
      manufacturedAt: (data['manufacturedAt'] as Timestamp?)?.toDate(),
      expiryAt: (data['expiryAt'] as Timestamp?)?.toDate(),
    );
  }
}

class QualityInspection {
  const QualityInspection({required this.id, required this.batchId, required this.batchCode, required this.status, required this.ph, required this.brix, required this.notes, required this.createdAt});
  final String id;
  final String batchId;
  final String batchCode;
  final QualityStatus status;
  final double? ph;
  final double? brix;
  final String notes;
  final DateTime? createdAt;

  factory QualityInspection.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return QualityInspection(
      id: doc.id,
      batchId: data['batchId'] as String? ?? '',
      batchCode: data['batchCode'] as String? ?? '',
      status: QualityStatus.values.firstWhere((e) => e.name == data['status'], orElse: () => QualityStatus.pending),
      ph: (data['ph'] as num?)?.toDouble(),
      brix: (data['brix'] as num?)?.toDouble(),
      notes: data['notes'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

class Shipment {
  const Shipment({required this.id, required this.number, required this.customer, required this.batchCode, required this.quantityKg, required this.status, required this.scheduledAt});
  final String id;
  final String number;
  final String customer;
  final String batchCode;
  final double quantityKg;
  final ShipmentStatus status;
  final DateTime? scheduledAt;

  factory Shipment.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return Shipment(
      id: doc.id,
      number: data['number'] as String? ?? doc.id,
      customer: data['customer'] as String? ?? '',
      batchCode: data['batchCode'] as String? ?? '',
      quantityKg: (data['quantityKg'] as num?)?.toDouble() ?? 0,
      status: ShipmentStatus.values.firstWhere((e) => e.name == data['status'], orElse: () => ShipmentStatus.planned),
      scheduledAt: (data['scheduledAt'] as Timestamp?)?.toDate(),
    );
  }
}

class FactoryCycleRepository {
  FactoryCycleRepository(this._db);
  final FirebaseFirestore _db;

  Stream<List<ProductionOrder>> watchOrders() => _db.collection('productionOrders').orderBy('plannedStart', descending: true).snapshots().map((s) => s.docs.map(ProductionOrder.fromDoc).toList());
  Stream<List<FactoryBatch>> watchBatches() => _db.collection('batches').orderBy('manufacturedAt', descending: true).snapshots().map((s) => s.docs.map(FactoryBatch.fromDoc).toList());
  Stream<List<QualityInspection>> watchInspections() => _db.collection('qualityInspections').orderBy('createdAt', descending: true).snapshots().map((s) => s.docs.map(QualityInspection.fromDoc).toList());
  Stream<List<Shipment>> watchShipments() => _db.collection('shipments').orderBy('scheduledAt', descending: true).snapshots().map((s) => s.docs.map(Shipment.fromDoc).toList());

  Future<String> createOrder({required String productName, required String recipeId, required double quantityKg, required DateTime plannedStart}) async {
    final ref = _db.collection('productionOrders').doc();
    final number = 'PO-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    await ref.set({'number': number, 'productName': productName.trim(), 'recipeId': recipeId.trim(), 'quantityKg': quantityKg, 'status': ProductionStatus.planned.name, 'plannedStart': Timestamp.fromDate(plannedStart), 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()});
    return ref.id;
  }

  Future<void> setOrderStatus(String id, ProductionStatus status) => _db.collection('productionOrders').doc(id).update({'status': status.name, 'updatedAt': FieldValue.serverTimestamp()});

  Future<String> createBatchFromOrder(ProductionOrder order, {required DateTime expiryAt}) async {
    final batch = _db.collection('batches').doc();
    final code = 'BAT-${DateTime.now().millisecondsSinceEpoch.toString().substring(4)}';
    final batchWrite = _db.batch();
    batchWrite.set(batch, {'code': code, 'productionOrderId': order.id, 'productName': order.productName, 'quantityKg': order.quantityKg, 'status': BatchStatus.inProduction.name, 'manufacturedAt': FieldValue.serverTimestamp(), 'expiryAt': Timestamp.fromDate(expiryAt), 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()});
    batchWrite.update(_db.collection('productionOrders').doc(order.id), {'status': ProductionStatus.running.name, 'updatedAt': FieldValue.serverTimestamp()});
    await batchWrite.commit();
    return batch.id;
  }

  Future<void> submitBatchToQuality(FactoryBatch batch) async {
    final inspection = _db.collection('qualityInspections').doc();
    final write = _db.batch();
    write.set(inspection, {'batchId': batch.id, 'batchCode': batch.code, 'status': QualityStatus.pending.name, 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()});
    write.update(_db.collection('batches').doc(batch.id), {'status': BatchStatus.awaitingQuality.name, 'updatedAt': FieldValue.serverTimestamp()});
    await write.commit();
  }

  Future<void> completeInspection(QualityInspection inspection, {required bool passed, double? ph, double? brix, String notes = ''}) async {
    final status = passed ? QualityStatus.passed : QualityStatus.failed;
    final batchStatus = passed ? BatchStatus.released : BatchStatus.rejected;
    final write = _db.batch();
    write.update(_db.collection('qualityInspections').doc(inspection.id), {'status': status.name, 'ph': ph, 'brix': brix, 'notes': notes.trim(), 'completedAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()});
    write.update(_db.collection('batches').doc(inspection.batchId), {'status': batchStatus.name, 'qualityReleasedAt': passed ? FieldValue.serverTimestamp() : null, 'updatedAt': FieldValue.serverTimestamp()});
    await write.commit();
  }

  Future<String> createShipment({required String customer, required String batchCode, required double quantityKg, required DateTime scheduledAt}) async {
    final released = await _db.collection('batches').where('code', isEqualTo: batchCode.trim().toUpperCase()).where('status', isEqualTo: BatchStatus.released.name).limit(1).get();
    if (released.docs.isEmpty) throw StateError('Only quality-released batches can be shipped.');
    final batch = released.docs.first.data();
    final available = (batch['quantityKg'] as num?)?.toDouble() ?? 0;
    if (quantityKg > available) throw StateError('Shipment quantity exceeds released batch quantity.');
    final ref = _db.collection('shipments').doc();
    final number = 'SHP-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    await ref.set({'number': number, 'customer': customer.trim(), 'batchId': released.docs.first.id, 'batchCode': batchCode.trim().toUpperCase(), 'quantityKg': quantityKg, 'status': ShipmentStatus.planned.name, 'scheduledAt': Timestamp.fromDate(scheduledAt), 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()});
    return ref.id;
  }

  Future<void> setShipmentStatus(String id, ShipmentStatus status) => _db.collection('shipments').doc(id).update({'status': status.name, 'updatedAt': FieldValue.serverTimestamp()});
}
