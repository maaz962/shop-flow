class OrderModel {
  final String orderId;
  final String userId;
  final List<String> sellerIds;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final String status;
  final DateTime createdAt;
  final Map<String, dynamic> deliveryAddress;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.sellerIds,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.deliveryAddress,
  });

  factory OrderModel.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return OrderModel(
      orderId: id,
      userId: map['userId'] ?? '',
      sellerIds: List<String>.from(
        map['sellerIds'] ?? [],
      ),
      items: List<Map<String, dynamic>>.from(
        map['items'] ?? [],
      ),
      totalAmount:
      (map['totalAmount'] ?? 0).toDouble(),
      status: map['status'] ?? 'pending',
      createdAt: DateTime.parse(
        map['createdAt']),
        deliveryAddress:
        Map<String, dynamic>.from(map['deliveryAddress'] ?? {}),
      );

  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'sellerIds': sellerIds,
      'items': items,
      'totalAmount': totalAmount,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'deliveryAddress': deliveryAddress,
    };
  }

  OrderModel copyWith({
    String? status,
  }) {
    return OrderModel(
      orderId: orderId,
      userId: userId,
      sellerIds: sellerIds,
      items: items,
      totalAmount: totalAmount,
      status: status ?? this.status,
      createdAt: createdAt,
        deliveryAddress: deliveryAddress,
    );
  }
}