import 'package:bodmas_wealth/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'widgets/auth_text_field.dart';
import 'auth_service.dart';
import '../core/colors.dart';

// Forgot password screen
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  final _authService = AuthService();

  // reset action
  void _handleReset() async {

    if (!_formKey.currentState!.validate()) return;

    try {

      await _authService.resetPassword(
        _email.text.trim(),
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Reset Email Sent")));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );


    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),

              AuthTextField(
                label: "Email",
                controller: _email,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

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
                  onPressed: _handleReset,
                  child: const Text("Send Reset Link"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
