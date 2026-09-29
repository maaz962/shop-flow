import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/admin_controller.dart';
import '../../models/product_model.dart';
import '../../models/user_model.dart';

import '../../app/routes/app_routes.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() =>
      _AdminProductsScreenState();
}

class _AdminProductsScreenState
    extends State<AdminProductsScreen> {
  final AdminController adminController =
  Get.find<AdminController>();

  final TextEditingController searchController =
  TextEditingController();

  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      setState(() {
        searchQuery =
            searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }


  // Filter Products

  List<ProductModel> get filteredProducts {
    if (searchQuery.isEmpty) {
      return adminController.products;
    }

    return adminController.products.where((product) {
      final title = product.title.toLowerCase();
      final brand = product.brand.toLowerCase();
      final category =
      product.categoryName.toLowerCase();

      return title.contains(searchQuery) ||
          brand.contains(searchQuery) ||
          category.contains(searchQuery);
    }).toList();
  }

  // Find Seller

  UserModel? getSeller(String ownerId) {
    try {
      return adminController.sellers.firstWhere(
            (seller) => seller.uid == ownerId,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Products',
        ),
        centerTitle: true,
      ),

      body: Obx(() {
        if (adminController.isLoading.value &&
            adminController.products.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (adminController.errorMessage.value.isNotEmpty &&
            adminController.products.isEmpty) {
          return _buildErrorView();
        }

        return RefreshIndicator(
          onRefresh:
          adminController.refreshDashboard,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Summary

              _buildSummaryCard(context),

              const SizedBox(height: 20),

              // Search

              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon:
                  const Icon(Icons.search),
                  suffixIcon:
                  searchQuery.isNotEmpty
                      ? IconButton(
                    onPressed: () {
                      searchController.clear();
                    },
                    icon: const Icon(
                      Icons.clear,
                    ),
                  )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Section Title

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'All Products',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${filteredProducts.length} products',
                    style: TextStyle(
                      color:
                      Theme.of(context)
                          .colorScheme
                          .primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),


              // Products

              if (filteredProducts.isEmpty)
                _buildEmptyView()
              else
                ...filteredProducts.map(
                      (product) =>
                      _buildProductCard(
                        context,
                        product,
                      ),
                ),
            ],
          ),
        );
      }),
    );
  }

  // Summary Card

  Widget _buildSummaryCard(
      BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor:
              Theme.of(context)
                  .colorScheme
                  .primaryContainer,
              child: Icon(
                Icons.inventory_2_outlined,
                color:
                Theme.of(context)
                    .colorScheme
                    .primary,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Products',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  adminController.totalProducts
                      .toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Product Card

  Widget _buildProductCard(
      BuildContext context,
      ProductModel product) {
    final seller =
    getSeller(product.ownerId);

    return Card(
      margin:
      const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius:
              BorderRadius.circular(10),
              child: SizedBox(
                width: 75,
                height: 75,
                child: product.thumbnail
                    .trim()
                    .isNotEmpty
                    ? Image.network(
                  product.thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (
                      context,
                      error,
                      stackTrace,
                      ) {
                    return const Icon(
                      Icons
                          .image_not_supported_outlined,
                      size: 35,
                    );
                  },
                )
                    : const Icon(
                  Icons
                      .image_outlined,
                  size: 35,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Product Information
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title.isNotEmpty
                        ? product.title
                        : 'Unnamed Product',
                    maxLines: 2,
                    overflow:
                    TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight:
                      FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight:
                      FontWeight.bold,
                      color:
                      Theme.of(context)
                          .colorScheme
                          .primary,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    product.categoryName
                        .isNotEmpty
                        ? product.categoryName
                        : 'No Category',
                    style: TextStyle(
                      color: Colors
                          .grey
                          .shade600,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Seller
                  Row(
                    children: [
                      const Icon(
                        Icons.store_outlined,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          seller?.name ??
                              'Unknown Seller',
                          maxLines: 1,
                          overflow:
                          TextOverflow
                              .ellipsis,
                          style:
                          const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Actions
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _editProduct(product);
                }

                if (value == 'delete') {
                  _confirmDelete(product);
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                        ),
                        SizedBox(width: 10),
                        Text('Edit Product'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                        ),
                        SizedBox(width: 10),
                        Text('Delete Product'),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }

  // Edit Product
  void _editProduct(
      ProductModel product) {
    Get.toNamed(
      AppRoutes.editProduct,
      arguments: product,
    );
  }

  // Delete Confirmation

  void _confirmDelete(
      ProductModel product) {
    Get.defaultDialog(
      title: 'Delete Product',
      middleText:
      'Are you sure you want to delete "${product.title}"?',

      textCancel: 'Cancel',
      textConfirm: 'Delete',

      confirmTextColor: Colors.white,

      onConfirm: () async {
        Get.back();

        await adminController
            .deleteProduct(product);
      },
    );
  }

  // Empty View

  Widget _buildEmptyView() {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        vertical: 60,
      ),
      child: Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 55,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          const Text(
            'No products found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Error View

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 50,
            ),
            const SizedBox(height: 12),
            const Text(
              'Failed to load products',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              adminController
                  .errorMessage.value,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed:
              adminController
                  .refreshDashboard,
              child: const Text(
                'Try Again',
              ),
            ),
          ],
        ),
      ),
    );
  }
}