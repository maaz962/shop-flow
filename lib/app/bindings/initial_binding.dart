import 'package:get/get.dart';
import 'package:shop_flow_app/controllers/admin_controller.dart';
import 'package:shop_flow_app/controllers/order_controller.dart';
import 'package:shop_flow_app/controllers/store_profile_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../controllers/firestore_product_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../controllers/payment_controller.dart';


class InitialBinding extends Bindings{
  @override
  void dependencies(){
    Get.put(ThemeController());
    Get.put(AuthController());
    Get.put(FirestoreProductController());
    Get.put(OrderController());
    Get.put(CartController());
    Get.put(StoreProfileController());
    Get.put(WishlistController());
    Get.put(PaymentController());
    Get.lazyPut<AdminController>(() => AdminController());

  }
}