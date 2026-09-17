import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:shop_flow_app/app/utils/app_snackbar.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../services/order_service.dart';
import '../services/user_service.dart';

class AdminController extends GetxController {
  final UserService userService = UserService();
  final FirestoreService firestoreService = FirestoreService();
  final OrderService orderService = OrderService();

  final users = <UserModel>[].obs;
  final sellers = <UserModel>[].obs;
  final products = <ProductModel>[].obs;
  final orders = <OrderModel>[].obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  int get totalUsers => users.length;

  int get totalSellers => sellers.length;

  int get totalProducts => products.length;

  int get totalOrders => orders.length;

  double get totalRevenue {
    return orders.fold(
      0.0,
          (sum, order) => sum + order.totalAmount,
    );
  }

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final User? currentUser =
          FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception('User is not logged in.');
      }

      final adminDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!adminDoc.exists) {
        throw Exception(
          'Admin user document does not exist in Firestore.',
        );
      }

      final adminData = adminDoc.data();

      final role = adminData?['role'];

      if (role != 'admin') {
        throw Exception(
          'Current user role is "$role", not "admin".',
        );
      }

      try {
        final usersList = await userService.getAllUsers();

        users.assignAll(usersList);
      } catch (e) {
        throw Exception(
          'Users query failed: $e',
        );
      }

      try {
        final sellersList =
        await userService.getAllSellers();

        sellers.assignAll(sellersList);

      } catch (e) {

        throw Exception(
          'Sellers query failed: $e',
        );
      }


      try {
        final productsList =
        await firestoreService.getProducts();

        products.assignAll(productsList);

      } catch (e) {

        throw Exception(
          'Products query failed: $e',
        );
      }


      try {
        final ordersList =
        await orderService.getAllOrders();

        orders.assignAll(ordersList);

      } catch (e) {

        throw Exception(
          'Orders query failed: $e',
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshDashboard() async {
    await loadDashboardData();
  }

  Future<void> updateUserStatus(
      UserModel user,
      bool isActive,
      ) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await userService.updateUserStatus(
        uid: user.uid,
        isActive: isActive,
      );

      final index = users.indexWhere(
            (item) => item.uid == user.uid,
      );

      if (index != -1) {
        users[index] = user.copyWith(
          isActive: isActive,
        );
      }

      final sellerIndex = sellers.indexWhere(
            (item) => item.uid == user.uid,
      );

      if (sellerIndex != -1) {
        sellers[sellerIndex] = user.copyWith(
          isActive: isActive,
        );
      }

      AppSnackbar.show(
        'Success',
        isActive
            ? 'User enabled successfully'
            : 'User disabled successfully',
      );
    } catch (e) {
      errorMessage.value = e.toString();

      AppSnackbar.show(
        'Error',
        'Failed to update user status',
      );
    } finally {
      isLoading.value = false;
    }
  }
}