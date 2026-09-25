class ProductModel {
  final int id;

  // Firebase Auth user UID
  final String ownerId;

  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;

  // Central category document ID
  final String categoryId;

  // Central category name
  final String categoryName;

  final String thumbnail;
  final List<String> images;
  final List<dynamic> reviews;

  // Firestore document ID
  final String? firestoreId;

  ProductModel({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.categoryId,
    required this.categoryName,
    required this.images,
    required this.thumbnail,
    required this.reviews,
    required this.firestoreId,
  });

  // JSON -> ProductModel
  factory ProductModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ProductModel(
      id: json['id'] ?? 0,
      ownerId: json['ownerId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discountPercentage:
      (json['discountPercentage'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      brand: json['brand'] ?? '',

      categoryId: json['categoryId'] ?? '',
      categoryName: json['categoryName'] ??
          json['category'] ??
          '',

      thumbnail: json['thumbnail'] ?? '',
      images: List<String>.from(
        json['images'] ?? [],
      ),
      reviews: List<dynamic>.from(
        json['reviews'] ?? [],
      ),
      firestoreId: null,
    );
  }

  // Firestore -> ProductModel
  // Deserialization / Data Mapping
  factory ProductModel.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return ProductModel(
      id: int.tryParse(id) ?? 0,
      ownerId: map['ownerId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      discountPercentage:
      (map['discountPercentage'] ?? 0).toDouble(),
      rating: (map['rating'] ?? 0).toDouble(),
      stock: map['stock'] ?? 0,
      brand: map['brand'] ?? '',

      categoryId: map['categoryId'] ?? '',
      categoryName: map['categoryName'] ??
          map['category'] ??
          '',

      images: List<String>.from(
        map['images'] ?? [],
      ),
      thumbnail: map['thumbnail'] ?? '',
      reviews: List<dynamic>.from(
        map['reviews'] ?? [],
      ),
      firestoreId: id,
    );
  }

  // ProductModel -> Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'brand': brand,

      'categoryId': categoryId,
      'categoryName': categoryName,

      'thumbnail': thumbnail,
      'images': images,
      'reviews': reviews,
      'ownerId': ownerId,
    };
  }
}