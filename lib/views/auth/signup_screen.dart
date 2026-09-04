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
  // final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;
  final AuthController authController = Get.find<AuthController>();

  @override
  void dispose(){
    // usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> signup() async {
    final success = await authController.signup(
      // username: usernameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
      name: '',
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
          // TextField(
          //   controller: usernameController,
          //   decoration: const InputDecoration(
          //     labelText: 'Username',
          //     border: OutlineInputBorder(),
          //   ),
          // ),

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
            obscureText: isPasswordHidden,
            decoration:  InputDecoration(
              labelText: 'Create Password',
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
              )
            ),
          ),

          const SizedBox(height: 16,),
          TextField(
            controller: confirmPasswordController,
            obscureText: isPasswordHidden,
            decoration:  InputDecoration(
              labelText: 'Confirm Password',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                  icon: Icon(
                    isConfirmPasswordHidden
                    ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                onPressed: (){
                    setState(() {
                      isConfirmPasswordHidden = !isConfirmPasswordHidden;
                    });
                },
              )
            ),
          ),

          const SizedBox(height: 24),
          Obx (
              () => SizedBox(
                width: double.infinity,
                height: 50,
                child: authController.isLoading.value
                ? const AuthButtonSkeleton()
                : ElevatedButton(onPressed: signup,
                  child: const Text('Create Account'),
                ),
              ),
          ),

          const SizedBox(height: 16,),

          // Already have an account
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const Text(
                'Already have an account?',
              ),

              TextButton(
                onPressed: () {
                  Get.offNamed(AppRoutes.login,);
                },

                child: const Text(
                  'Login',
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}