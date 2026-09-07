import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOrder(OrderModel order) async {
    await _firestore
        .collection('orders')
        .doc(order.orderId)
        .set(order.toMap());
  }

  Future<List<OrderModel>> getOrdersByUser(
      String userId,
      ) async {
    final snapshot = await _firestore
        .collection('orders')
        .where(
      'userId',
      isEqualTo: userId,
    )
        .get();

    return snapshot.docs.map((doc) {
      return OrderModel.fromMap(
        doc.id,
        doc.data(),
      );
    }).toList();
  }
}