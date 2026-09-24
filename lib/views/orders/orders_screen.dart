import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/order_controller.dart';
import '../../models/order_model.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrdersScreen> {
  final OrderController orderController =
  Get.find<OrderController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      orderController.getMyOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: Obx(() {
        if (orderController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (orderController.orders.isEmpty) {
          return _EmptyOrders();
        }

        return RefreshIndicator(
          onRefresh: orderController.getMyOrders,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orderController.orders.length,
            itemBuilder: (context, index) {
              final order =
              orderController.orders[index];

              return _OrderCard(
                order: order,
              );
            },
          ),
        );
      }),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;

  const _OrderCard({
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ORDER HEADER
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Order',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // ORDER STATUS
                _OrderStatusBadge(
                  status: order.orderStatus,
                ),
              ],
            ),

            const SizedBox(height: 8),

            // ORDER ID
            Text(
              '#${order.orderId}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall,
            ),

            const SizedBox(height: 16),

            // PAYMENT STATUS
            Row(
              children: [
                const Text(
                  'Payment: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                _PaymentStatusBadge(
                  status: order.paymentStatus,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ORDER STATUS
            Row(
              children: [
                const Text(
                  'Order Status: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  order.orderStatus.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ITEMS
            Text(
              '${order.items.length} item(s)',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            // TOTAL
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total'),
                Text(
                  '\$${order.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // DATE
            Text(
              _formatDate(order.createdAt),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// ORDER STATUS BADGE
class _OrderStatusBadge extends StatelessWidget {
  final String status;

  const _OrderStatusBadge({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _getOrderStatusColor(status)
            .withOpacity(0.12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: _getOrderStatusColor(status),
        ),
      ),
    );
  }

  Color _getOrderStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return Colors.orange;

      case 'shipped':
        return Colors.blue;

      case 'delivered':
        return Colors.green;

      case 'cancelled':
        return Colors.red;

      case 'pending':
      default:
        return Colors.grey;
    }
  }
}

// PAYMENT STATUS BADGE
class _PaymentStatusBadge extends StatelessWidget {
  final String status;

  const _PaymentStatusBadge({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _getPaymentStatusColor(status)
            .withOpacity(0.12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: _getPaymentStatusColor(status),
        ),
      ),
    );
  }

  Color _getPaymentStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;

      case 'failed':
        return Colors.red;

      case 'pending':
      default:
        return Colors.orange;
    }
  }
}

// EMPTY ORDERS
class _EmptyOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.receipt_long_outlined,
              size: 80,
            ),

            const SizedBox(height: 16),

            Text(
              'No Orders yet',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Your orders will appear here',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}