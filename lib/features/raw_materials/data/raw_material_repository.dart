import 'package:cloud_firestore/cloud_firestore.dart';

class RawMaterial {
  const RawMaterial({
    required this.id,
    required this.code,
    required this.name,
    required this.unit,
    required this.currentStock,
    required this.reorderLevel,
    required this.active,
  });

  final String id;
  final String code;
  final String name;
  final String unit;
  final double currentStock;
  final double reorderLevel;
  final bool active;

  bool get isLowStock => currentStock <= reorderLevel;

  factory RawMaterial.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return RawMaterial(
      id: doc.id,
      code: data['code'] as String? ?? '',
      name: data['name'] as String? ?? '',
      unit: data['unit'] as String? ?? 'kg',
      currentStock: (data['currentStock'] as num?)?.toDouble() ?? 0,
      reorderLevel: (data['reorderLevel'] as num?)?.toDouble() ?? 0,
      active: data['active'] as bool? ?? true,
    );
  }
}

class RawMaterialRepository {
  RawMaterialRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _materials =>
      _firestore.collection('rawMaterials');

  Stream<List<RawMaterial>> watchMaterials() {
    return _materials
        .where('active', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs.map(RawMaterial.fromDocument).toList());
  }

  Stream<List<RawMaterial>> watchLowStock() {
    return watchMaterials().map(
      (items) => items.where((item) => item.isLowStock).toList(),
    );
  }

  Future<String> createMaterial({
    required String code,
    required String name,
    required String unit,
    required double reorderLevel,
  }) async {
    final normalizedCode = code.trim().toUpperCase();
    final duplicate = await _materials.where('code', isEqualTo: normalizedCode).limit(1).get();
    if (duplicate.docs.isNotEmpty) {
      throw StateError('A raw material with code $normalizedCode already exists.');
    }

    final doc = _materials.doc();
    await doc.set({
      'code': normalizedCode,
      'name': name.trim(),
      'unit': unit.trim(),
      'currentStock': 0,
      'reorderLevel': reorderLevel,
      'active': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<void> archiveMaterial(String id) {
    return _materials.doc(id).update({
      'active': false,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
