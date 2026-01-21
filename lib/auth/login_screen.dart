import 'package:bodmas_wealth/auth/forgot_password_screen.dart';
import 'package:bodmas_wealth/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'widgets/auth_text_field.dart';
import 'auth_service.dart';


import '../core/colors.dart';


// Login screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _password = TextEditingController();

  final _authService = AuthService();

  bool _loading = false;

  // login action
  void _handleLogin() async {

    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {

      await _authService.login(
        _email.text.trim(),
        _password.text.trim(),
      );

      // Only show SnackBar if the widget is still mounted
     if (!mounted) return;



      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Login Successful")));



    } catch (e) {

      // minimal error handling
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() => _loading = false);
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),   // light white background
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Icon(
            Icons.person_outline_outlined,
            color: Color (0xFF9144FF),   // purple icon color
            size: 60,
          ),
        ),

              const SizedBox(height: 20),

              const Text(
                "Access My Account",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFDDDDDD),
                ),
              ),
              const SizedBox(height: 20),

              AuthTextField(
                label: "Email",
                controller: _email,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              AuthTextField(
                label: "Password",
                controller: _password,
                isPassword: true,
              ),

              const SizedBox(height: 10),



              Align(
                alignment: Alignment.centerRight, // Aligns the button to the right
                child: TextButton(
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                    );

                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Color (0xFFA684FF), // Text color
                    textStyle: const TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      decorationColor: Color (0xFFA684FF),
                    ),
                    minimumSize: Size.zero, // Shrinks button to fit child
                    padding: EdgeInsets.zero, // Removes extra padding
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Ensures tap area matches text
                  ),
                  child: const Text('Forgot Password?'),
                ),
              ),
              const SizedBox(height: 15),



              SizedBox(
                width: double.infinity, // Sets the width
                height: 50, // Optional: specify a fixed height
                child: ElevatedButton(
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
                  onPressed: _loading ? null : _handleLogin,
                  child: _loading ? const CircularProgressIndicator() : const Text("Login"),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity, // Sets the width
                height: 50, // Optional: specify a fixed height
                child: ElevatedButton(
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    // Set the background color of the button
                    backgroundColor: Color(0xFF9144FF),

                    // Set the text color (foreground color)
                    foregroundColor: Color(0xFFDDDDDD),
                    textStyle: TextStyle(
                      fontSize: 15.0, //  font size here
                      fontWeight: FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text("Create Account"),
                ),
              ),

              const SizedBox(height: 15),


            ],
          ),
        ),
      ),
    );
  }
}
