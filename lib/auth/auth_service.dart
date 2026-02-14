import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

// AuthService: handles all authentication operations
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;       // Firebase Auth instance
  final FirebaseFirestore _db = FirebaseFirestore.instance; // Firestore instance




  // =========================
  // GOOGLE SIGN IN
  // =========================
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger Google sign-in flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled sign-in
        throw Exception("Google sign-in cancelled");
      }

      // Get authentication tokens from Google
      final googleAuth = await googleUser.authentication;

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // Sign in to Firebase with Google credential
      final userCredential = await _auth.signInWithCredential(credential);

      // Check if user exists in Firestore (first-time login)
      final doc = await _db.collection("users").doc(userCredential.user!.uid).get();
      if (!doc.exists) {
        // Add new user to Firestore
        await _db.collection("users").doc(userCredential.user!.uid).set({
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

  // =========================
  // PHONE AUTH (OTP)
  // =========================
  String? _verificationId;

  // SEND OTP
  Future<void> sendOtp(String phone) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),

      // Auto verification (instant verification)
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.currentUser!.linkWithCredential(credential);
        await _markPhoneVerified(); // mark phone as verified in Firestore
      },

      // Verification failed
      verificationFailed: (FirebaseAuthException e) {
        throw Exception(e.message ?? "OTP verification failed");
      },

      // Code sent
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        debugPrint("OTP SENT");
      },

      // Timeout
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

    // Link OTP credential with current user
    await _auth.currentUser!.linkWithCredential(credential);
    await _markPhoneVerified(); // mark phone as verified
  }

  // MARK PHONE AS VERIFIED IN FIRESTORE
  Future<void> _markPhoneVerified() async {
    final uid = _auth.currentUser!.uid;
    await _db.collection("users").doc(uid).update({
      "phoneVerified": true,
    });
  }

  // =========================
  // EMAIL/PASSWORD SIGNUP
  // =========================
  Future<void> signup({
    required String name,
    required String mobile,
    required String email,
    required String password,
    required String userType,
  }) async {
    try {
      // Create user in Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add user info to Firestore
      await _db.collection("users").doc(userCredential.user!.uid).set({
        "name": name,
        "mobile": mobile,
        "email": email,
        "userType": userType,
        "phoneVerified": false, // initially false
        "createdAt": FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Signup failed");
    }
  }

  // =========================
  // EMAIL/PASSWORD LOGIN
  // =========================
  Future<void> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = cred.user!.uid;

      // Check if phone is verified
      final doc = await _db.collection("users").doc(uid).get();
      if (!doc.exists || doc["phoneVerified"] != true) {
        await _auth.signOut(); // force logout if phone not verified
        throw Exception("Mobile number not verified");
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Login failed");
    }
  }

  // =========================
  // RESET PASSWORD
  // =========================
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception("Failed to send reset email");
    }
  }

  // =========================
  // LOGOUT
  // =========================
  Future<void> logout() async {
    await _auth.signOut();
  }

  // =========================
  // CURRENT USER
  // =========================
  User? get currentUser => _auth.currentUser;
}
