import 'package:bodmas_wealth/auth/login_screen.dart';
import 'package:bodmas_wealth/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../start/start_screen.dart';

// AuthGate widget: decides which screen to show based on Firebase Auth status
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      // Stream that notifies when the user signs in, signs out, or updates
     // stream: FirebaseAuth.instance.userChanges(),

      builder: (context, snapshot) {

        // 1️⃣ Loading state: show a spinner while checking auth
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2️⃣ User is logged in
        if (snapshot.hasData) {


          return MainScreen();
        }

        // 3️⃣ User is logged out
        // Show the start / login screen
        return const LoginScreen();
      },
    );
  }
}
