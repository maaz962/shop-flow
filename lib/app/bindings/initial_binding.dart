import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../controllers/firestore_product_controller.dart';


class InitialBinding extends Bindings{
  @override
  void dependencies(){
    Get.put(ThemeController());
    Get.put(AuthController());
    Get.put(FirestoreProductController());
  }
}