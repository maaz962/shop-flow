import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/store_profile_model.dart';

class StoreProfileService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get uid => _auth.currentUser?.uid;

  Future<User?> _getCurrentUser() async {
    // If Firebase already has the user, use it directly.
    if (_auth.currentUser != null) {
      return _auth.currentUser;
    }

    // Wait for Firebase Auth to finish restoring the session.
    try {
      return await _auth.authStateChanges().first
          .timeout(const Duration(seconds: 5));
    } catch (_) {
      return null;
    }
  }

  Future<StoreProfileModel> getStoreProfile() async {
    final user = await _getCurrentUser();
    final currentUid = user?.uid;

    if (currentUid == null) {
      throw Exception('User is not logged in');
    }

    final doc = await _firestore
        .collection('users')
        .doc(currentUid)
        .get();

    final data = doc.data() ?? {};

    final productSnapshot = await _firestore
        .collection('products')
        .where(
      'ownerId',
      isEqualTo: currentUid,
    )
        .get();

    return StoreProfileModel.fromMap(
      currentUid,
      {
        ...data,
        'name': data['name'] ?? user?.displayName ?? '',
        'email': data['email'] ?? user?.email ?? '',
      },
      productCount: productSnapshot.docs.length,
      orderCount: 0,
      rating: 0,
    );
  }

  Future<void> updateStoreProfile({
    required String storeName,
    required String storeDescription,
    required String phone,
  }) async {
    final user = await _getCurrentUser();
    final currentUid = user?.uid;

    if (currentUid == null) {
      throw Exception('User is not logged in');
    }

    await _firestore
        .collection('users')
        .doc(currentUid)
        .set(
      {
        'storeName': storeName.trim(),
        'storeDescription': storeDescription.trim(),
        'phone': phone.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }
}