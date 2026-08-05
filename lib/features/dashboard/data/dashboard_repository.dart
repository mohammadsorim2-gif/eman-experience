import 'package:cloud_firestore/cloud_firestore.dart';

import 'dashboard_models.dart';

class DashboardRepository {
  DashboardRepository(this._firestore);

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> get _summaryRef =>
      _firestore.collection('dashboard').doc('summary');

  Stream<DashboardSnapshot> watchSummary() {
    return _summaryRef.snapshots().map((doc) {
      final data = doc.data();
      return data == null ? DashboardSnapshot.empty : DashboardSnapshot.fromMap(data);
    });
  }

  Stream<List<FactoryAlert>> watchOpenAlerts({int limit = 8}) {
    return _firestore
        .collection('factoryAlerts')
        .where('resolved', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(FactoryAlert.fromDocument).toList());
  }

  Stream<List<ActivityEvent>> watchRecentActivity({int limit = 10}) {
    return _firestore
        .collection('activityLog')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(ActivityEvent.fromDocument).toList());
  }

  Future<void> seedDashboardIfMissing() async {
    final summary = await _summaryRef.get();
    if (summary.exists) return;

    final batch = _firestore.batch();
    batch.set(_summaryRef, {
      'todayProductionKg': 0,
      'activeOrders': 0,
      'inventoryValue': 0,
      'lowStockItems': 0,
      'pendingQc': 0,
      'todayShipments': 0,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    batch.set(_firestore.collection('system').doc('factory'), {
      'name': 'Eman Experience',
      'industry': 'Instant beverage manufacturing',
      'status': 'active',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await batch.commit();
  }
}
