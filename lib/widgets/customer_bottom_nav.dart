import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shop_flow_app/app/routes/app_routes.dart';
import 'package:shop_flow_app/app/theme/app_theme.dart';
import 'package:shop_flow_app/controllers/cart_controller.dart';

class CustomerBottomNav extends StatelessWidget {
  const CustomerBottomNav({
    super.key,
    required this.currentIndex,
  });

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final glassColor = isDark
        ? AppColors.glassDark
        : AppColors.glassLight;

    final inactiveColor = isDark
        ? AppColors.textOnDarkMuted
        : AppColors.textOnLightMuted;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: glassColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10,
            sigmaY: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home
              _buildNavItem(
                context: context,
                index: 0,
                icon: Icons.home,
                activeColor: AppColors.green,
                inactiveColor: inactiveColor,
                onTap: () {
                  if (currentIndex != 0) {
                    Get.offNamed(AppRoutes.home);
                  }
                },
              ),

              // Wishlist
              _buildNavItem(
                context: context,
                index: 1,
                icon: Icons.favorite_border,
                activeColor: AppColors.green,
                inactiveColor: inactiveColor,
                onTap: () {
                  if (currentIndex != 1) {
                    Get.offNamed(AppRoutes.wishlist);
                  }
                },
              ),

              // Cart
              _buildCartItem(
                context: context,
                index: 2,
                activeColor: AppColors.green,
                inactiveColor: inactiveColor,
                cartController: cartController,
              ),

              // Profile
              _buildNavItem(
                context: context,
                index: 3,
                icon: Icons.person_outline,
                activeColor: AppColors.green,
                inactiveColor: inactiveColor,
                onTap: () {
                  if (currentIndex != 3) {
                    Get.offNamed(AppRoutes.profileScreen);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required Color activeColor,
    required Color inactiveColor,
    required VoidCallback onTap,
  }) {
    final isActive = currentIndex == index;

    if (isActive) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: activeColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      );
    }

    return IconButton(
      onPressed: onTap,
      icon: Icon(
        icon,
        color: inactiveColor,
      ),
    );
  }

  Widget _buildCartItem({
    required BuildContext context,
    required int index,
    required Color activeColor,
    required Color inactiveColor,
    required CartController cartController,
  }) {
    final isActive = currentIndex == index;

    final icon = isActive
        ? Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: activeColor,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.shopping_cart_outlined,
        color: Colors.white,
      ),
    )
        : Icon(
      Icons.shopping_cart_outlined,
      color: inactiveColor,
    );

    return Obx(
          () => Stack(
        clipBehavior: Clip.none,
        children: [
          isActive
              ? InkWell(
            onTap: () {
              if (!isActive) {
                Get.offNamed(AppRoutes.cart);
              }
            },
            borderRadius: BorderRadius.circular(50),
            child: icon,
          )
              : IconButton(
            onPressed: () {
              Get.offNamed(AppRoutes.cart);
            },
            icon: icon,
          ),

          if (cartController.itemCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${cartController.itemCount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}