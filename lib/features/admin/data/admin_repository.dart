import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ErpUserProfile {
  const ErpUserProfile({
    required this.id,
    required this.email,
    required this.displayName,
    required this.role,
    required this.department,
    required this.active,
  });

  final String id;
  final String email;
  final String displayName;
  final String role;
  final String department;
  final bool active;

  factory ErpUserProfile.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return ErpUserProfile(
      id: doc.id,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? '',
      role: data['role'] as String? ?? 'viewer',
      department: data['department'] as String? ?? 'unassigned',
      active: data['active'] as bool? ?? false,
    );
  }
}

class AuditEntry {
  const AuditEntry({required this.id, required this.action, required this.entityType, required this.entityId, required this.actorEmail, required this.createdAt, required this.details});
  final String id;
  final String action;
  final String entityType;
  final String entityId;
  final String actorEmail;
  final DateTime? createdAt;
  final Map<String, dynamic> details;

  factory AuditEntry.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return AuditEntry(
      id: doc.id,
      action: data['action'] as String? ?? '',
      entityType: data['entityType'] as String? ?? '',
      entityId: data['entityId'] as String? ?? '',
      actorEmail: data['actorEmail'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      details: Map<String, dynamic>.from(data['details'] as Map? ?? const {}),
    );
  }
}

class AdminRepository {
  AdminRepository(this.firestore);
  final FirebaseFirestore firestore;

  static const roles = <String>[
    'owner',
    'admin',
    'general_manager',
    'production_manager',
    'warehouse_manager',
    'quality_manager',
    'shipping_manager',
    'viewer',
  ];

  static const departments = <String>[
    'management',
    'production',
    'warehouse',
    'quality',
    'shipping',
    'sales',
    'accounting',
    'maintenance',
    'unassigned',
  ];

  Stream<List<ErpUserProfile>> watchUsers() => firestore
      .collection('users')
      .orderBy('displayName')
      .snapshots()
      .map((event) => event.docs.map(ErpUserProfile.fromDoc).toList());

  Stream<List<AuditEntry>> watchAudit({int limit = 100}) => firestore
      .collection('activityLog')
      .orderBy('createdAt', descending: true)
      .limit(limit)
      .snapshots()
      .map((event) => event.docs.map(AuditEntry.fromDoc).toList());

  Future<void> updateUser({required ErpUserProfile user, required String role, required String department, required bool active}) async {
    final before = {'role': user.role, 'department': user.department, 'active': user.active};
    final after = {'role': role, 'department': department, 'active': active};
    final batch = firestore.batch();
    batch.update(firestore.collection('users').doc(user.id), {
      ...after,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': FirebaseAuth.instance.currentUser?.uid,
    });
    final audit = firestore.collection('activityLog').doc();
    batch.set(audit, auditPayload(
      action: 'user_access_updated',
      entityType: 'user',
      entityId: user.id,
      details: {'before': before, 'after': after, 'targetEmail': user.email},
    ));
    await batch.commit();
  }

  Map<String, dynamic> auditPayload({required String action, required String entityType, required String entityId, Map<String, dynamic> details = const {}}) {
    final actor = FirebaseAuth.instance.currentUser;
    return {
      'action': action,
      'entityType': entityType,
      'entityId': entityId,
      'actorId': actor?.uid,
      'actorEmail': actor?.email ?? '',
      'details': details,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  Future<void> log({required String action, required String entityType, required String entityId, Map<String, dynamic> details = const {}}) {
    return firestore.collection('activityLog').add(auditPayload(action: action, entityType: entityType, entityId: entityId, details: details));
  }
}
