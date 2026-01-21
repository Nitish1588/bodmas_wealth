import 'package:bodmas_wealth/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../start/start_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(

      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Logged in
        if (snapshot.hasData) {
         // return const HomeScreen();
          return Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (_) => MainScreen(),

              );
            },
          );
        }


        // Logged out
        return const StartScreen();
      },
    );
  }
}
