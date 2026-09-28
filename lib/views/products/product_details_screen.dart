import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/product_model.dart';
import '../../models/review_model.dart';
import '../../app/routes/app_routes.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/review_controller.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final ProductModel product;

  late final CartController cartController;
  late final ReviewController reviewController;

  @override
  void initState() {
    super.initState();

    product = Get.arguments as ProductModel;

    cartController = Get.find<CartController>();
    reviewController = Get.find<ReviewController>();

    // Load reviews only once when Product Details opens.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      reviewController.getProductReviews(
        product.firestoreId ?? product.id.toString(),
      );
    });
  }

  // "1 review" / "2 reviews"
  String _reviewsLabel(int count) => '$count ${count == 1 ? 'review' : 'reviews'}';

  // Label on the left, value on the right
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double originalPrice = product.price;

    if (product.discountPercentage > 0 && product.discountPercentage < 100) {
      originalPrice = product.price / (1 - product.discountPercentage / 100);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =========================
                  // PRODUCT IMAGE
                  // =========================

                  SizedBox(
                    width: double.infinity,
                    height: 350,
                    child: product.thumbnail.isNotEmpty
                        ? Image.network(
                      product.thumbnail,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 80,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                        : const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 80,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // TITLE
                  // =========================

                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // =========================
                  // RATING
                  // =========================

                  Obx(() {
                    final rating = reviewController.reviews.isNotEmpty
                        ? reviewController.averageRating
                        : product.rating;

                    return Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 5),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Text(_reviewsLabel(reviewController.reviewCount)),
                      ],
                    );
                  }),

                  const SizedBox(height: 16),

                  // =========================
                  // PRICE
                  // =========================

                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  // =========================
                  // ORIGINAL PRICE + DISCOUNT
                  // =========================

                  Row(
                    children: [
                      Text(
                        '\$${originalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // SHIPPING
                  // =========================

                  const Card(
                    child: ListTile(
                      leading: Icon(Icons.local_shipping),
                      title: Text('Free Shipping'),
                      subtitle: Text('Delivery in 2-4 days'),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // =========================
                  // PRODUCT INFORMATION
                  // =========================

                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Product Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _infoRow('Brand', product.brand),
                            const Divider(height: 1),
                            _infoRow('Category', product.categoryName),
                            const Divider(height: 1),
                            _infoRow('Stock', '${product.stock}'),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // DESCRIPTION
                  // =========================

                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 15),
                  ),

                  const SizedBox(height: 30),

                  // =========================
                  // RATINGS & REVIEWS
                  // =========================

                  const Text(
                    'Ratings & Reviews',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // =========================
                  // RATING SUMMARY
                  // =========================

                  Obx(() {
                    final average = reviewController.averageRating;
                    final count = reviewController.reviewCount;

                    // counts[0] = 5 star ... counts[4] = 1 star
                    final counts = List<int>.generate(5, (i) {
                      final star = 5 - i;
                      return reviewController.reviews
                          .where((r) => r.rating.round() == star)
                          .length;
                    });

                    return SizedBox(
                      width: double.infinity,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Left: average
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    average.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(
                                      5,
                                          (index) => Icon(
                                        index < average.round()
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _reviewsLabel(count),
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),

                              const SizedBox(width: 20),

                              // Right: star distribution bars
                              Expanded(
                                child: Column(
                                  children: List.generate(5, (i) {
                                    final star = 5 - i;
                                    final value =
                                    count == 0 ? 0.0 : counts[i] / count;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 3,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            '$star',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(
                                            Icons.star,
                                            size: 12,
                                            color: Colors.amber,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(4),
                                              child: LinearProgressIndicator(
                                                value: value,
                                                minHeight: 6,
                                                backgroundColor:
                                                Colors.grey.shade300,
                                                valueColor:
                                                const AlwaysStoppedAnimation<
                                                    Color>(Colors.amber),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          SizedBox(
                                            width: 18,
                                            child: Text(
                                              '${counts[i]}',
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 16),

                  // =========================
                  // WRITE / EDIT REVIEW
                  // =========================

                  Obx(() {
                    final userReview = reviewController.userReview.value;

                    return SizedBox(
                      width: double.infinity,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userReview == null
                                    ? 'Write a Review'
                                    : 'Your Review',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Rating Stars
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: List.generate(5, (index) {
                                  final rating = index + 1.0;

                                  return IconButton(
                                    onPressed: () {
                                      reviewController.selectedRating.value =
                                          rating;
                                    },
                                    icon: Obx(
                                          () => Icon(
                                        reviewController.selectedRating.value >=
                                            rating
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                        size: 30,
                                      ),
                                    ),
                                  );
                                }),
                              ),

                              const SizedBox(height: 8),

                              // Review Text
                              TextField(
                                controller:
                                reviewController.reviewTextController,
                                maxLines: 4,
                                decoration: const InputDecoration(
                                  hintText: 'Write your review...',
                                  border: OutlineInputBorder(),
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Submit / Update
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: reviewController.isLoading.value
                                      ? null
                                      : () async {
                                    final rating = reviewController
                                        .selectedRating.value;

                                    final comment = reviewController
                                        .reviewTextController.text;

                                    if (userReview == null) {
                                      await reviewController.addReview(
                                        productId: product.firestoreId ??
                                            product.id.toString(),
                                        rating: rating,
                                        comment: comment,
                                      );
                                    } else {
                                      await reviewController
                                          .updateReview(
                                        review: userReview,
                                        rating: rating,
                                        comment: comment,
                                      );
                                    }
                                  },
                                  child: reviewController.isLoading.value
                                      ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                      : Text(
                                    userReview == null
                                        ? 'Submit Review'
                                        : 'Update Review',
                                  ),
                                ),
                              ),

                              // Delete own review
                              if (userReview != null) ...[
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: reviewController.isLoading.value
                                        ? null
                                        : () {
                                      reviewController
                                          .deleteReview(userReview);
                                    },
                                    child: const Text('Delete Review'),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 20),

                  // =========================
                  // REVIEWS LIST
                  // =========================

                  Obx(() {
                    if (reviewController.isLoading.value &&
                        reviewController.reviews.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (reviewController.reviews.isEmpty) {
                      return const SizedBox(
                        width: double.infinity,
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(
                              child: Text('No reviews yet.'),
                            ),
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: reviewController.reviews
                          .map(
                            (review) => _ReviewCard(
                          review: review,
                          currentUserId: reviewController
                              .authController.user.value?.uid,
                          onEdit: () {
                            reviewController.prepareEditReview(review);
                          },
                          onDelete: () {
                            reviewController.deleteReview(review);
                          },
                        ),
                      )
                          .toList(),
                    );
                  }),

                  const SizedBox(height: 30),

                  // =========================
                  // CART BUTTONS
                  // =========================

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            cartController.addToCart(product);
                          },
                          child: const Text('Add to Cart'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            cartController.addToCart(product);

                            Get.toNamed(AppRoutes.checkout);
                          },
                          child: const Text(
                            'Buy Now',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================
// REVIEW CARD
// =====================================================

class _ReviewCard extends StatelessWidget {
  final ReviewModel review;
  final String? currentUserId;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ReviewCard({
    required this.review,
    required this.currentUserId,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isOwnReview = currentUserId == review.userId;

    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User information
              Row(
                children: [
                  CircleAvatar(
                    child: Text(
                      review.userName.isNotEmpty
                          ? review.userName[0].toUpperCase()
                          : 'C',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.userName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: List.generate(
                            5,
                                (index) => Icon(
                              index < review.rating.round()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Own review menu
                  if (isOwnReview)
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          onEdit();
                        }

                        if (value == 'delete') {
                          onDelete();
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Review comment
              Text(
                review.comment,
                style: const TextStyle(fontSize: 15),
              ),

              const SizedBox(height: 8),

              // Review date
              Text(
                _formatDate(review.createdAt),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}