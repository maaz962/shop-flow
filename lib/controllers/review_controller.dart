import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/review_model.dart';
import '../services/review_service.dart';
import 'auth_controller.dart';
import 'package:shop_flow_app/app/utils/app_snackbar.dart';

class ReviewController extends GetxController {
  final ReviewService reviewService = ReviewService();

  final AuthController authController =
  Get.find<AuthController>();

  // Reviews of currently selected product
  final reviews = <ReviewModel>[].obs;

  // Loading state
  final isLoading = false.obs;

  // Error message
  final errorMessage = ''.obs;

  // Current user's review
  final userReview = Rxn<ReviewModel>();

  // Selected rating
  final selectedRating = 0.0.obs;

  // Review text controller
  final reviewTextController = TextEditingController();

  @override
  void onClose() {
    reviewTextController.dispose();
    super.onClose();
  }

  // Get reviews for product
  Future<void> getProductReviews(
      String productId,
      ) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final fetchedReviews =
      await reviewService.getProductReviews(
        productId,
      );

      reviews.assignAll(fetchedReviews);

      final userId =
          authController.user.value?.uid;

      if (userId != null) {
        userReview.value =
        await reviewService.getUserProductReview(
          productId,
          userId,
        );

        // Load existing review into the form
        if (userReview.value != null) {
          selectedRating.value =
              userReview.value!.rating;

          reviewTextController.text =
              userReview.value!.comment;
        } else {
          selectedRating.value = 0;
          reviewTextController.clear();
        }
      } else {
        userReview.value = null;
        selectedRating.value = 0;
        reviewTextController.clear();
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Add review
  Future<void> addReview({
    required String productId,
    required double rating,
    required String comment,
  }) async {
    try {
      final user =
          authController.user.value;

      if (user == null) {
        AppSnackbar.show(
          'Login Required',
          'Please login to write a review',
        );
        return;
      }

      if (rating < 1 || rating > 5) {
        AppSnackbar.show(
          'Invalid Rating',
          'Please select a rating between 1 and 5',
        );
        return;
      }

      if (comment.trim().isEmpty) {
        AppSnackbar.show(
          'Required',
          'Please write a review',
        );
        return;
      }

      isLoading.value = true;
      errorMessage.value = '';

      final review = ReviewModel(
        id: '',
        productId: productId,
        userId: user.uid,
        userName: user.displayName ?? 'Customer',
        rating: rating,
        comment: comment.trim(),
        createdAt: DateTime.now(),
      );

      await reviewService.addReview(review);
      await reviewService.updateProductRating(productId);
      await getProductReviews(productId);

      AppSnackbar.show(
        'Success',
        'Review added successfully',
      );
    } catch (e) {
      errorMessage.value = e.toString();

      AppSnackbar.show(
        'Error',
        'Failed to add review',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update review
  Future<void> updateReview({
    required ReviewModel review,
    required double rating,
    required String comment,
  }) async {
    try {
      final user =
          authController.user.value;

      if (user == null) {
        AppSnackbar.show(
          'Login Required',
          'Please login first',
        );
        return;
      }

      if (review.userId != user.uid) {
        AppSnackbar.show(
          'Error',
          'You can only edit your own review',
        );
        return;
      }

      if (rating < 1 || rating > 5) {
        AppSnackbar.show(
          'Invalid Rating',
          'Please select a rating between 1 and 5',
        );
        return;
      }

      if (comment.trim().isEmpty) {
        AppSnackbar.show(
          'Required',
          'Please write a review',
        );
        return;
      }

      isLoading.value = true;
      errorMessage.value = '';

      final updatedReview = ReviewModel(
        id: review.id,
        productId: review.productId,
        userId: review.userId,
        userName: review.userName,
        rating: rating,
        comment: comment.trim(),
        createdAt: review.createdAt,
      );

      await reviewService.updateReview(
        updatedReview,
      );
      await reviewService.updateProductRating(
        review.productId,
      );
      await getProductReviews(
        review.productId,
      );

      AppSnackbar.show(
        'Success',
        'Review updated successfully',
      );
    } catch (e) {
      errorMessage.value = e.toString();

      AppSnackbar.show(
        'Error',
        'Failed to update review',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Delete review
  Future<void> deleteReview(
      ReviewModel review,
      ) async {
    try {
      final user =
          authController.user.value;

      if (user == null) {
        AppSnackbar.show(
          'Login Required',
          'Please login first',
        );
        return;
      }

      if (review.userId != user.uid) {
        AppSnackbar.show(
          'Error',
          'You can only delete your own review',
        );
        return;
      }

      isLoading.value = true;
      errorMessage.value = '';

      await reviewService.deleteReview(
        review.id,
      );
      await reviewService.updateProductRating(
        review.productId,
      );
      await getProductReviews(
        review.productId,
      );

      AppSnackbar.show(
        'Success',
        'Review deleted successfully',
      );
    } catch (e) {
      errorMessage.value = e.toString();

      AppSnackbar.show(
        'Error',
        'Failed to delete review',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Prepare review form for editing
  void prepareEditReview(
      ReviewModel review,
      ) {
    selectedRating.value = review.rating;
    reviewTextController.text = review.comment;
  }

  // Clear review form
  void clearReviewForm() {
    selectedRating.value = 0;
    reviewTextController.clear();
  }

  // Calculate average rating
  double get averageRating {
    if (reviews.isEmpty) {
      return 0;
    }

    final total = reviews.fold<double>(
      0,
          (sum, review) => sum + review.rating,
    );

    return total / reviews.length;
  }

  // Total reviews
  int get reviewCount {
    return reviews.length;
  }
}