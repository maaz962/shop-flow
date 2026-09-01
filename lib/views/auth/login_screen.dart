import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../app/routes/app_routes.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/auth_button_skeleton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();
  bool isPasswordHidden = true;

  final phoneController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                  onPressed: (){
                    setState(() {
                      isPasswordHidden = !isPasswordHidden;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 16,),

            ElevatedButton(onPressed: () async {
              final success = await authController.login(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );
              if(!success){
                Get.snackbar('Login failed',
                    authController.errorMessage.value,
                );
              }
            },
                child: const Text('Login'),
            ),

            const SizedBox(height: 16,),

            // google login
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50,

                child: authController.isLoading.value
                    ? const AuthButtonSkeleton()
                    : OutlinedButton.icon(
                        onPressed: () async {
                          final success = await authController.googleLogin();

                          if (success) {
                            Get.offNamed(AppRoutes.home);

                            Get.snackbar('Success', 'Google login successful');
                          } else {
                            Get.snackbar(
                              'Login Failed',
                              authController.errorMessage.value,
                            );
                          }
                        },

                        icon: const Icon(Icons.g_mobiledata, size: 30),

                        label: const Text(
                          'Continue with google',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: const [
                Expanded(child: Divider()),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('OR'),
                ),

                Expanded(child: Divider()),
              ],
            ),

            const SizedBox(height: 20),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: '+923001234567',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16,),

            // phone login
            SizedBox(
              width: double.infinity,
              height: 50,



              child: OutlinedButton.icon(
                onPressed: () async{
                  final phone = phoneController.text.trim();

                  if(phone.isEmpty){
                    Get.snackbar('Error',
                        'Please enter your phone number',
                    );
                    return;
                  }

                  final success = await authController.sendOtp(phone);
                  if(success){
                    Get.toNamed(AppRoutes.otp);
                  } else {
                    Get.snackbar(
                      'OTP Failed',
                      authController.errorMessage.value,
                    );
                  }

                },
                icon: const Icon(Icons.phone),

                label: const Text(
                  'Continue with phone',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // signup
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.signup);
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
