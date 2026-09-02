
class ProductModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String category;
  final String thumbnail;
  final List<String> images;
  final List<dynamic> reviews;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.images,
    required this.thumbnail,
    required this.reviews,
});

  factory ProductModel.fromJson(Map<String, dynamic> json){
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0) .toDouble(),
      discountPercentage: (json['discountPercentage'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      brand: json['brand'] ?? '',
      category: json['category'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      reviews: List<dynamic>.from(json['reviews'] ?? [],)
    );
  }

  // Deserialization / Data Mapping
  factory ProductModel.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return ProductModel(
        id: int.tryParse(id) ?? 0,
        title: map['title'] ?? '',
        description: map['description'] ?? '',
        price: (map['price'] ?? 0).toDouble(),
        discountPercentage: (map['discountPercentage'] ?? 0).toDouble(),
        rating: (map['rating'] ?? 0).toDouble(),
        stock: map['stock'] ?? 0,
        brand: map['brand'] ?? '',
        category: map['category'] ?? '',
        images: List<String>.from(map['images'] ?? []),
        thumbnail: map['thumbnail'] ?? '',
        reviews: List<dynamic>.from(map['reviews'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'brand': brand,
      'category': category,
      'thumbnail': thumbnail,
      'images': images,
      'reviews': reviews,
    };
  }
}