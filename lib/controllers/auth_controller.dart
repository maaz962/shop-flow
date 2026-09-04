import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shop_flow_app/app/routes/app_routes.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService authService = AuthService();
  final UserService userService = UserService();
  final userModel = Rxn<UserModel>();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final verificationId = ''.obs;

  // Current Firebase user
  final user = Rxn<User>();

  @override
  void onInit() {
    super.onInit();

    // Firebase user state listen karega
    authService.authStateChanges.listen((firebaseUser) {
      user.value = firebaseUser;
    });
  }
  

  Future<bool> signup({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Password validation
      if (password != confirmPassword) {
        errorMessage.value = 'Passwords do not match';
        return false;
      }

      // Password length validation
      if (password.length < 6) {
        errorMessage.value =
        'Password must be at least 6 characters';
        return false;
      }

      // Firebase signup
      final userCredential = await authService.signUpWithEmail(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        errorMessage.value = 'Signup failed';
        return false;
      }

      // Firestore UserModel
      final newUser = UserModel(
        uid: firebaseUser.uid,
        name: name,
        email: email,
        role: 'user'
      );

      // users/{uid} document
      await userService.createUser(newUser);

      userModel.value = newUser;

      Get.snackbar('Success', 'Account created successfully',);

      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _firebaseErrorMessage(e);
      return false;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }



  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final userCredential = await authService.loginWithEmail(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        errorMessage.value = 'Login failed';
        return false;
      }

      Get.snackbar('Success', 'Login successful',);
      Get.offNamed(AppRoutes.home);
      return true;
    }
    on FirebaseAuthException catch (e) {
      errorMessage.value = _firebaseErrorMessage(e);
      return false;
    }
    catch (e) {
      errorMessage.value = e.toString();
      return false;
    }
    finally {
      isLoading.value = false;
    }
  }



  Future<bool> googleLogin() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final userCredential =
      await authService.signInWithGoogle();

      // if (userCredential == null) {
      //   errorMessage.value = 'Google login cancelled';
      //   return false;
      // }

      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _firebaseErrorMessage(e);
      return false;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> sendOtp(String phoneNumber) async {
    try{
      isLoading.value = true;
      errorMessage.value = '';

      final id = await authService.sendOtp(
          phoneNumber: phoneNumber,
      );

      if(id == null){
        errorMessage.value = 'Could not send OTP';
        return false;
      }

      verificationId.value = id;
      return true;

    }
    on FirebaseAuthException catch(e) {

      print('CODE: ${e.code}');
      print('MESSAGE: ${e.message}');

      errorMessage.value = _firebaseErrorMessage(e);
      return false;
    }
    catch (e) {
      errorMessage.value = e.toString();
      return false;
    }
    finally{
      isLoading.value= false;
    }
  }

  Future<bool> verifyOtp(String smsCode) async{
    try{
      isLoading.value = true;
      errorMessage.value = '';

      await authService.verifyOtp(
          verificationId: verificationId.value,
          smsCode: smsCode,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _firebaseErrorMessage(e);
      return false;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> logout() async {
    try {
      await authService.logout();

      user.value = null;
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }
  

  bool get isLoggedIn {
    return user.value != null;
  }
  

  String _firebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Please enter a valid email address';

      case 'user-not-found':
        return 'No account found with this email';

      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password';

      case 'email-already-in-use':
        return 'This email is already registered';

      case 'weak-password':
        return 'Password is too weak';

      case 'network-request-failed':
        return 'Please check your internet connection';

      case 'user-disabled':
        return 'This account has been disabled';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later';

      case 'operation-not-allowed':
        return 'This authentication method is not enabled';

      default:
        return e.message ?? 'Authentication failed';
    }
  }
}




