import 'package:bodmas_wealth/auth/otp_screen.dart';
import 'package:flutter/material.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/terms_checkbox.dart';
import 'auth_service.dart';
import '../core/colors.dart';

/// =========================
/// SIGNUP SCREEN
/// =========================
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // =========================
  // USER TYPE SELECTION
  // Can be "buyer", "dealer", or "owner"
  // =========================
  String? _userType;

  // =========================
  // FORM KEY for validation
  // =========================
  final _formKey = GlobalKey<FormState>();

  // =========================
  // CONTROLLERS FOR INPUT FIELDS
  // =========================
  final _name = TextEditingController();
  final _mobile = TextEditingController();
  final _email = TextEditingController();
  // final _occupation = TextEditingController(); // Optional field, commented

  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  // =========================
  // AUTH SERVICE INSTANCE
  // =========================
  final _authService = AuthService();

  // =========================
  // UI STATE VARIABLES
  // =========================
  bool _accepted = false; // Terms & Conditions checkbox
  bool _loading = false;  // Loading state for signup button

  // =========================
  // SIGNUP FUNCTION
  // Validates inputs and calls AuthService
  // =========================
  void _handleSignup() async {
    // 1. Validate form fields
    if (!_formKey.currentState!.validate()) return;

    // 2. Check if terms are accepted
    if (!_accepted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Accept Terms first")));
      return;
    }

    // 3. Check if passwords match
    if (_password.text != _confirmPassword.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Passwords not match")));
      return;
    }

    // 4. Ensure user type is selected
    if (_userType == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please select User Type")));
      return;
    }

    setState(() => _loading = true); // Show loading state

    try {
      // Call AuthService to register the user
      await _authService.signup(
        name: _name.text.trim(),
        mobile: _mobile.text.trim(),
        email: _email.text.trim(),
        // occupation: _occupation.text.trim(),
        password: _password.text.trim(),
        userType: _userType!,
      );

      if (!mounted) return;

      // Navigate to OTP screen for phone verification
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OtpScreen(
            phone: '+91${_mobile.text.trim()}', // Pass mobile with country code
          ),
        ),
      );
    } catch (e) {
      // Show error if signup fails
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() => _loading = false); // Reset loading state
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(title: const Text('Signup')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey, // Form key for validation
          child: Column(
            children: [
              const SizedBox(height: 12),

              // =========================
              // NAME FIELD
              // =========================
              AuthTextField(label: "Name", controller: _name),
              const SizedBox(height: 12),

              // =========================
              // MOBILE NUMBER FIELD
              // =========================
              AuthTextField(
                label: "Mobile No",
                controller: _mobile,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),

              // =========================
              // EMAIL FIELD
              // =========================
              AuthTextField(
                label: "Email",
                controller: _email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),

              // =========================
              // USER TYPE SELECTION (Buyer/Dealer/Owner)
              // =========================
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Register as",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: SegmentedButton<String>(
                  showSelectedIcon: false,
                  expandedInsets: EdgeInsets.zero,
                  segments: const [
                    ButtonSegment(
                      value: "buyer",
                      label: Text("Buyer"),
                    ),
                    ButtonSegment(
                      value: "dealer",
                      label: Text("Dealer"),
                    ),
                    ButtonSegment(
                      value: "owner",
                      label: Text("Owner"),
                    ),
                  ],
                  selected: _userType == null ? {} : {_userType!},
                  emptySelectionAllowed: true,
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _userType = newSelection.first;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      // White if selected, semi-transparent if not
                      return states.contains(WidgetState.selected)
                          ? Colors.white
                          : Colors.white.withAlpha(80);
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith((states) {
                      // Purple text if selected, white if not
                      return states.contains(WidgetState.selected)
                          ? const Color(0xFF9144FF)
                          : Colors.white;
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // =========================
              // PASSWORD FIELDS
              // =========================
              AuthTextField(
                label: "Create Password",
                controller: _password,
                isPassword: true,
              ),
              const SizedBox(height: 12),
              AuthTextField(
                label: "Confirm Password",
                controller: _confirmPassword,
                isPassword: true,
              ),
              const SizedBox(height: 5),

              // =========================
              // TERMS & CONDITIONS CHECKBOX
              // =========================
              TermsCheckbox(
                value: _accepted,
                onChanged: (v) {
                  setState(() => _accepted = v!);
                },
              ),
              const SizedBox(height: 5),

              // =========================
              // SIGNUP BUTTON
              // =========================
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFFFFF),
                    foregroundColor: const Color(0xFF9144FF),
                    textStyle: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: _loading ? null : _handleSignup, // Disable when loading
                  child: const Text("Signup"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
