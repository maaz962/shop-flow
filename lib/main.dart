import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'app/bindings/initial_binding.dart';
import 'app/theme/app_theme.dart';
import 'controllers/theme_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, );
  runApp(const ShopFlowApp());
}

class ShopFlowApp extends StatelessWidget {
  const ShopFlowApp({super.key});

  @override
  Widget build(BuildContext context){
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'ShopFlow',

      initialBinding: InitialBinding(),

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,

    );
  }
}

// class HomeScreen extends StatelessWidget{
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context){
//     final themeController = Get.find<ThemeController>();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('ShopFlow'),
//
//
//       actions: [
//         Obx(
//             () => IconButton(
//               onPressed: themeController.toggleTheme,
//               icon: Icon(
//                 themeController.isDarkMode.value
//                     ? Icons.light_mode
//                     : Icons.dark_mode,
//               ),
//             ),
//         ),
//       ],
//     ),
//       body:  Center(
//         child: Obx(
//           () => Text(
//             themeController.isDarkMode.value
//                 ? 'Dark Mode'
//                 : 'Light Mode',
//
//         style: TextStyle(
//           fontSize: 28,
//           fontWeight: FontWeight.bold,
//         ),),
//       ),
//       ),
//
//     );
//   }
// }