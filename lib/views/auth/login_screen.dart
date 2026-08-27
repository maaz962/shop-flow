import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../app/routes/app_routes.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/auth_button_skeleton.dart';



class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  final usernameController = TextEditingController(text: 'emilys');
  final passwordController = TextEditingController(text : 'emilyspass');
  final AuthController authController = Get.find<AuthController>();

  @override
  void dispose() {
     usernameController.dispose();
     passwordController.dispose();
     super.dispose();
  }

  Future<void> login() async {
    await authController.login(
      username: usernameController.text.trim(),
      password: passwordController.text.trim(),
    );

    if(authController.token.value.isNotEmpty) {
      Get.offNamed(AppRoutes.home);

      Get.snackbar('Success', 'Login successful');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),

        body: Padding(
            padding: const EdgeInsets.all(20),
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

                const SizedBox(height: 16),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 24),

                Obx(
                      () => SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: authController.isLoading.value
                        ? const AuthButtonSkeleton()
                        : ElevatedButton(
                      onPressed: login,
                      child: const Text('Login'),
                    ),
                  ),
                ),
              ],
            ),
        ),
    );
  }
}