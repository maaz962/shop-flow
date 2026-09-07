class OrderModel {
  final String orderId;
  final String userId;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final String status;
  final DateTime createdAt;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return OrderModel(
      orderId: id,
      userId: map['userId'] ?? '',
      items: List<Map<String, dynamic>>.from(
        map['items'] ?? [],
      ),
      totalAmount:
      (map['totalAmount'] ?? 0).toDouble(),
      status: map['status'] ?? 'pending',
      createdAt:
      DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items,
      'totalAmount': totalAmount,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}