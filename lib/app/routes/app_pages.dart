import 'package:get/get.dart';

// General
import 'package:shop_flow_app/views/splash/splash_screen.dart';
import 'package:shop_flow_app/views/welcome/welcome_screen.dart';

// Auth
import 'package:shop_flow_app/views/auth/login_screen.dart';
// import 'package:shop_flow_app/views/auth/otp_screen.dart';
import 'package:shop_flow_app/views/auth/signup_screen.dart';

// Customer
import 'package:shop_flow_app/views/home/home_screen.dart';
import 'package:shop_flow_app/views/products/product_details_screen.dart';
import 'package:shop_flow_app/views/wishlist/wishlist_screen.dart';
import 'package:shop_flow_app/views/cart/cart_screen.dart';
import 'package:shop_flow_app/views/checkout/checkout_screen.dart';
import 'package:shop_flow_app/views/orders/orders_screen.dart';
import 'package:shop_flow_app/views/profile/profile_screen.dart';
import 'package:shop_flow_app/views/settings/settings_screen.dart';

// Seller
import 'package:shop_flow_app/views/seller/seller_dashboard_screen.dart';
import 'package:shop_flow_app/views/products/add_product_screen.dart';
import 'package:shop_flow_app/views/products/edit_product_screen.dart';
import 'package:shop_flow_app/views/seller/my_products_screen.dart';
import 'package:shop_flow_app/views/seller/store_profile_screen.dart';
import 'package:shop_flow_app/views/seller/seller_orders_screen.dart';

// Admin
import 'package:shop_flow_app/views/admin/admin_dashboard_screen.dart';
import 'package:shop_flow_app/views/admin/admin_users_screen.dart';
import 'package:shop_flow_app/views/admin/admin_categories_screen.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    // General

    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),

    GetPage(
      name: AppRoutes.welcome,
      page: () => const WelcomeScreen(),
    ),

    // Auth

    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),

    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupScreen(),
    ),

    // GetPage(
    //   name: AppRoutes.otp,
    //   page: () => const OtpScreen(),
    // ),

    // Customer

    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
    ),

    GetPage(
      name: AppRoutes.productDetails,
      page: () => const ProductDetailsScreen(),
    ),

    GetPage(
      name: AppRoutes.wishlist,
      page: () => const WishlistScreen(),
    ),

    GetPage(
      name: AppRoutes.cart,
      page: () => const CartScreen(),
    ),

    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutScreen(),
    ),

    GetPage(
      name: AppRoutes.orders,
      page: () => const OrdersScreen(),
    ),

    GetPage(
      name: AppRoutes.profileScreen,
      page: () => ProfileScreen(),
    ),

    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
    ),

    // Seller

    GetPage(
      name: AppRoutes.sellerDashboard,
      page: () => const SellerDashboardScreen(),
    ),

    GetPage(
      name: AppRoutes.addProduct,
      page: () => const AddProductScreen(),
    ),

    GetPage(
      name: AppRoutes.editProduct,
      page: () => EditProductScreen(
        product: Get.arguments,
      ),
    ),

    GetPage(
      name: AppRoutes.myProducts,
      page: () => const MyProductsScreen(),
    ),

    GetPage(
      name: AppRoutes.storeProfile,
      page: () => StoreProfileScreen(),
    ),

    GetPage(
      name: AppRoutes.sellerOrders,
      page: () => const SellerOrdersScreen(),
    ),

    // Admin

    GetPage(
      name: AppRoutes.adminDashboard,
      page: () => const AdminDashboardScreen(),
    ),

    GetPage(
      name: AppRoutes.adminUsers,
      page: () => const AdminUsersScreen(),
    ),

    // Admin Categories

    GetPage(
      name: AppRoutes.adminCategories,
      page: () => AdminCategoriesScreen(),
    ),
  ];
}