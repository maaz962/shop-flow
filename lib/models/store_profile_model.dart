class StoreProfileModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String storeName;
  final String storeDescription;
  final String storeLogo;
  final int productCount;
  final int orderCount;
  final double rating;

  StoreProfileModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.storeName,
    required this.storeDescription,
    required this.storeLogo,
    required this.productCount,
    required this.orderCount,
    required this.rating,
  });

  factory StoreProfileModel.fromMap(
      String uid,
      Map<String, dynamic> map, {
        int productCount = 0,
        int orderCount = 0,
        double rating = 0,
      }) {
    return StoreProfileModel(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? '',
      storeName: map['storeName'] ?? '',
      storeDescription: map['storeDescription'] ?? '',
      storeLogo: map['storeLogo'] ?? '',
      productCount: productCount,
      orderCount: orderCount,
      rating: rating,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'storeName': storeName,
      'storeDescription': storeDescription,
      'storeLogo': storeLogo,
    };
  }

  StoreProfileModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? role,
    String? storeName,
    String? storeDescription,
    String? storeLogo,
    int? productCount,
    int? orderCount,
    double? rating,
  }) {
    return StoreProfileModel(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      storeName: storeName ?? this.storeName,
      storeDescription:
      storeDescription ?? this.storeDescription,
      storeLogo: storeLogo ?? this.storeLogo,
      productCount: productCount ?? this.productCount,
      orderCount: orderCount ?? this.orderCount,
      rating: rating ?? this.rating,
    );
  }
}