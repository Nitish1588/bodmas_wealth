import 'package:bodmas_wealth/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'widgets/auth_text_field.dart';
import 'auth_service.dart';
import '../core/colors.dart';

// Forgot Password Screen
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final _formKey = GlobalKey<FormState>();          // Form key for validation
  final _email = TextEditingController();           // Controller for email input
  final _authService = AuthService();              // Instance of AuthService

  // =========================
  // HANDLE RESET PASSWORD
  // =========================
  void _handleReset() async {

    // Validate form fields
    if (!_formKey.currentState!.validate()) return;

    try {
      // Call AuthService to send reset email
      await _authService.resetPassword(
        _email.text.trim(),
      );

      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Reset Email Sent"))
      );

      // Navigate back to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );

    } catch (e) {
      // Show error message if reset fails
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()))
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.primary, // Screen background color
      appBar: AppBar(title: const Text("Forgot Password")),

      body: Padding(
        padding: const EdgeInsets.all(24),

        // Form to validate email input
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              const SizedBox(height: 10),

              // Reusable email input field
              AuthTextField(
                label: "Email",
                controller: _email,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              // Reset button
              SizedBox(
                width: double.infinity, // Full width button
                height: 50,              // Fixed height
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFFFFF), // Button color
                    foregroundColor: Color(0xFF9144FF), // Text color
                    textStyle: const TextStyle(
                      fontSize: 15.0,
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
