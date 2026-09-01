import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithGoogle() async {
    // 🌐 WEB
    if (kIsWeb) {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();

      return await _auth.signInWithPopup(googleProvider);
    }

    // 📱 ANDROID
    final GoogleSignInAccount? googleUser =
    await GoogleSignIn.instance.authenticate();

    if (googleUser == null) {
      throw Exception('Google Sign-In cancelled');
    }

    final GoogleSignInAuthentication googleAuth =
        googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  Future<void> logout() async {
    await _auth.signOut();

    if (!kIsWeb) {
      await GoogleSignIn.instance.signOut();
    }
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
}) async {
    return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password);
  }


  Future<UserCredential> loginWithEmail({
    required String email,
    required String password})
  async {
    return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password);
  }

  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
}) async {
    await _auth.verifyPhoneNumber( phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e){
      throw e;
        },
        codeSent: (String verificationId, int? resendToken){
      onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId){

        },
    );
  }

  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String smsCode,
}) async {
    final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,);
    return await _auth.signInWithCredential(credential);
  }

}