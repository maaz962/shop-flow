import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/admin_controller.dart';
import '../../models/user_model.dart';

class AdminSellersScreen extends StatefulWidget{
  const AdminSellersScreen({super.key});

  @override
  State<AdminSellersScreen> createState() => _AdminSellersScreenState();
}

class _AdminSellersScreenState extends State<AdminSellersScreen> {
  final AdminController adminController = Get.find<AdminController>();
  final TextEditingController searchController = TextEditingController();

  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<UserModel> get filteredSellers {
    if(searchQuery.isEmpty) {
      return adminController.sellers;
    }

    return adminController.sellers.where((seller) {
      final name = seller.name.toLowerCase();
      final email = seller.email.toLowerCase();

      return name.contains(searchQuery) || email.contains(searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Management'),
        centerTitle: true,
      ),
      body: Obx((){
        if (adminController.isLoading.value && adminController.sellers.isEmpty){
          return const Center(
            child: CircularProgressIndicator(),
);
        }

        if(adminController.errorMessage.value.isNotEmpty &&
        adminController.sellers.isEmpty){
          return Center(
            child: Padding(padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 50,
                ),
                const SizedBox(height: 12,),
                Text(
                  'Failed to load sellers',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8,),
                Text(
                  adminController.errorMessage.value,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16,),
                ElevatedButton(
                onPressed: () {
                  adminController.loadDashboardData();
                }, child: const Text('Try Again'),
                ),
              ],
            ),),
          );
        }

        return RefreshIndicator(onRefresh: adminController.refreshDashboard,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                //SUMMARY
                _buildSummaryCard(
                  context,
                  icon: Icons.store_outlined,
                  title: 'Total Sellers',
                  value: adminController.totalSellers.toString(),
                ),

                const SizedBox(height: 20,),

                //Search
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search sellers...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                      onPressed: () {
                        searchController.clear();
                      },
                      icon: const Icon(Icons.clear),
                    )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 20,),

                // SECTION TITLE
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'All Sellers',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${filteredSellers.length} sellers',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10,),

                // SELLER LIST
                if(filteredSellers.isEmpty)
                  Padding(padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Column(
                    children: [
                      Icon(
                        Icons.storefront_outlined,
                        size: 55,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                      ),
                      const SizedBox(height: 12,),
                      const Text(
                        'No sellers found',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),)
                else
                  ...filteredSellers.map(
                      (seller) => _buildSellerCard(context, seller),
                  ),
              ],
            ),
        );
      }),
    );
  }

  Widget _buildSummaryCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
  }
      ) {
    return Card(
      child: Padding(padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          const SizedBox(width: 12,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4,),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),),
    );
  }

  Widget _buildSellerCard(
      BuildContext context,
      UserModel seller,
      ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 6,
        ),

        // Profile Icon
        leading: CircleAvatar(
          child: Text(
            seller.name.isNotEmpty ? seller.name[0].toUpperCase() : '?',
          ),
        ),

        // Seller Information
        title: Text(
          seller.name.isNotEmpty ? seller.name : 'Unnamed Seller',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),

        subtitle: Padding(padding: const EdgeInsets.only(top: 5),
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            Text(
              seller.email,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6,),
            _buildStatusChip(context, seller.isActive),
          ],
        ),),

        // Actions
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'details') {
              _showSellerDetails(context, seller);
            }

            if (value == 'status') {
              _confirmStatusChange(context, seller);
            }
          },
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: 'details',
                child: Row(
                  children: [
                    Icon(Icons.info_outline),
                    SizedBox(width: 10),
                    Text('View Details'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'status',
                child: Row(
                  children: [
                    Icon(
                      seller.isActive
                          ? Icons.block
                          : Icons.check_circle_outline,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      seller.isActive ? 'Disable Seller' : 'Enable Seller',
                    ),
                  ],
                ),
              ),
            ];
          },
        ),
      ),
    );
  }

  Widget _buildStatusChip(
      BuildContext context,
      bool isActive,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.12)
            : Colors.red.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'ACTIVE' : 'DISABLED',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isActive ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  void _showSellerDetails(
      BuildContext context,
      UserModel seller,
      ) {
    Get.defaultDialog(
      title: 'Seller Details',
      content: Column(
        children: [
          CircleAvatar(
            radius: 30,
            child: Text(
              seller.name.isNotEmpty ? seller.name[0].toUpperCase() : '?',
              style: const TextStyle(fontSize: 22),
            ),
          ),
          const SizedBox(height: 16),
          _detailRow('Name', seller.name),
          _detailRow('Email', seller.email),
          _detailRow('Status', seller.isActive ? 'Active' : 'Disabled'),
          _detailRow('User ID', seller.uid),
        ],
      ),
      textConfirm: 'Close',
      onConfirm: () {
        Get.back();
      },
    );
  }

  Widget _detailRow(
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              '$title:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _confirmStatusChange(
      BuildContext context,
      UserModel seller,
      ) {
    final bool newStatus = !seller.isActive;

    final String dialogTitle = newStatus ? 'Enable Seller' : 'Disable Seller';

    final String message = newStatus
        ? 'Are you sure you want to enable ${seller.name}?'
        : 'Are you sure you want to disable ${seller.name}?';

    final String confirmText = newStatus ? 'Enable' : 'Disable';

    Get.defaultDialog(
      title: dialogTitle,
      middleText: message,
      textCancel: 'Cancel',
      textConfirm: confirmText,
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back();

        await adminController.updateUserStatus(seller, newStatus);
      },
    );
  }
}