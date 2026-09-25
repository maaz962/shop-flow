class CategoryModel {
  final String id;
  final String name;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    required this.isActive,
});

  // Firestore -> CategoryModel
factory CategoryModel.fromMap(
    String id,
    Map<String, dynamic> map,
    ) {
  return CategoryModel(
      id: id,
      name: map['name'] ?? '',
      isActive: map['isActive'] ?? true,
  );
}

// CategoryModel -> Firestore
Map<String, dynamic> toMap() {
  return {
    'name': name,
    'isActive': isActive,
  };
}
}