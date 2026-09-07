import 'package:get/get.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';
import 'auth_controller.dart';

class OrderController extends GetxController{
  final OrderService orderService = OrderService();

  final AuthController authController = Get.find<AuthController>();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final orders = <OrderModel>[].obs;

  Future<void> getMyOrders() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final uid = authController.user.value?.uid;

      if(uid == null){
        errorMessage.value = 'User is not logged in';
        return;
      }

      final fetchedOrders = await orderService.getOrdersByUser(uid);

      orders.assignAll(fetchedOrders);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createOrder({
    required List<Map<String, dynamic>> items,
    required double totalAmount,
}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final uid = authController.user.value?.uid;

      if(uid == null){
        errorMessage.value = 'User is not logged in';
        Get.snackbar('Login Required',
            'Please login before placing an order.',
        );
        return false;
      }

      final orderId = DateTime.now().millisecondsSinceEpoch.toString();

      final order = OrderModel(
          orderId: orderId,
          userId: uid,
          items: items,
          totalAmount: totalAmount,
          status: 'pending',
          createdAt: DateTime.now(),
      );

      await orderService.createOrder(order);

      orders.insert(0, order);

      Get.snackbar(
      'Success',
      'Order placed successfully',
      );
      return true;
    } catch (e) {
      errorMessage.value = e.toString();

      Get.snackbar(
      'Error',
      'Failed to place order',
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }
}