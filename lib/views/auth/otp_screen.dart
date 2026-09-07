import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../widgets/auth_button_skeleton.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() =>
      _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final otpController = TextEditingController();

  final AuthController authController =
  Get.find<AuthController>();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter OTP',
      );
      return;
    }

    if (otp.length != 6) {
      Get.snackbar(
        'Error',
        'Please enter a valid 6-digit OTP',
      );
      return;
    }

    final success =
    await authController.verifyOtp(otp);

    if (!success) {
      Get.snackbar(
        'OTP Failed',
        authController.errorMessage.value,
      );
    }

    // Successful navigation is already handled
    // inside AuthController.verifyOtp().
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),

              const Icon(
                Icons.sms_outlined,
                size: 70,
              ),

              const SizedBox(height: 20),

              Text(
                'Verify your phone number',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              const Text(
                'Enter the 6-digit code sent to your phone.',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              TextField(
                controller: otpController,
                keyboardType:
                TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'Enter OTP',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              Obx(
                    () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: authController
                      .isLoading.value
                      ? const AuthButtonSkeleton()
                      : ElevatedButton(
                    onPressed: verifyOtp,
                    child: const Text(
                      'Verify OTP',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}