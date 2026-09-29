import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/admin_controller.dart';
import '../../models/order_model.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() =>
      _AdminOrdersScreenState();
}

class _AdminOrdersScreenState
    extends State<AdminOrdersScreen> {
  final AdminController adminController =
  Get.find<AdminController>();

  final TextEditingController searchController =
  TextEditingController();

  String searchQuery = '';
  String selectedStatus = 'All';

  final List<String> statuses = [
    'All',
    'pending',
    'processing',
    'shipped',
    'delivered',
    'cancelled',
  ];

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      setState(() {
        searchQuery =
            searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // =========================
  // FILTERED ORDERS
  // =========================

  List<OrderModel> get filteredOrders {
    return adminController.orders.where((order) {
      final matchesSearch =
          searchQuery.isEmpty ||
              order.orderId
                  .toLowerCase()
                  .contains(searchQuery) ||
              order.userId
                  .toLowerCase()
                  .contains(searchQuery);

      final matchesStatus =
          selectedStatus == 'All' ||
              order.orderStatus.toLowerCase() ==
                  selectedStatus.toLowerCase();

      return matchesSearch && matchesStatus;
    }).toList();
  }

  // =========================
  // BUILD
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
        centerTitle: true,
      ),
      body: Obx(() {
        // Initial loading
        if (adminController.isLoading.value &&
            adminController.orders.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Error
        if (adminController.errorMessage.value.isNotEmpty &&
            adminController.orders.isEmpty) {
          return _buildErrorView();
        }

        return RefreshIndicator(
          onRefresh:
          adminController.refreshDashboard,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSummaryCard(context),

              const SizedBox(height: 20),

              // Search
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText:
                  'Search Order ID or Customer ID',
                  prefixIcon:
                  const Icon(Icons.search),
                  suffixIcon:
                  searchQuery.isNotEmpty
                      ? IconButton(
                    onPressed: () {
                      searchController.clear();
                    },
                    icon:
                    const Icon(Icons.clear),
                  )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Status filter
              _buildStatusFilter(context),

              const SizedBox(height: 20),

              // Heading
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Orders',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${filteredOrders.length} orders',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .primary,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Orders
              if (filteredOrders.isEmpty)
                _buildEmptyView()
              else
                ...filteredOrders.map(
                      (order) => _buildOrderCard(
                    context,
                    order,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  // =========================
  // SUMMARY CARD
  // =========================

  Widget _buildSummaryCard(
      BuildContext context,
      ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor:
              Theme.of(context)
                  .colorScheme
                  .primaryContainer,
              child: Icon(
                Icons.shopping_bag_outlined,
                color: Theme.of(context)
                    .colorScheme
                    .primary,
              ),
            ),

            const SizedBox(width: 12),

            Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Orders',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  adminController.totalOrders
                      .toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Spacer(),

            Column(
              crossAxisAlignment:
              CrossAxisAlignment.end,
              children: [
                const Text(
                  'Revenue',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${adminController.totalRevenue.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context)
                        .colorScheme
                        .primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // STATUS FILTER
  // =========================

  Widget _buildStatusFilter(
      BuildContext context,
      ) {
    return DropdownButtonFormField<String>(
      value: selectedStatus,
      decoration: InputDecoration(
        labelText: 'Filter by Order Status',
        prefixIcon:
        const Icon(Icons.filter_list),
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(12),
        ),
      ),
      items: statuses.map((status) {
        return DropdownMenuItem<String>(
          value: status,
          child: Text(
            status == 'All'
                ? 'All Orders'
                : _formatStatus(status),
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value == null) return;

        setState(() {
          selectedStatus = value;
        });
      },
    );
  }

  // =========================
  // ORDER CARD
  // =========================

  Widget _buildOrderCard(
      BuildContext context,
      OrderModel order,
      ) {
    return Card(
      margin:
      const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        tilePadding:
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        childrenPadding:
        const EdgeInsets.fromLTRB(
          16,
          0,
          16,
          16,
        ),

        // Leading icon
        leading: CircleAvatar(
          backgroundColor:
          Theme.of(context)
              .colorScheme
              .primaryContainer,
          child: Icon(
            Icons.shopping_bag_outlined,
            color: Theme.of(context)
                .colorScheme
                .primary,
          ),
        ),

        // Title
        title: Text(
          'Order #${order.orderId}',
          maxLines: 1,
          overflow:
          TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        // Subtitle
        subtitle: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),

            Text(
              'Customer: ${order.userId}',
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              _formatDate(order.createdAt),
              style: TextStyle(
                fontSize: 12,
                color:
                Colors.grey.shade600,
              ),
            ),
          ],
        ),

        // Status
        trailing: _buildStatusBadge(
          context,
          order.orderStatus,
        ),

        children: [
          const Divider(),

          const SizedBox(height: 8),

          // Order ID
          _buildInfoRow(
            'Order ID',
            order.orderId,
          ),

          // Customer ID
          _buildInfoRow(
            'Customer ID',
            order.userId,
          ),

          // Order status
          _buildInfoRow(
            'Order Status',
            _formatStatus(
              order.orderStatus,
            ),
          ),

          // Payment status
          _buildPaymentStatusRow(
            context,
            order.paymentStatus,
          ),

          // Total
          _buildInfoRow(
            'Total Amount',
            '\$${order.totalAmount.toStringAsFixed(2)}',
          ),

          // Created date
          _buildInfoRow(
            'Created',
            _formatDate(order.createdAt),
          ),

          const SizedBox(height: 12),

          // Delivery Address
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Delivery Address',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 8),

          _buildAddressCard(
            order.deliveryAddress,
          ),

          const SizedBox(height: 16),

          // Order Items
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Order Items',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 8),

          if (order.items.isEmpty)
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'No items found.',
              ),
            )
          else
            ...order.items.map(
                  (item) => _buildItemCard(
                context,
                item,
              ),
            ),

          const SizedBox(height: 16),

          // Change Order Status
          _buildStatusDropdown(
            context,
            order,
          ),
        ],
      ),
    );
  }

  // =========================
  // ORDER ITEM
  // =========================

  Widget _buildItemCard(
      BuildContext context,
      Map<String, dynamic> item,
      ) {
    final title =
        item['title']?.toString() ??
            item['productName']?.toString() ??
            'Product';

    final quantity =
        item['quantity'] ?? 1;

    final rawPrice = item['price'] ?? 0;

    final double price =
    rawPrice is num
        ? rawPrice.toDouble()
        : double.tryParse(
      rawPrice.toString(),
    ) ??
        0;

    return Container(
      margin:
      const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest,
        borderRadius:
        BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: 22,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Quantity: $quantity',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                    Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Text(
            '\$${price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // PAYMENT STATUS
  // =========================

  Widget _buildPaymentStatusRow(
      BuildContext context,
      String status,
      ) {
    return Padding(
      padding:
      const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              'Payment',
              style: TextStyle(
                color:
                Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ),

          Expanded(
            child: Align(
              alignment:
              Alignment.centerLeft,
              child: Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _paymentStatusColor(
                    status,
                  ).withOpacity(0.12),
                  borderRadius:
                  BorderRadius.circular(20),
                ),
                child: Text(
                  _formatStatus(status),
                  style: TextStyle(
                    color:
                    _paymentStatusColor(
                      status,
                    ),
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // DELIVERY ADDRESS
  // =========================

  Widget _buildAddressCard(
      Map<String, dynamic> address,
      ) {
    if (address.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius:
          BorderRadius.circular(10),
        ),
        child: const Text(
          'No delivery address available.',
        ),
      );
    }

    final name =
        address['name']?.toString() ?? '';

    final phone =
        address['phone']?.toString() ?? '';

    final street =
        address['address']?.toString() ??
            address['street']?.toString() ??
            '';

    final city =
        address['city']?.toString() ?? '';

    final postalCode =
        address['postalCode']?.toString() ??
            address['zipCode']?.toString() ??
            '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius:
        BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          if (name.isNotEmpty)
            _addressRow(
              Icons.person_outline,
              name,
            ),

          if (phone.isNotEmpty)
            _addressRow(
              Icons.phone_outlined,
              phone,
            ),

          if (street.isNotEmpty)
            _addressRow(
              Icons.location_on_outlined,
              street,
            ),

          if (city.isNotEmpty)
            _addressRow(
              Icons.location_city_outlined,
              city,
            ),

          if (postalCode.isNotEmpty)
            _addressRow(
              Icons.markunread_mailbox_outlined,
              postalCode,
            ),

          if (name.isEmpty &&
              phone.isEmpty &&
              street.isEmpty &&
              city.isEmpty &&
              postalCode.isEmpty)
            const Text(
              'Address details unavailable.',
            ),
        ],
      ),
    );
  }

  Widget _addressRow(
      IconData icon,
      String text,
      ) {
    return Padding(
      padding:
      const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }

  // =========================
  // ORDER STATUS DROPDOWN
  // =========================

  Widget _buildStatusDropdown(
      BuildContext context,
      OrderModel order,
      ) {
    final currentStatus =
    order.orderStatus.toLowerCase();

    final dropdownValue =
    statuses.contains(currentStatus)
        ? currentStatus
        : 'pending';

    return DropdownButtonFormField<String>(
      value: dropdownValue,
      decoration: InputDecoration(
        labelText: 'Change Order Status',
        prefixIcon:
        const Icon(Icons.sync_outlined),
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(12),
        ),
      ),
      items: statuses
          .where(
            (status) => status != 'All',
      )
          .map((status) {
        return DropdownMenuItem<String>(
          value: status,
          child: Text(
            _formatStatus(status),
          ),
        );
      }).toList(),
      onChanged: (value) async {
        if (value == null ||
            value == currentStatus) {
          return;
        }

        await adminController
            .updateOrderStatus(
          order,
          value,
        );
      },
    );
  }

  // =========================
  // STATUS BADGE
  // =========================

  Widget _buildStatusBadge(
      BuildContext context,
      String status,
      ) {
    final color =
    _orderStatusColor(status);

    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: Text(
        _formatStatus(status),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  // =========================
  // INFO ROW
  // =========================

  Widget _buildInfoRow(
      String label,
      String value,
      ) {
    return Padding(
      padding:
      const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: TextStyle(
                color:
                Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // EMPTY VIEW
  // =========================

  Widget _buildEmptyView() {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        vertical: 60,
      ),
      child: Column(
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 55,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 12),

          const Text(
            'No orders found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            searchQuery.isNotEmpty ||
                selectedStatus != 'All'
                ? 'Try changing your search or filter.'
                : 'There are no orders yet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // ERROR VIEW
  // =========================

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(24),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 50,
            ),

            const SizedBox(height: 12),

            const Text(
              'Failed to load orders',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              adminController
                  .errorMessage.value,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed:
              adminController
                  .refreshDashboard,
              child:
              const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // HELPERS
  // =========================

  String _formatStatus(String status) {
    if (status.isEmpty) {
      return 'Unknown';
    }

    return status[0].toUpperCase() +
        status.substring(1).toLowerCase();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  Color _orderStatusColor(
      String status,
      ) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;

      case 'processing':
        return Colors.blue;

      case 'shipped':
        return Colors.indigo;

      case 'delivered':
        return Colors.green;

      case 'cancelled':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  Color _paymentStatusColor(
      String status,
      ) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;

      case 'pending':
        return Colors.orange;

      case 'failed':
        return Colors.red;

      case 'refunded':
        return Colors.purple;

      default:
        return Colors.grey;
    }
  }
}