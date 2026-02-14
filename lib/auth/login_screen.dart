import 'package:bodmas_wealth/auth/forgot_password_screen.dart';
import 'package:bodmas_wealth/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'widgets/auth_text_field.dart';
import 'auth_service.dart';
import '../core/colors.dart';

// Login Screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();   // Form key for validation
  final _email = TextEditingController();    // Controller for email input
  final _password = TextEditingController(); // Controller for password input
  final _authService = AuthService();        // Instance of AuthService

  bool _loading = false;                     // Loading state for login button

  // =========================
  // HANDLE LOGIN
  // =========================
  void _handleLogin() async {

    // Validate form inputs
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true); // Show loading indicator

    try {
      // Call AuthService to login
      await _authService.login(
        _email.text.trim(),
        _password.text.trim(),
      );

      // Only show SnackBar if widget is still in the widget tree
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Login Successful")));

    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() => _loading = false); // Hide loading indicator
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.primary, // Screen background color

      body: Padding(
        padding: const EdgeInsets.all(22),
        child: SingleChildScrollView( // <-- Add this to make content scrollable when keyboard appears
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 44,
              // 44 = padding top+bottom (22 + 22)
            ),
            child: IntrinsicHeight( // <-- Keeps Column height flexible
              child: Form(
                key: _formKey,
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

                    // =========================
                    // USER ICON
                    // =========================
                    // Container(
                    //   padding: const EdgeInsets.all(8),
                    //   decoration: BoxDecoration(
                    //     color: Color(0xFFFFFFFF),   // Light white background
                    //     borderRadius: BorderRadius.circular(100),
                    //   ),
                    //   child: const Icon(
                    //     Icons.person_outline_outlined,
                    //     color: Color(0xFF9144FF),   // Purple icon color
                    //     size: 60,
                    //   ),
                    // ),
                    //
                    const SizedBox(height: 20),

                    // =========================
                    // SCREEN TITLE
                    // =========================
                    const Text(
                      "Access My Account",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFDDDDDD),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // =========================
                    // EMAIL INPUT
                    // =========================
                    AuthTextField(
                      label: "Email",
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    // =========================
                    // PASSWORD INPUT
                    // =========================
                    AuthTextField(
                      label: "Password",
                      controller: _password,
                      isPassword: true,
                    ),
                    const SizedBox(height: 10),

                    // =========================
                    // FORGOT PASSWORD BUTTON
                    // =========================
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Color(0xFFA684FF), // Text color
                          textStyle: const TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFFA684FF),
                          ),
                          minimumSize: Size.zero, // Shrinks button to child
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // =========================
                    // LOGIN BUTTON
                    // =========================
                    SizedBox(
                      width: double.infinity, // Full width
                      height: 50,             // Fixed height
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFFFFFF),
                          foregroundColor: Color(0xFF9144FF),
                          textStyle: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: _loading ? null : _handleLogin, // Disable while loading
                        child: _loading
                            ? const CircularProgressIndicator()  // Show spinner if loading
                            : const Text("Login"),
                      ),
                    ),
                    const SizedBox(height: 15),


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
                    const SizedBox(height: 15),
                    const Text(
                      "OR",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF99A1AF),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // =========================
                    // CREATE ACCOUNT BUTTON
                    // =========================
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignupScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF9144FF),
                          foregroundColor: Color(0xFFDDDDDD),
                          textStyle: const TextStyle(
                            fontSize: 15.0,
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
          ),
        ),
      ),
    );
  }
}