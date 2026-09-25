import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/category_model.dart';
import '../services/category_service.dart';
import 'package:shop_flow_app/app/utils/app_snackbar.dart';

class CategoryController extends GetxController {
  final CategoryService categoryService = CategoryService();

  // All categories
  final categories = <CategoryModel>[].obs;

  // Active categories only
  final activeCategories = <CategoryModel>[].obs;

  // Loading state
  final isLoading = false.obs;

  // Error message
  final errorMessage = ''.obs;

  // Category name input
  final categoryNameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    getCategories();
  }

  @override
  void onClose() {
    categoryNameController.dispose();

    super.onClose();
  }

  // Get all categories
  Future<void> getCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final fetchedCategories =
      await categoryService.getCategories();

      categories.assignAll(fetchedCategories);

      // Keep active categories updated as well
      activeCategories.assignAll(
        fetchedCategories.where(
              (category) => category.isActive,
        ),
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Get only active categories
  Future<void> getActiveCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final fetchedCategories =
      await categoryService.getActiveCategories();

      activeCategories.assignAll(
        fetchedCategories,
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Add category
  Future<void> addCategory() async {
    final name = categoryNameController.text.trim();

    if (name.isEmpty) {
      AppSnackbar.show(
        'Required',
        'Please enter a category name',
      );
      return;
    }

    // Prevent duplicate category names
    final alreadyExists = categories.any(
          (category) =>
      category.name.toLowerCase() ==
          name.toLowerCase(),
    );

    if (alreadyExists) {
      AppSnackbar.show(
        'Already Exists',
        'This category already exists',
      );
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final category = CategoryModel(
        id: '',
        name: name,
        isActive: true,
      );

      await categoryService.addCategory(category);

      categoryNameController.clear();

      await getCategories();

      AppSnackbar.show(
        'Success',
        'Category added successfully',
      );
    } catch (e) {
      errorMessage.value = e.toString();

      AppSnackbar.show(
        'Error',
        'Failed to add category',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update category
  Future<void> updateCategory(
      CategoryModel category,
      String newName,
      ) async {
    final name = newName.trim();

    if (name.isEmpty) {
      AppSnackbar.show(
        'Required',
        'Category name cannot be empty',
      );
      return;
    }

    // Check duplicate name
    final alreadyExists = categories.any(
          (item) =>
      item.id != category.id &&
          item.name.toLowerCase() ==
              name.toLowerCase(),
    );

    if (alreadyExists) {
      AppSnackbar.show(
        'Already Exists',
        'This category already exists',
      );
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final updatedCategory = CategoryModel(
        id: category.id,
        name: name,
        isActive: category.isActive,
      );

      await categoryService.updateCategory(
        updatedCategory,
      );

      await getCategories();

      AppSnackbar.show(
        'Success',
        'Category updated successfully',
      );
    } catch (e) {
      errorMessage.value = e.toString();

      AppSnackbar.show(
        'Error',
        'Failed to update category',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Activate / deactivate category
  Future<void> toggleCategoryStatus(
      CategoryModel category,
      ) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final updatedCategory = CategoryModel(
        id: category.id,
        name: category.name,
        isActive: !category.isActive,
      );

      await categoryService.updateCategory(
        updatedCategory,
      );

      await getCategories();

      AppSnackbar.show(
        'Success',
        category.isActive
            ? 'Category deactivated'
            : 'Category activated',
      );
    } catch (e) {
      errorMessage.value = e.toString();

      AppSnackbar.show(
        'Error',
        'Failed to update category status',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Delete category
  Future<void> deleteCategory(
      CategoryModel category,
      ) async {
    if (category.id.isEmpty) {
      AppSnackbar.show(
        'Error',
        'Category ID is missing',
      );
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      await categoryService.deleteCategory(
        category.id,
      );

      categories.removeWhere(
            (item) => item.id == category.id,
      );

      activeCategories.removeWhere(
            (item) => item.id == category.id,
      );

      AppSnackbar.show(
        'Success',
        'Category deleted successfully',
      );
    } catch (e) {
      errorMessage.value = e.toString();

      AppSnackbar.show(
        'Error',
        'Failed to delete category',
      );
    } finally {
      isLoading.value = false;
    }
  }
}