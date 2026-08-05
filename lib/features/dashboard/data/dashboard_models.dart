import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardSnapshot {
  const DashboardSnapshot({
    required this.todayProductionKg,
    required this.activeOrders,
    required this.inventoryValue,
    required this.lowStockItems,
    required this.pendingQc,
    required this.todayShipments,
    required this.updatedAt,
  });

  final double todayProductionKg;
  final int activeOrders;
  final double inventoryValue;
  final int lowStockItems;
  final int pendingQc;
  final int todayShipments;
  final DateTime? updatedAt;

  factory DashboardSnapshot.fromMap(Map<String, dynamic> map) {
    return DashboardSnapshot(
      todayProductionKg: (map['todayProductionKg'] as num?)?.toDouble() ?? 0,
      activeOrders: (map['activeOrders'] as num?)?.toInt() ?? 0,
      inventoryValue: (map['inventoryValue'] as num?)?.toDouble() ?? 0,
      lowStockItems: (map['lowStockItems'] as num?)?.toInt() ?? 0,
      pendingQc: (map['pendingQc'] as num?)?.toInt() ?? 0,
      todayShipments: (map['todayShipments'] as num?)?.toInt() ?? 0,
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  static const empty = DashboardSnapshot(
    todayProductionKg: 0,
    activeOrders: 0,
    inventoryValue: 0,
    lowStockItems: 0,
    pendingQc: 0,
    todayShipments: 0,
    updatedAt: null,
  );
}

class FactoryAlert {
  const FactoryAlert({
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
    required this.createdAt,
    required this.resolved,
  });

  final String id;
  final String title;
  final String message;
  final String severity;
  final DateTime? createdAt;
  final bool resolved;

  factory FactoryAlert.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? const <String, dynamic>{};
    return FactoryAlert(
      id: doc.id,
      title: map['title'] as String? ?? 'Factory alert',
      message: map['message'] as String? ?? '',
      severity: map['severity'] as String? ?? 'info',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      resolved: map['resolved'] as bool? ?? false,
    );
  }
}

class ActivityEvent {
  const ActivityEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.module,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final String module;
  final DateTime? createdAt;

  factory ActivityEvent.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? const <String, dynamic>{};
    return ActivityEvent(
      id: doc.id,
      title: map['title'] as String? ?? 'Activity',
      description: map['description'] as String? ?? '',
      module: map['module'] as String? ?? 'general',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
