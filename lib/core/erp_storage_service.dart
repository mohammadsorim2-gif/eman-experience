import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ErpStoredFile {
  const ErpStoredFile({required this.path, required this.downloadUrl, required this.fileName, required this.contentType, required this.size});
  final String path;
  final String downloadUrl;
  final String fileName;
  final String contentType;
  final int size;
}

class ErpStorageService {
  ErpStorageService({FirebaseStorage? storage, FirebaseFirestore? firestore})
      : storage = storage ?? FirebaseStorage.instance,
        firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseStorage storage;
  final FirebaseFirestore firestore;

  Future<ErpStoredFile> uploadProductImage({required String productId, required String fileName, required Uint8List bytes, required String contentType}) {
    return _upload(folder: 'products/$productId', entityType: 'product', entityId: productId, fileName: fileName, bytes: bytes, contentType: contentType);
  }

  Future<ErpStoredFile> uploadQualityDocument({required String batchId, required String fileName, required Uint8List bytes, required String contentType}) {
    return _upload(folder: 'quality/$batchId', entityType: 'batch', entityId: batchId, fileName: fileName, bytes: bytes, contentType: contentType);
  }

  Future<ErpStoredFile> uploadShipmentDocument({required String shipmentId, required String fileName, required Uint8List bytes, required String contentType}) {
    return _upload(folder: 'shipments/$shipmentId', entityType: 'shipment', entityId: shipmentId, fileName: fileName, bytes: bytes, contentType: contentType);
  }

  Future<ErpStoredFile> _upload({
    required String folder,
    required String entityType,
    required String entityId,
    required String fileName,
    required Uint8List bytes,
    required String contentType,
  }) async {
    final safeName = '${DateTime.now().millisecondsSinceEpoch}_${fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_')}';
    final reference = storage.ref('$folder/$safeName');
    final snapshot = await reference.putData(bytes, SettableMetadata(contentType: contentType, customMetadata: {
      'uploadedBy': FirebaseAuth.instance.currentUser?.uid ?? '',
      'entityType': entityType,
      'entityId': entityId,
    }));
    final url = await snapshot.ref.getDownloadURL();
    await firestore.collection('activityLog').add({
      'action': 'file_uploaded',
      'entityType': entityType,
      'entityId': entityId,
      'actorId': FirebaseAuth.instance.currentUser?.uid,
      'actorEmail': FirebaseAuth.instance.currentUser?.email ?? '',
      'details': {'path': snapshot.ref.fullPath, 'fileName': fileName, 'contentType': contentType, 'size': bytes.length},
      'createdAt': FieldValue.serverTimestamp(),
    });
    return ErpStoredFile(path: snapshot.ref.fullPath, downloadUrl: url, fileName: fileName, contentType: contentType, size: bytes.length);
  }

  Future<void> deleteFile({required String path, required String entityType, required String entityId}) async {
    await storage.ref(path).delete();
    await firestore.collection('activityLog').add({
      'action': 'file_deleted',
      'entityType': entityType,
      'entityId': entityId,
      'actorId': FirebaseAuth.instance.currentUser?.uid,
      'actorEmail': FirebaseAuth.instance.currentUser?.email ?? '',
      'details': {'path': path},
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
