import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  const Recipe({required this.id, required this.code, required this.name, required this.productId, required this.batchSize, required this.unit, required this.version, required this.active});
  final String id;
  final String code;
  final String name;
  final String productId;
  final double batchSize;
  final String unit;
  final int version;
  final bool active;

  factory Recipe.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return Recipe(
      id: doc.id,
      code: data['code'] as String? ?? '',
      name: data['name'] as String? ?? '',
      productId: data['productId'] as String? ?? '',
      batchSize: (data['batchSize'] as num?)?.toDouble() ?? 0,
      unit: data['unit'] as String? ?? 'kg',
      version: (data['version'] as num?)?.toInt() ?? 1,
      active: data['active'] as bool? ?? true,
    );
  }
}

class StockMovement {
  const StockMovement({required this.id, required this.materialId, required this.materialName, required this.type, required this.quantity, required this.unit, required this.reference, required this.createdAt});
  final String id;
  final String materialId;
  final String materialName;
  final String type;
  final double quantity;
  final String unit;
  final String reference;
  final DateTime? createdAt;

  factory StockMovement.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return StockMovement(
      id: doc.id,
      materialId: data['materialId'] as String? ?? '',
      materialName: data['materialName'] as String? ?? '',
      type: data['type'] as String? ?? 'receipt',
      quantity: (data['quantity'] as num?)?.toDouble() ?? 0,
      unit: data['unit'] as String? ?? 'kg',
      reference: data['reference'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

class OperationsRepository {
  OperationsRepository(this._firestore);
  final FirebaseFirestore _firestore;

  Stream<List<Recipe>> watchRecipes() => _firestore
      .collection('recipes')
      .where('active', isEqualTo: true)
      .orderBy('name')
      .snapshots()
      .map((s) => s.docs.map(Recipe.fromDocument).toList());

  Future<void> createRecipe({required String code, required String name, required String productId, required double batchSize, required String unit}) async {
    final normalized = code.trim().toUpperCase();
    final duplicate = await _firestore.collection('recipes').where('code', isEqualTo: normalized).limit(1).get();
    if (duplicate.docs.isNotEmpty) throw StateError('Recipe code already exists.');
    await _firestore.collection('recipes').add({
      'code': normalized,
      'name': name.trim(),
      'productId': productId.trim(),
      'batchSize': batchSize,
      'unit': unit.trim(),
      'version': 1,
      'active': true,
      'ingredients': <Map<String, dynamic>>[],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<StockMovement>> watchMovements() => _firestore
      .collection('stockMovements')
      .orderBy('createdAt', descending: true)
      .limit(100)
      .snapshots()
      .map((s) => s.docs.map(StockMovement.fromDocument).toList());

  Future<void> postMovement({required String materialId, required String materialName, required String type, required double quantity, required String unit, required String reference}) async {
    if (quantity <= 0) throw ArgumentError('Quantity must be greater than zero.');
    final materialRef = _firestore.collection('rawMaterials').doc(materialId);
    final movementRef = _firestore.collection('stockMovements').doc();
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(materialRef);
      if (!snapshot.exists) throw StateError('Raw material not found.');
      final current = ((snapshot.data()?['currentStock'] as num?) ?? 0).toDouble();
      final delta = type == 'issue' ? -quantity : quantity;
      final next = current + delta;
      if (next < 0) throw StateError('Insufficient stock.');
      transaction.update(materialRef, {'currentStock': next, 'updatedAt': FieldValue.serverTimestamp()});
      transaction.set(movementRef, {
        'materialId': materialId,
        'materialName': materialName,
        'type': type,
        'quantity': quantity,
        'unit': unit,
        'reference': reference.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }
}
