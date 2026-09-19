import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shop_flow_app/app/routes/app_routes.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'package:shop_flow_app/app/utils/app_snackbar.dart';
import '../models/address_model.dart';

class AuthController extends GetxController {
  final AuthService authService = AuthService();
  final UserService userService = UserService();
  final userModel = Rxn<UserModel>();
  // Current Firebase user
  final user = Rxn<User>();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  // final verificationId = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Firebase user state listen karega
    authService.authStateChanges.listen((firebaseUser) async {
      user.value = firebaseUser;

      if(firebaseUser != null){
        await loadUserData();
      } else {
        userModel.value = null;
      }
    });
  }

  // Update user's default address
  Future<bool> updateDefaultAddress(AddressModel address) async {
    try{
      final currentUser = userModel.value;

      if(currentUser == null) {
        errorMessage.value  = 'User not found';
        return false;
      }

      final updatedUser = currentUser.copyWith(defaultAddress: address);

      await userService.updateUser(updatedUser);

      userModel.value = updatedUser;
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    }
  }

// SIGNUP
  Future<bool> signup({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String role,
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

      // Firestore UserModel , customer/user
      final newUser = UserModel(
        uid: firebaseUser.uid,
        name: name,
        email: email,
        role: role,
      );

      // users/{uid} document
      await userService.createUser(newUser);

      userModel.value = newUser;

      AppSnackbar.show(
        'Success',
        role == 'seller'
            ? 'Seller account created successfully'
        : 'Account created successfully',
      );

      // Role based navigation
      await navigateByRole();

      return true;

      // customer home
      Get.offNamed(AppRoutes.home);

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

  // User data fetch krna
  Future<void> loadUserData() async {
    try {
      final firebaseUser = authService.currentUser;

      if(firebaseUser == null) {
        userModel.value = null;
        return;
      }

      final data = await userService.getUser(
        firebaseUser.uid,
      );

      userModel.value = data;
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  // LOGIN
  Future<bool> login({
    required String email,
    required String password,
    required String loginType,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final userCredential = await authService.loginWithEmail(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        errorMessage.value = 'Login failed';
        return false;
      }

      // firebase login ky baad
      // firestore user data load kro
      await loadUserData();

      if(userModel.value == null) {
        errorMessage.value = 'User profile not found';
        return false;
      }

      if(userModel.value == null) {
        errorMessage.value = 'User profile not found';
        return false;
      }
      // Disabled account check
      if(userModel.value!.isActive == false) {
        await authService.logout();

        user.value = null;
        userModel.value = null;

        errorMessage.value = 'Your account has been disabled. Please contact support.';

        return false;
      }

      final role = userModel.value!.role;

      // Seller login mein seller account required
      if(loginType == 'seller' && role != 'seller') {
        await authService.logout();

        user.value = null;
        userModel.value = null;

        errorMessage.value = 'This is not a seller account. Please use Seller Sign Up.';

        return false;
      }

      // Customer login me customer account required
      if(loginType == 'customer' && role != 'user' && role != 'admin') {
        await authService.logout();

        user.value = null;
        userModel.value = null;

        errorMessage.value = 'This account is not a customer account.';

        return false;
      }

      AppSnackbar.show('Success', 'Login successful',);

      // role ky according navigation
      await navigateByRole();

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

  // role based navigation
  Future<void> navigateByRole() async{
    final role = userModel.value?.role;

    if(role == 'admin') {
      Get.offNamed(AppRoutes.adminDashboard);
    } else if (role == 'seller') {
      Get.offNamed(AppRoutes.sellerDashboard);
    } else {
      Get.offNamed(AppRoutes.home);
    }

  }

  // google login
  Future<bool> googleLogin({
    required String loginType,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final userCredential =
      await authService.signInWithGoogle();

      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        errorMessage.value = 'Google login cancelled';
        return false;
      }

      // Existing firestore profile load kro
      await loadUserData();

      if(userModel.value == null) {
        await authService.logout();

        errorMessage.value = 'User profile not found. Please use email signup first.';
        return false;
      }

      // Disabled account check
      if(userModel.value!.isActive == false) {
        await authService.logout();

        user.value = null;
        userModel.value= null;
        errorMessage.value = 'Your account has been disabled. Please contact support.';
        return false;
      }
      final role = userModel.value!.role;

      //Seller google login
      if(loginType == 'seller' && role != 'seller'){
        await authService.logout();

        user.value = null;
        userModel.value = null;

        errorMessage.value = 'This google account is not registered as a seller.';

        return false;
      }

      // Customer google login
      if(loginType == 'customer' && role != 'user' && role != 'admin'){
        await authService.logout();

        user.value = null;
        userModel.value = null;

        errorMessage.value = 'This account is not a customer account.';
        return false;
      }

      AppSnackbar.show(
        'Success',
        'Login successfully',
      );

      await navigateByRole();

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

  // // send otp
  // Future<bool> sendOtp(String phoneNumber) async {
  //   try{
  //     isLoading.value = true;
  //     errorMessage.value = '';
  //
  //     final id = await authService.sendOtp(
  //         phoneNumber: phoneNumber,
  //     );
  //
  //     if(id == null){
  //       errorMessage.value = 'Could not send OTP';
  //       return false;
  //     }
  //
  //     verificationId.value = id;
  //     return true;
  //
  //   }
  //   on FirebaseAuthException catch(e) {
  //
  //     // print('CODE: ${e.code}');
  //     // print('MESSAGE: ${e.message}');
  //
  //     errorMessage.value = _firebaseErrorMessage(e);
  //     return false;
  //   }
  //   catch (e) {
  //     errorMessage.value = e.toString();
  //     return false;
  //   }
  //   finally{
  //     isLoading.value= false;
  //   }
  // }
  //
  // // verify OTP
  // Future<bool> verifyOtp(String smsCode) async{
  //   try{
  //     isLoading.value = true;
  //     errorMessage.value = '';
  //
  //     await authService.verifyOtp(
  //         verificationId: verificationId.value,
  //         smsCode: smsCode,
  //     );
  //
  //     // otp login ke baad user data load
  //     await loadUserData();
  //
  //     if(userModel.value == null) {
  //       errorMessage.value = 'User profile not found';
  //       return false;
  //     }
  //
  //     await navigateByRole();
  //
  //     return true;
  //   } on FirebaseAuthException catch (e) {
  //     errorMessage.value = _firebaseErrorMessage(e);
  //     return false;
  //   } catch (e) {
  //     errorMessage.value = e.toString();
  //     return false;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // logout
  Future<void> logout() async {
    try {
      await authService.logout();

      user.value = null;
      userModel.value = null;

      Get.offAllNamed(
        AppRoutes.login,
      );
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }
  

  // GETTERS
  bool get isLoggedIn {
    return user.value != null;
  }

  bool get isAdmin{
    return userModel.value?.role == 'admin';
  }

  bool get isSeller {
    return userModel.value?.role == 'seller'; }

  bool get isUser{
    return userModel.value?.role == 'user';
  }
  

  // firebase error messages
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




