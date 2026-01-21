import 'package:bodmas_wealth/auth/auth_gate.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const RootApp());

}

// Root widget
class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(


    theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF9144FF), // Purple
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.w500,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
     //onGenerateRoute: AppRoutes.onGenerateRoute,  // Now app begins here
    );
  }
}
