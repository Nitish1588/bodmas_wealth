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

      // Stream that notifies when the user signs in, signs out, or updates
      stream: FirebaseAuth.instance.userChanges(),

      builder: (context, snapshot) {

        // 1️⃣ Loading state: show a spinner while checking auth
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2️⃣ User is logged in
        if (snapshot.hasData) {
          // Navigate to main app screen
          // Using Navigator here to prevent "setState called after dispose" issues sometimes
          return Navigator(
            key: GlobalKey<NavigatorState>(), // Unique key for nested navigator
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (_) => Navigator(
                  onGenerateRoute: (innerSettings) {
                    return MaterialPageRoute(
                      builder: (_) => MainScreen(),
                    );
                  },
                ),
              );
            },
          );
        }

        // 3️⃣ User is logged out
        // Show the start / login screen
        return const StartScreen();
      },
    );
  }
}
