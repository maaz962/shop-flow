import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/review_model.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _reviews =>
      _firestore.collection('reviews');

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection('products');

  // One review per user per product. Firestore rules depend on this ID.
  String _reviewId(String productId, String userId) =>
      '${productId}_$userId';

  // Add Review (review + product rating in one batch)
  Future<void> addReview(ReviewModel review) => _save(review);

  // Update Review (same, set() overwrites the user's own review)
  Future<void> updateReview(ReviewModel review) => _save(review);

  // Delete Review (review delete + product rating in one batch)
  Future<void> deleteReview(ReviewModel review) =>
      _save(review, delete: true);

  // Get reviews for a specific product
  Future<List<ReviewModel>> getProductReviews(String productId) async {
    final snapshot =
    await _reviews.where('productId', isEqualTo: productId).get();

    final reviews = snapshot.docs
        .map((doc) => ReviewModel.fromMap(doc.id, doc.data()))
        .toList();

    // Newest reviews first
    reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return reviews;
  }

  // Get customer's review for a specific product
  Future<ReviewModel?> getUserProductReview(
      String productId,
      String userId,
      ) async {
    final doc = await _reviews.doc(_reviewId(productId, userId)).get();
    if (!doc.exists) return null;
    return ReviewModel.fromMap(doc.id, doc.data()!);
  }

  Future<void> _save(ReviewModel review, {bool delete = false}) async {
    final reviewRef =
    _reviews.doc(_reviewId(review.productId, review.userId));

    // Ratings of all OTHER reviews of this product
    final snapshot =
    await _reviews.where('productId', isEqualTo: review.productId).get();

    double sum = 0;
    int count = 0;
    for (final doc in snapshot.docs) {
      if (doc.id == reviewRef.id) continue;
      sum += ((doc.data()['rating'] ?? 0) as num).toDouble();
      count++;
    }

    if (!delete) {
      sum += review.rating;
      count++;
    }

    final average = count == 0 ? 0.0 : sum / count;

    final batch = _firestore.batch();

    if (delete) {
      batch.delete(reviewRef);
    } else {
      batch.set(reviewRef, review.toMap());
    }

    batch.update(_products.doc(review.productId), {
      'rating': double.parse(average.toStringAsFixed(1)),
    });

    await batch.commit();
  }
}