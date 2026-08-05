import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  const Product({
    required this.id,
    required this.sku,
    required this.name,
    required this.brand,
    required this.category,
    required this.unit,
    required this.active,
    required this.createdAt,
  });

  final String id;
  final String sku;
  final String name;
  final String brand;
  final String category;
  final String unit;
  final bool active;
  final DateTime? createdAt;

  factory Product.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return Product(
      id: doc.id,
      sku: data['sku'] as String? ?? '',
      name: data['name'] as String? ?? '',
      brand: data['brand'] as String? ?? '',
      category: data['category'] as String? ?? '',
      unit: data['unit'] as String? ?? 'kg',
      active: data['active'] as bool? ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

class ProductRepository {
  ProductRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection('products');

  Stream<List<Product>> watchProducts({bool activeOnly = true}) {
    Query<Map<String, dynamic>> query = _products.orderBy('name');
    if (activeOnly) query = query.where('active', isEqualTo: true);
    return query.snapshots().map(
          (snapshot) => snapshot.docs.map(Product.fromDocument).toList(),
        );
  }

  Future<String> createProduct({
    required String sku,
    required String name,
    required String brand,
    required String category,
    required String unit,
  }) async {
    final normalizedSku = sku.trim().toUpperCase();
    final duplicate = await _products.where('sku', isEqualTo: normalizedSku).limit(1).get();
    if (duplicate.docs.isNotEmpty) {
      throw StateError('A product with SKU $normalizedSku already exists.');
    }

    final doc = _products.doc();
    await doc.set({
      'sku': normalizedSku,
      'name': name.trim(),
      'brand': brand.trim(),
      'category': category.trim(),
      'unit': unit.trim(),
      'active': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<void> updateProduct(String id, Map<String, dynamic> changes) {
    return _products.doc(id).update({
      ...changes,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> archiveProduct(String id) {
    return updateProduct(id, {'active': false});
  }
}
