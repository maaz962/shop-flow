import 'package:shop_flow_app/main.dart';
import 'package:get/get.dart';
import 'package:shop_flow_app/views/auth/login_screen.dart';
import 'package:shop_flow_app/views/products/edit_product_screen.dart';
import '../../views/home/home_screen.dart';
import '../../views/splash/splash_screen.dart';
import '../../views/settings/settings_screen.dart';
import 'app_routes.dart';
import '../../views/products/add_product_screen.dart';
import '../../views/auth/login_screen.dart';
import '../../views/products/product_details_screen.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),

    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
    ),

    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
    ),

    GetPage(
      name: AppRoutes.addProduct,
      page: () => const AddProductScreen(),
    ),

    GetPage(
      name: AppRoutes.editProduct,
      page: () => EditProductScreen(product: Get.arguments,),
    ),

    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),


    GetPage(
      name: AppRoutes.productDetails,
      page: () => const ProductDetailsScreen(),
    ),


  ];
}