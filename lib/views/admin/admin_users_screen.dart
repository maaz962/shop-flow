import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/admin_controller.dart';
import '../../models/user_model.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() =>
      _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final AdminController adminController =
  Get.find<AdminController>();

  final TextEditingController searchController =
  TextEditingController();

  String searchQuery = '';

  // final RxBool isUpdatingUser = false.obs;

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

  List<UserModel> get filteredUsers {
    if (searchQuery.isEmpty) {
      return adminController.users;
    }

    return adminController.users.where((user) {
      final name = user.name.toLowerCase();
      final email = user.email.toLowerCase();
      final role = user.role.toLowerCase();

      return name.contains(searchQuery) ||
          email.contains(searchQuery) ||
          role.contains(searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        centerTitle: true,
      ),

      body: Obx(
            () {
          if (adminController.isLoading.value &&
              adminController.users.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (adminController.errorMessage.value.isNotEmpty &&
              adminController.users.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Failed to load users',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      adminController.errorMessage.value,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        adminController.loadDashboardData();
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: adminController.refreshDashboard,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [

                // SUMMARY
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        context,
                        icon: Icons.people_outline,
                        title: 'Total Users',
                        value:
                        adminController.totalUsers.toString(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSummaryCard(
                        context,
                        icon: Icons.store_outlined,
                        title: 'Sellers',
                        value:
                        adminController.totalSellers.toString(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),


                // SEARCH
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search users...',
                    prefixIcon: const Icon(
                      Icons.search,
                    ),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                      onPressed: () {
                        searchController.clear();
                      },
                      icon: const Icon(
                        Icons.clear,
                      ),
                    )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 20),


                // SECTION TITLE
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'All Users',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${filteredUsers.length} users',
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // USER LIST
                if (filteredUsers.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 50,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.person_search_outlined,
                          size: 55,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.4),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No users found',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...filteredUsers.map(
                        (user) => _buildUserCard(
                      context,
                      user,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
      }) {
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
                icon,
                color: Theme.of(context)
                    .colorScheme
                    .primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
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
        ),
      ),
    );
  }

  Widget _buildUserCard(
      BuildContext context,
      UserModel user,
      ) {
    final isAdmin = user.role == 'admin';

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 6,
        ),

        // Profile icon
        leading: CircleAvatar(
          child: Text(
            user.name.isNotEmpty
                ? user.name[0].toUpperCase()
                : '?',
          ),
        ),

        // User information
        title: Text(
          user.name.isNotEmpty
              ? user.name
              : 'Unnamed User',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                user.email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                children: [
                  _buildRoleChip(
                    context,
                    user.role,

                  ),
                  _buildStatusChip(
                    context,
                    user.isActive,
                  ),
                ],
              ),
            ],
          ),
        ),

        // Actions
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'details') {
              _showUserDetails(
                context,
                user,
              );
            }

            if (value == 'status') {
              _confirmStatusChange(
                context,
                user,
              );
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
              if (!isAdmin)
                PopupMenuItem(
                  value: 'status',
                  child: Row(
                    children: [
                      Icon(
                        user.isActive
                            ? Icons.block
                            : Icons.check_circle_outline,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        user.isActive
                            ? 'Disable User'
                            : 'Enable User',
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

  Widget _buildRoleChip(
      BuildContext context,
      String role,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        role.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildStatusChip(
      BuildContext context,
      bool isActive,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 3,
      ),
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
          color: isActive
              ? Colors.green
              : Colors.red,
        ),
      ),
    );
  }

  void _showUserDetails(
      BuildContext context,
      UserModel user,
      ) {
    Get.defaultDialog(
      title: 'User Details',
      content: Column(
        children: [
          CircleAvatar(
            radius: 30,
            child: Text(
              user.name.isNotEmpty
                  ? user.name[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                fontSize: 22,
              ),
            ),
          ),

          const SizedBox(height: 16),

          _detailRow(
            'Name',
            user.name,
          ),

          _detailRow(
            'Email',
            user.email,
          ),

          _detailRow(
            'Role',
            user.role.toUpperCase(),
          ),

          _detailRow(
            'Status',
            user.isActive
                ? 'Active'
                : 'Disabled',
          ),

          _detailRow(
            'User ID',
            user.uid,
          ),
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
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              '$title:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
            ),
          ),
        ],
      ),
    );
  }


  void _confirmStatusChange(
      BuildContext context,
      UserModel user,
      ) {
    final bool newStatus = !user.isActive;

    final String dialogTitle =
    newStatus ? 'Enable User' : 'Disable User';

    final String message = newStatus
        ? 'Are you sure you want to enable ${user.name}?'
        : 'Are you sure you want to disable ${user.name}?';

    final String confirmText =
    newStatus ? 'Enable' : 'Disable';

    Get.defaultDialog(
      title: dialogTitle,
      middleText: message,
      textCancel: 'Cancel',
      textConfirm: confirmText,
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back();

        await adminController.updateUserStatus(
          user,
          newStatus,

        );
      },
    );
  }


}