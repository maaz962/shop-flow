
import 'package:get/get.dart';
import 'package:shop_flow_app/views/auth/login_screen.dart';
import 'package:shop_flow_app/views/auth/otp_screen.dart';
import 'package:shop_flow_app/views/auth/signup_screen.dart';
import 'package:shop_flow_app/views/products/edit_product_screen.dart';
import 'package:shop_flow_app/views/profile/profile_screen.dart';
import '../../views/home/home_screen.dart';
import '../../views/splash/splash_screen.dart';
import '../../views/settings/settings_screen.dart';
import 'app_routes.dart';
import '../../views/products/add_product_screen.dart';
import '../../views/products/product_details_screen.dart';
import '../../views/wishlist/wishlist_screen.dart';
import '../../views/seller/seller_dashboard_screen.dart';
import '../../views/seller/my_products_screen.dart';
import '../../views/cart/cart_screen.dart';
import '../../views/welcome/welcome_screen.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),

             // customer
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
      name: AppRoutes.profileScreen,
      page: () =>  ProfileScreen(),
    ),

    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
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

    GetPage(
      name: AppRoutes.otp,
      page: () => const OtpScreen(),
    ),

             // Seller/ admin
    GetPage(
      name: AppRoutes.addProduct,
      page: () => const AddProductScreen(),
    ),

    GetPage(
      name: AppRoutes.editProduct,
      page: () => EditProductScreen(product: Get.arguments,),
    ),

    GetPage(
        name: AppRoutes.sellerDashboard,
        page: () => const SellerDashboardScreen(),
    ),

    GetPage(
      name: AppRoutes.myProducts,
      page: () => const MyProductsScreen(),
    ),

    GetPage(
        name: AppRoutes.cart,
        page: () => const CartScreen(),
    ),

    GetPage(
      name: AppRoutes.welcome,
      page: () => const WelcomeScreen(),
    ),

  ];
}