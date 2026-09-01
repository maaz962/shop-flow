import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../app/routes/app_routes.dart';
import '../../widgets/auth_button_skeleton.dart';

class OtpScreen extends StatefulWidget{
  const OtpScreen({super.key});

  @override
State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>{
  final otpController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  @override
  void dispose(){
    otpController.dispose();
    super.dispose();
  }

  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();

    if(otp.isEmpty){
      Get.snackbar('Error', 'Please enter OTP',);
      return;
    }

    final success = await authController.verifyOtp(otp);
    if(success){
      Get.snackbar('Success', 'Phone login successful',);
      Get.offNamed(AppRoutes.home);
    } else {
      Get.snackbar('OTP FAILED',
      authController.errorMessage.value,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
      ),

      body: Padding(padding: const EdgeInsets.all(20),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: const InputDecoration(
              labelText: 'Enter OTP',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20,),

          Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50,
                child: authController.isLoading.value
                ? const AuthButtonSkeleton()
                : ElevatedButton(
                    onPressed: verifyOtp,
                    child: const Text('Verify OTP'),
                ),
              ),
          ),
        ],
      ),),
    );
  }
}