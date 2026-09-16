import 'package:get/get.dart';
import 'package:shop_flow_app/app/utils/app_snackbar.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../services/order_service.dart';
import '../services/user_service.dart';

class AdminController extends GetxController{
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
    try{
      isLoading.value = true;
      errorMessage.value = '';

      final results = await Future.wait([
        userService.getAllUsers(),
        userService.getAllSellers(),
        firestoreService.getProducts(),
        orderService.getAllOrders(),
      ]);

      users.assignAll(results[0] as List<UserModel>);
      sellers.assignAll(results[1] as List<UserModel>);
      products.assignAll(results[2] as List<ProductModel>);
      orders.assignAll(results[3] as List<OrderModel>);
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
      // dynamic isUpdatingUser,
      ) async {
    try {
      // isUpdatingUser.value = true;
      isLoading.value = true;
      errorMessage.value = '';

      await userService.updateUserStatus(
          uid: user.uid,
          isActive: isActive,
      );

      final index = users.indexWhere(
          (item) => item.uid == user.uid,
      );

      if(index != -1) {
        users[index] = user.copyWith(
          isActive: isActive,
        );
      }

      final sellerIndex = sellers.indexWhere(
          (item) => item.uid == user.uid,
      );

      if(sellerIndex != -1) {
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

      AppSnackbar.show('Error',
      'Failed to update user status',
      );
    } finally {
      isLoading.value = false;
    }
  }
}