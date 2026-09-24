import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/order_controller.dart';
import '../../models/order_model.dart';

class SellerOrdersScreen extends StatefulWidget {
  const SellerOrdersScreen({super.key});

  @override
  State<SellerOrdersScreen> createState() =>
      _SellerOrdersScreenState();
}

class _SellerOrdersScreenState
    extends State<SellerOrdersScreen> {
  final OrderController orderController =
  Get.find<OrderController>();

  @override
  void initState() {
    super.initState();
    orderController.getSellerOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Orders'),
      ),
      body: Obx(() {
        if (orderController.isLoading.value &&
            orderController.sellerOrders.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (orderController.errorMessage.value.isNotEmpty &&
            orderController.sellerOrders.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                orderController.errorMessage.value,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (orderController.sellerOrders.isEmpty) {
          return RefreshIndicator(
            onRefresh: orderController.getSellerOrders,
            child: ListView(
              physics:
              const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 200),
                Center(
                  child: Text(
                    'No orders yet.',
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: orderController.getSellerOrders,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount:
            orderController.sellerOrders.length,
            itemBuilder: (context, index) {
              final order =
              orderController.sellerOrders[index];

              return _OrderCard(
                order: order,
                onStatusChanged: (orderStatus) {
                  orderController.updateOrderStatus(
                    order,
                    orderStatus,
                  );
                },
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
  final Function(String) onStatusChanged;

  const _OrderCard({
    required this.order,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            // ORDER HEADER
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Order #${order.orderId}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // ORDER STATUS BADGE
                _OrderStatusBadge(
                  status: order.orderStatus,
                ),
              ],
            ),

            const SizedBox(height: 8),

            // DATE
            Text(
              'Date: ${_formatDate(order.createdAt)}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 12),

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

            const Divider(height: 24),

            // ORDER ITEMS
            ...order.items.map(
                  (item) {
                final title =
                    item['title'] ?? 'Product';

                final quantity =
                    item['quantity'] ?? 1;

                final price =
                (item['price'] ?? 0).toDouble();

                return Padding(
                  padding:
                  const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title.toString(),
                          maxLines: 2,
                          overflow:
                          TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        'x$quantity',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(width: 15),

                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const Divider(height: 24),

            // TOTAL
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${order.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ORDER STATUS DROPDOWN
            DropdownButtonFormField<String>(
              value: order.orderStatus,
              decoration: const InputDecoration(
                labelText: 'Order Status',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'pending',
                  child: Text('Pending'),
                ),
                DropdownMenuItem(
                  value: 'processing',
                  child: Text('Processing'),
                ),
                DropdownMenuItem(
                  value: 'shipped',
                  child: Text('Shipped'),
                ),
                DropdownMenuItem(
                  value: 'delivered',
                  child: Text('Delivered'),
                ),
                DropdownMenuItem(
                  value: 'cancelled',
                  child: Text('Cancelled'),
                ),
              ],
              onChanged: (value) {
                if (value != null &&
                    value != order.orderStatus) {
                  onStatusChanged(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
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
          fontSize: 11,
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