import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/order_controller.dart';
import '../../models/order_model.dart';

class OrdersScreen extends StatefulWidget{
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrdersScreen> {
  final OrderController orderController = Get.find<OrderController>();

  @override
  void initState() {
    super.initState();

    orderController.getMyOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: Obx(() {
        if(orderController.isLoading.value){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if(orderController.orders.isEmpty){
          return _EmptyOrders();
        }

        return RefreshIndicator(
            onRefresh: orderController.getMyOrders,
            child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orderController.orders.length,
                itemBuilder: (context, index) {
                  final order = orderController.orders[index];

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
      child: Padding(padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Orders',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              _StatusBadge(
                status: order.status,
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            '#${order.orderId}',
            style: Theme.of(context)
            .textTheme
            .bodySmall,
          ),

          const SizedBox(height: 16),

          Text(
            '${order.items.length} item(s)',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

class _StatusBadge extends StatelessWidget {
  final String status;
   const _StatusBadge({
    required this.status,
});

   @override
  Widget build(BuildContext context){
     return Container(
       padding: const EdgeInsets.symmetric(
         horizontal: 10,
         vertical: 6,
       ),
       decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(20),
       ),
       child: Text(
         status.toUpperCase(),
         style: const TextStyle(
           fontSize: 12,
           fontWeight: FontWeight.bold,
         ),
       ),
     );
   }
}

class _EmptyOrders extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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