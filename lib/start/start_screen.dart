import 'package:bodmas_wealth/auth/auth_service.dart';
import 'package:bodmas_wealth/auth/login_screen.dart';

import 'package:flutter/material.dart';
import '../core/colors.dart';


// This is the first screen of your app
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // logo here with gradient and container
            Container(
              width: 150,
              // height: 64,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [

                    Color(0xFFB974FF),
                    Color(0xFFFFFFFF),

                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Image.asset(
                  'assets/images/logo.webp',
                  fit: BoxFit.contain,
                ),
              ),
            ),


            const SizedBox(height: 10),
            const Text(
              "Welcome To Bodmas Wealth",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: AppColors.text_2,
              ),
            ),

            const SizedBox(height: 15),

            // Button to start authentication flow
            SizedBox(
              width: 200, // Sets the width
              height: 50, // Optional: specify a fixed height
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );

                },
                style: ElevatedButton.styleFrom(
                  // Set the background color of the button
                  backgroundColor: Color(0xFFFFFFFF),

                  // Set the text color (foreground color)
                  foregroundColor: Color(0xFF9144FF),
                  textStyle: TextStyle(
                    fontSize: 15.0, //  font size here
                    fontWeight: FontWeight.w500,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text("Login / Signup"),
              ),
            ),

            const SizedBox(height: 10),



            // Button to start as a guest
            // SizedBox(
            //   width: 200, // Sets the width
            //   height: 50, //
            //   child: ElevatedButton(
            //
            //     onPressed: () {
            //
            //       // Navigator.pushNamed(context, AppRoutes.home);
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         const SnackBar(content: Text("Guest Access")),
            //       );
            //     },
            //       style: ElevatedButton.styleFrom(
            //         // Set the background color of the button
            //         backgroundColor: Color(0xFF9144FF),
            //
            //         // Set the text color (foreground color)
            //         foregroundColor: Color(0xFFDDDDDD),
            //         textStyle: TextStyle(
            //           fontSize: 15.0, //  font size here
            //           fontWeight: FontWeight.w500,
            //         ),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10.0),
            //         ),
            //       ),
            //     child: const Text("Continue as Guest"),
            //   ),
            // ),



            const SizedBox(height: 20),

            GestureDetector(
              onTap: () async {
                final auth = AuthService();

                try {
                  await auth.signInWithGoogle();

                  if (!context.mounted) return;

                 // Navigator.pushReplacementNamed(context, AppRoutes.home);

                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    "assets/images/google.jpg",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),



          ],
        ),
      ),

    );
  }

}

