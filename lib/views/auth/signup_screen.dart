import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/auth_button_skeleton.dart';

class SignupScreen extends StatefulWidget{
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>{
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final AuthController authController = Get.find<AuthController>();

  @override
  void dispose(){
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> signup() async {
    final success = await authController.signup(
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
    );
    if(success){
      Get.toNamed(AppRoutes.login);
      Get.snackbar('Success', 'Signup successful. Please login.');
    } else {
      Get.snackbar('Signup Failed', authController.errorMessage.value,);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignUp'),
      ),

      body: Padding(padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height:16),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16,),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: 'Create Password',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16,),
          TextField(
            controller: confirmPasswordController,
            decoration: const InputDecoration(
              labelText: 'Confirm Password',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 24),
          Obx (
              () => SizedBox(
                width: double.infinity,
                height: 50,
                child: authController.isLoading.value
                ? const AuthButtonSkeleton()
                : ElevatedButton(onPressed: signup, child: const Text('Sign Up'),
                ),
              ),
          ),

        ],
      ),
      ),
    );
  }
}