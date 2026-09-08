import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/auth_button_skeleton.dart';
import 'package:shop_flow_app/app/utils/app_snackbar.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() =>
      _SignupScreenState();
}

class _SignupScreenState
    extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController =
  TextEditingController();

  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;

  final AuthController authController =
  Get.find<AuthController>();

  String signupType = 'customer';

  @override
  void initState() {
    super.initState();

    // Login screen se seller argument aya hy
    if(Get.arguments == 'seller') {
      signupType = 'seller';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> signup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password =
    passwordController.text.trim();
    final confirmPassword =
    confirmPasswordController.text.trim();

    if (name.isEmpty) {
      AppSnackbar.show(
        'Error',
        'Please enter your name',
      );
      return;
    }

    if (email.isEmpty) {
      AppSnackbar.show(
        'Error',
        'Please enter your email',
      );
      return;
    }

    if (password.isEmpty) {
      AppSnackbar.show(
        'Error',
        'Please enter a password',
      );
      return;
    }

    if (confirmPassword.isEmpty) {
      AppSnackbar.show(
        'Error',
        'Please confirm your password',
      );
      return;
    }

    final success =
    await authController.signup(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      role: signupType == 'seller'
        ? 'seller'
          : 'user',
    );

    if (!success) {
      AppSnackbar.show(
        'Signup Failed',
        authController.errorMessage.value,
      );
    }

    // Successful signup navigation is already
    // handled inside AuthController.
  }

  @override
  Widget build(BuildContext context) {
    final isSeller = signupType == 'seller';

    return Scaffold(
      appBar: AppBar(
        title: Text(
            isSeller
            ? 'Seller Sign Up'
            : 'Create Account'),
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

              const SizedBox(height: 16,),

              Text(
                isSeller
                ? 'Create your seller account'
                 : 'Create your ShopFlow account',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              // Name
              TextField(
                controller: nameController,
                textInputAction:
                TextInputAction.next,
                decoration: InputDecoration(
                  labelText: isSeller
                  ? 'Seller Name'
                  : 'Full Name',
                  hintText: isSeller
                  ? 'Enter seller name'
                  : 'Enter your name',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // Email
              TextField(
                controller: emailController,
                keyboardType:
                TextInputType.emailAddress,
                textInputAction:
                TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // Password
              TextField(
                controller: passwordController,
                obscureText: isPasswordHidden,
                decoration: InputDecoration(
                  labelText: 'Create Password',
                  border:
                  const OutlineInputBorder(),
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

              const SizedBox(height: 16),

              // Confirm Password
              TextField(
                controller:
                confirmPasswordController,
                obscureText:
                isConfirmPasswordHidden,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border:
                  const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isConfirmPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        isConfirmPasswordHidden =
                        !isConfirmPasswordHidden;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Create Account
              Obx(
                    () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: authController
                      .isLoading.value
                      ? const AuthButtonSkeleton()
                      : ElevatedButton(
                    onPressed: signup,
                    child:  Text(
                      isSeller
                      ? 'Create Seller Account'
                      : 'Create Account',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Login
              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Text(
                    isSeller
                    ? 'Already a seller?'
                    : 'Already have an account?',
                  ),
                  TextButton(
                    onPressed: () {
                      Get.offNamed(
                        AppRoutes.login,
                        arguments: isSeller
                          ? 'seller'
                            : 'customer',
                      );
                    },
                    child: Text(
                        isSeller
                        ? 'Seller Login'
                        : 'Login'),
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