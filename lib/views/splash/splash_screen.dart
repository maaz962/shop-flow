import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{

  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 2),
        () {
        Get.offNamed(AppRoutes.home);
        },
    );
  }

  @override
  Widget build(BuildContext context){
    return const Scaffold(
      body: Center(
        child: Text(
          'ShopFlow',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}