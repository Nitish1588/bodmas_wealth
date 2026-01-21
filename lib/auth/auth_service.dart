import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';



class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

//Google sign in
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
      await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception("Google sign-in cancelled");
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential =
      await _auth.signInWithCredential(credential);

      // Firestore user (only first time)
      final doc = await _db
          .collection("users")
          .doc(userCredential.user!.uid)
          .get();

      if (!doc.exists) {
        await _db.collection("users")
            .doc(userCredential.user!.uid)
            .set({
          "name": userCredential.user!.displayName,
          "email": userCredential.user!.email,
          "photo": userCredential.user!.photoURL,
          "loginType": "google",
          "createdAt": FieldValue.serverTimestamp(),
        });
      }

      return userCredential;
    } catch (e) {
      throw Exception(e.toString());
    }
  }



  String? _verificationId;

  // SEND OTP
  Future<void> sendOtp(String phone) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),

      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.currentUser!.linkWithCredential(credential);
        await _markPhoneVerified();
      },

      verificationFailed: (FirebaseAuthException e) {
        throw Exception(e.message ?? "OTP verification failed");
      },

      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        debugPrint("OTP SENT");
      },

      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
        debugPrint("OTP TIMEOUT");
      },
    );
  }


  // VERIFY OTP
  Future<void> verifyOtp(String otp) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );

    await _auth.currentUser!.linkWithCredential(credential);
    await _markPhoneVerified();
  }

  // UPDATE FIRESTORE FLAG
  Future<void> _markPhoneVerified() async {
    final uid = _auth.currentUser!.uid;
    await _db.collection("users").doc(uid).update({
      "phoneVerified": true,
    });
  }


  // SIGN UP
  Future<void> signup({
    required String name,
    required String mobile,
    required String email,

   // required String occupation,
    required String password,
    required String userType,
  }) async {
    try {
      final userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _db.collection("users").doc(userCredential.user!.uid).set({
        "name": name,
        "mobile": mobile,
        "email": email,
        "userType": userType,
        // "occupation": occupation,
        "phoneVerified": false,
        "createdAt": FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Signup failed");
    }
  }

  // LOGIN
  Future<void> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = cred.user!.uid;

      final doc = await _db.collection("users").doc(uid).get();

      if (!doc.exists || doc["phoneVerified"] != true) {
        await _auth.signOut(); // 🚨 force logout
        throw Exception("Mobile number not verified");
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Login failed");
    }
  }

  // RESET PASSWORD
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception("Failed to send reset email");
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  // CURRENT USER
  User? get currentUser => _auth.currentUser;
}
