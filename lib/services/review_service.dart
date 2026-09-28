import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/review_model.dart';

class ReviewService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // Add Review
  Future<void> addReview(
      ReviewModel review,
      ) async {
    await _firestore
        .collection('reviews')
        .add(review.toMap());
  }

  // Get reviews for a specific product
  Future<List<ReviewModel>> getProductReviews(
      String productId,
      ) async {
    final snapshot = await _firestore
        .collection('reviews')
        .where(
      'productId',
      isEqualTo: productId,
    )
        .get();

    final reviews = snapshot.docs.map((doc) {
      return ReviewModel.fromMap(
        doc.id,
        doc.data(),
      );
    }).toList();

    // Newest reviews first
    reviews.sort(
          (a, b) => b.createdAt.compareTo(
        a.createdAt,
      ),
    );

    return reviews;
  }

  // Get customer's review for a specific product
  Future<ReviewModel?> getUserProductReview(
      String productId,
      String userId,
      ) async {
    final snapshot = await _firestore
        .collection('reviews')
        .where(
      'productId',
      isEqualTo: productId,
    )
        .where(
      'userId',
      isEqualTo: userId,
    )
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final doc = snapshot.docs.first;

    return ReviewModel.fromMap(
      doc.id,
      doc.data(),
    );
  }

  // Update Review
  Future<void> updateReview(
      ReviewModel review,
      ) async {
    if (review.id.isEmpty) {
      throw Exception(
        'Review ID is missing',
      );
    }

    await _firestore
        .collection('reviews')
        .doc(review.id)
        .update(
      review.toMap(),
    );
  }

  // Delete Review
  Future<void> deleteReview(
      String reviewId,
      ) async {
    if (reviewId.isEmpty) {
      throw Exception(
        'Review ID is missing',
      );
    }

    await _firestore
        .collection('reviews')
        .doc(reviewId)
        .delete();
  }

  // Calculate average rating for a product
  Future<double> calculateAverageRating(
      String productId,
      ) async {
    final reviews = await getProductReviews(
      productId,
    );

    if (reviews.isEmpty) {
      return 0;
    }

    final total = reviews.fold<double>(
      0,
          (sum, review) => sum + review.rating,
    );

    return total / reviews.length;
  }

  // Update product rating in Firestore
  Future<void> updateProductRating(
      String productId,
      ) async {
    final averageRating =
    await calculateAverageRating(productId);

    await _firestore
        .collection('products')
        .doc(productId)
        .update({
      'rating': double.parse(
        averageRating.toStringAsFixed(1),
      ),
    });
  }
}