import 'package:get/get.dart';

import '../models/order_model.dart';
import '../services/order_service.dart';
import 'auth_controller.dart';
import 'package:shop_flow_app/app/utils/app_snackbar.dart';
import '../services/notification_sender_service.dart';
import '../services/user_service.dart';

class OrderController extends GetxController {
  final OrderService orderService = OrderService();
  final NotificationSenderService notificationSender = NotificationSenderService();

  final UserService userService = UserService();
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
    required Map<String, dynamic> deliveryAddress,
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
        orderStatus: 'pending',
        paymentStatus: 'paid',
        createdAt: DateTime.now(),
        deliveryAddress: deliveryAddress,
      );

      await orderService.createOrder(order);

      orders.insert(0, order);

      for(final sellerId in sellerIds) {
        final sellerToken = await userService.getFcmToken(sellerId);
        if(sellerToken != null){
          await notificationSender.sendNotification(
              toToken: sellerToken,
              title: 'New Order Received',
              body: 'You have a new order worth \$${totalAmount.toStringAsFixed(2)}',
            data: {
                'type': 'order',
              'orderId': orderId,
            },
          );
        }
      }
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
      String orderStatus,
      ) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // UPDATE FIRESTORE
      await orderService.updateOrderStatus(
        orderId: order.orderId,
        orderStatus: orderStatus,
      );

      // UPDATE LOCAL SELLER ORDER
      final index = sellerOrders.indexWhere(
            (item) => item.orderId == order.orderId,
      );

      if (index != -1) {
        sellerOrders[index] =
            order.copyWith(orderStatus: orderStatus);
      }

      // NOTIFY CUSTOMER
      final customerToken = await userService.getFcmToken(order.userId);
      if (customerToken != null) {
        await notificationSender.sendNotification(
          toToken: customerToken,
          title: 'Order Update',
          body: 'Your order is now: $orderStatus',
          data: {'type': 'order', 'orderId': order.orderId},
        );
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