import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/auth_button_skeleton.dart';
import 'package:shop_flow_app/app/utils/app_snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  final AuthController authController =
  Get.find<AuthController>();

  bool isPasswordHidden = true;

  // Customer or Seller
  String loginType = 'customer';

  @override
  void initState() {
    super.initState();

    // Welcome screen se seller argument aya hai
    if (Get.arguments == 'seller') {
      loginType = 'seller';
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSeller = loginType == 'seller';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSeller
              ? 'Seller Login'
              : 'Customer Login',
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              const SizedBox(height: 30),

              Icon(
                isSeller
                    ? Icons.store_outlined
                    : Icons.shopping_bag_outlined,
                size: 70,
              ),

              const SizedBox(height: 16),

              Text(
                isSeller
                    ? 'Login to Seller Account'
                    : 'Login to ShopFlow',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              // Email
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // Password
              TextField(
                controller: passwordController,
                obscureText: isPasswordHidden,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordHidden =
                        !isPasswordHidden;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Email Login
              Obx(
                    () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                    authController.isLoading.value
                        ? null
                        : () async {
                      final success =
                      await authController.login(
                        email:
                        emailController.text
                            .trim(),
                        password:
                        passwordController.text
                            .trim(),
                      );

                      if (!success) {
                        AppSnackbar.show(
                          'Login Failed',
                          authController
                              .errorMessage.value,
                        );
                      }
                    },
                    child:
                    authController.isLoading.value
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                        : const Text('Login'),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Google Login
              Obx(
                    () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: authController.isLoading.value
                      ? const AuthButtonSkeleton()
                      : OutlinedButton.icon(
                    onPressed: () async {
                      final success =
                      await authController
                          .googleLogin();

                      if (!success) {
                        AppSnackbar.show(
                          'Login Failed',
                          authController
                              .errorMessage.value,
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.g_mobiledata,
                      size: 30,
                    ),
                    label: const Text(
                      'Continue with Google',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // OR
              Row(
                children: const [
                  Expanded(
                    child: Divider(),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Text('OR'),
                  ),
                  Expanded(
                    child: Divider(),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Phone
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '+923001234567',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // Phone Login
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final phone =
                    phoneController.text.trim();

                    if (phone.isEmpty) {
                      AppSnackbar.show(
                        'Error',
                        'Please enter your phone number',
                      );
                      return;
                    }

                    final success =
                    await authController.sendOtp(
                      phone,
                    );

                    if (success) {
                      Get.toNamed(AppRoutes.otp);
                    } else {
                      AppSnackbar.show(
                        'OTP Failed',
                        authController
                            .errorMessage.value,
                      );
                    }
                  },
                  icon: const Icon(Icons.phone),
                  label: const Text(
                    'Continue with Phone',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Signup
              if (!isSeller)
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(
                          AppRoutes.signup,
                        );
                      },
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}