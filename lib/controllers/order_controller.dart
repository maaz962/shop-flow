import 'package:get/get.dart';

import '../models/order_model.dart';
import '../services/order_service.dart';
import 'auth_controller.dart';
import 'package:shop_flow_app/app/utils/app_snackbar.dart';
class OrderController extends GetxController {
  final OrderService orderService = OrderService();

  final AuthController authController =
  Get.find<AuthController>();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Customer orders
  final orders = <OrderModel>[].obs;

  // Seller orders
  final sellerOrders = <OrderModel>[].obs;

  Future<void> getMyOrders() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final uid = authController.user.value?.uid;

      if (uid == null) {
        errorMessage.value =
        'User is not logged in';
        return;
      }

      final fetchedOrders =
      await orderService.getOrdersByUser(uid);

      orders.assignAll(fetchedOrders);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getSellerOrders() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final uid = authController.user.value?.uid;

      if (uid == null) {
        errorMessage.value =
        'User is not logged in';
        return;
      }

      final fetchedOrders =
      await orderService.getOrdersBySeller(uid);

      sellerOrders.assignAll(fetchedOrders);
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

      if (uid == null) {
        errorMessage.value =
        'User is not logged in';

        AppSnackbar.show(
          'Login Required',
          'Please login before placing an order.',
        );

        return false;
      }

      final sellerIds = items
          .map(
            (item) => item['ownerId'],
      )
          .where(
            (ownerId) =>
        ownerId != null &&
            ownerId.toString().isNotEmpty,
      )
          .map(
            (ownerId) => ownerId.toString(),
      )
          .toSet()
          .toList();

      final orderId =
      DateTime.now()
          .millisecondsSinceEpoch
          .toString();

      final order = OrderModel(
        orderId: orderId,
        userId: uid,
        sellerIds: sellerIds,
        items: items,
        totalAmount: totalAmount,
        status: 'pending',
        createdAt: DateTime.now(),
      );

      await orderService.createOrder(order);

      orders.insert(0, order);

      AppSnackbar.show(
        'Success',
        'Order placed successfully',
      );

      return true;
    } catch (e) {
      errorMessage.value = e.toString();

      AppSnackbar.show(
        'Error',
        'Failed to place order',
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateOrderStatus(
      OrderModel order,
      String status,
      ) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await orderService.updateOrderStatus(
        orderId: order.orderId,
        status: status,
      );

      final index = sellerOrders.indexWhere(
            (item) => item.orderId == order.orderId,
      );

      if (index != -1) {
        sellerOrders[index] =
            order.copyWith(status: status);
      }

      AppSnackbar.show(
        'Success',
        'Order status updated',
      );
    } catch (e) {
      errorMessage.value = e.toString();

      AppSnackbar.show(
        'Error',
        'Failed to update order status',
      );
    } finally {
      isLoading.value = false;
    }
  }
}