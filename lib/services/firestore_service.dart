import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create Product
Future<void> createProduct(ProductModel product) async {
  await _firestore
      .collection('products')
      .add(product.toMap());
}

// Get Products
Future<List<ProductModel>> getProducts() async {
  final snapshot = await _firestore
      .collection('products')
      .get();

  return snapshot.docs.map((doc) {
    return ProductModel.fromMap(
        doc.id,
        doc.data(),
    );
  }).toList();
}

// Get my products
  Future<List<ProductModel>> getProductsByOwner(
      String ownerId,
      ) async {
  final snapshot = await _firestore
      .collection('products')
      .where(
    'ownerId',
    isEqualTo: ownerId,
  )
      .get();

  return snapshot.docs.map((doc) {
    return ProductModel.fromMap(doc.id, doc.data(),);
  }).toList();
  }

// Update product
Future<void> updateProduct(ProductModel product) async {
  final firestoreId = product.firestoreId;

  if(firestoreId == null || firestoreId.isEmpty) {
    throw Exception('Firestore document Id is missing');
  }
  await _firestore
      .collection('products')
      .doc(firestoreId)
      .update(product.toMap());
}

// Delete product
Future<void> deleteProduct(String firestoreId) async {
  await _firestore
      .collection('products')
      .doc(firestoreId)
      .delete();
}
}