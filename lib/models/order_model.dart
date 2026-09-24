class OrderModel {
  final String orderId;
  final String userId;
  final List<String> sellerIds;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final String orderStatus;
  final String paymentStatus;
  final DateTime createdAt;
  final Map<String, dynamic> deliveryAddress;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.sellerIds,
    required this.items,
    required this.totalAmount,
    // Order status
    required this.orderStatus,
    // Payment status
    required this.paymentStatus,
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
      // ORDER STATUS
      orderStatus: map['orderStatus'] ?? 'pending',

      // PAYMENT STATUS
      paymentStatus:
      map['paymentStatus'] ?? 'pending',

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
      // ORDER / SHIPPING STATUS
      'orderStatus': orderStatus,
      // PAYMENT STATUS
      'paymentStatus': paymentStatus,

      'createdAt': createdAt.toIso8601String(),
      'deliveryAddress': deliveryAddress,
    };
  }

  OrderModel copyWith({
    String? orderStatus,
    String? paymentStatus,
  }) {
    return OrderModel(
      orderId: orderId,
      userId: userId,
      sellerIds: sellerIds,
      items: items,
      totalAmount: totalAmount,

      // Agar new status diya hai to woh use hoga,
      // warna purana status.
      orderStatus: orderStatus ?? this.orderStatus,
      // Agar new payment status diya hai to woh use hoga,
      // warna purana payment status.
      paymentStatus:
      paymentStatus ?? this.paymentStatus,

      createdAt: createdAt,
        deliveryAddress: deliveryAddress,
    );
  }
}