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
}