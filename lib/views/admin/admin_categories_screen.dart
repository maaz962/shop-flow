import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/category_controller.dart';
import '../../models/category_model.dart';

class AdminCategoriesScreen extends StatelessWidget {
  AdminCategoriesScreen({super.key});

  final CategoryController categoryController =
  Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCategoryDialog(context);
        },
        child: const Icon(Icons.add),
      ),

      body: Obx(() {
        if (categoryController.isLoading.value &&
            categoryController.categories.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (categoryController.errorMessage.value.isNotEmpty &&
            categoryController.categories.isEmpty) {
          return _ErrorView(
            message: categoryController.errorMessage.value,
            onRetry: categoryController.getCategories,
          );
        }

        if (categoryController.categories.isEmpty) {
          return _EmptyView(
            onAdd: () {
              _showAddCategoryDialog(context);
            },
          );
        }

        return RefreshIndicator(
          onRefresh: categoryController.getCategories,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categoryController.categories.length,
            itemBuilder: (context, index) {
              final category =
              categoryController.categories[index];

              return _CategoryCard(
                category: category,
                onEdit: () {
                  _showEditCategoryDialog(
                    context,
                    category,
                  );
                },
                onToggle: () {
                  categoryController.toggleCategoryStatus(
                    category,
                  );
                },
                onDelete: () {
                  _showDeleteDialog(
                    context,
                    category,
                  );
                },
              );
            },
          ),
        );
      }),
    );
  }

  // Add category dialog
  void _showAddCategoryDialog(BuildContext context) {
    categoryController.categoryNameController.clear();

    Get.dialog(
      AlertDialog(
        title: const Text('Add Category'),
        content: TextField(
          controller:
          categoryController.categoryNameController,
          textCapitalization: TextCapitalization.words,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Category Name',
            hintText: 'e.g. Electronics',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await categoryController.addCategory();

              if (categoryController.errorMessage.value.isEmpty) {
                Get.back();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // Edit category dialog
  void _showEditCategoryDialog(
      BuildContext context,
      CategoryModel category,
      ) {
    final controller = TextEditingController(
      text: category.name,
    );

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Category'),
        content: TextField(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Category Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.dispose();
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await categoryController.updateCategory(
                category,
                controller.text,
              );

              controller.dispose();
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Delete confirmation dialog
  void _showDeleteDialog(
      BuildContext context,
      CategoryModel category,
      ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Category'),
        content: Text(
          'Are you sure you want to delete "${category.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();

              await categoryController.deleteCategory(
                category,
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// Category card
class _CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onEdit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _CategoryCard({
    required this.category,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        leading: CircleAvatar(
          child: Icon(
            category.isActive
                ? Icons.category_outlined
                : Icons.category_outlined,
          ),
        ),
        title: Text(
          category.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            category.isActive
                ? 'Active'
                : 'Inactive',
            style: TextStyle(
              color: category.isActive
                  ? Colors.green
                  : Colors.grey,
            ),
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              onEdit();
            }

            if (value == 'toggle') {
              onToggle();
            }

            if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'toggle',
                child: Row(
                  children: [
                    Icon(
                      category.isActive
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category.isActive
                          ? 'Deactivate'
                          : 'Activate',
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ],
                ),
              ),
            ];
          },
        ),
      ),
    );
  }
}

// Empty state
class _EmptyView extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyView({
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.category_outlined,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'No categories yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create your first product category.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Add Category'),
            ),
          ],
        ),
      ),
    );
  }
}

// Error state
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 56,
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}