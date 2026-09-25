import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Add new category
Future<void> addCategory(
    CategoryModel category,
    ) async {
  await _firestore
      .collection('categories')
      .add(category.toMap());
}

// Get all categories
Future<List<CategoryModel>> getCategories() async {
  final snapshot = await _firestore
      .collection('categories')
      .get();

  final categories = snapshot.docs.map((doc) {
    return CategoryModel.fromMap(
        doc.id,
        doc.data(),
    );
  }).toList();

  // Sort categories alphabetically
  categories.sort(
      (a, b) => a.name.toLowerCase().compareTo(
        b.name.toLowerCase(),
      ),
  );
  return categories;
}

// Get only active categories
Future<List<CategoryModel>> getActiveCategories() async {
  final snapshot = await _firestore
      .collection('categories')
      .where(
    'isActive',
    isEqualTo: true,
  )
      .get();

  final categories = snapshot.docs.map((doc) {
    return CategoryModel.fromMap(
      doc.id,
      doc.data(),
    );
  }).toList();

  // Sort categories alphabetically
  categories.sort(
        (a, b) => a.name.toLowerCase().compareTo(
      b.name.toLowerCase(),
    ),
  );

  return categories;
}

// Update category
Future<void> updateCategory(
    CategoryModel category,
    ) async {
  if(category.id.isEmpty){
    throw Exception(
      'Category ID is missing',
    );
  }
  await _firestore
  .collection('categories')
  .doc(category.id)
  .update(
    category.toMap(),
  );
}

// Delete category
Future<void> deleteCategory(
    String categoryId,
    ) async {
  if(categoryId.isEmpty) {
    throw Exception(
      'Category ID is missing',
    );
  }

  await _firestore
  .collection('categories')
  .doc(categoryId)
  .delete();
}
}
