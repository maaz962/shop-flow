import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/store_profile_model.dart';

class StoreProfileService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get uid => _auth.currentUser?.uid;

  Future<StoreProfileModel> getStoreProfile() async {
    final currentUid = uid;

    if (currentUid == null) {
      throw Exception('User is not logged in');
    }

    final user = _auth.currentUser;

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
    final currentUid = uid;

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