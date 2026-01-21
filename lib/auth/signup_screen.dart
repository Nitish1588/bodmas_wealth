
import 'package:bodmas_wealth/auth/otp_screen.dart';
import 'package:flutter/material.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/terms_checkbox.dart';
import 'auth_service.dart';
import '../core/colors.dart';



// Signup screen with name and mobile no
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String? _userType; // "user" or "dealer"


  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _mobile = TextEditingController();
  final _email = TextEditingController();
  //final _occupation = TextEditingController();

  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  final _authService = AuthService();

  bool _accepted = false;
  bool _loading = false;

  // signup action
  void _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_accepted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Accept Terms first")));
      return;
    }

    if (_password.text != _confirmPassword.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Passwords not match")));
      return;
    }
    if (_userType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select User Type")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await _authService.signup(
        name: _name.text.trim(),
        mobile: _mobile.text.trim(),
        email: _email.text.trim(),

       // occupation: _occupation.text.trim(),
        password: _password.text.trim(),
          userType: _userType!
      );

      if (!mounted) return;
      // GO TO OTP SCREEN
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OtpScreen(
            phone: '+91${_mobile.text.trim()}', // Passing argument directly
          ),
        ),
      );

      // ScaffoldMessenger.of(context)
       //   .showSnackBar(const SnackBar(content: Text("Signup Successful")));

      //Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(title: Text('Signup')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 12),
              AuthTextField(label: "Name", controller: _name),

              const SizedBox(height: 12),

              AuthTextField(
                label: "Mobile No",
                controller: _mobile,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 12),

              AuthTextField(
                label: "Email",
                controller: _email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),

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

                  // 👇 yeh dono segments ko equal width deta hai
                  expandedInsets: EdgeInsets.zero,

                  segments: const [
                    ButtonSegment(
                      value: "buyer",
                      label: Text("Property Buyer"),
                    ),
                    ButtonSegment(
                      value: "dealer",
                      label: Text("Property Dealer"),
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
                      if (states.contains(WidgetState.selected)) {
                        return Colors.white;
                      }
                      return Colors.white.withValues(alpha: 0.3);
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return const Color(0xFF9144FF);
                      }
                      return Colors.white;
                    }),
                  ),
                ),
              ),


              const SizedBox(height: 12),



              // AuthTextField(label: "Occupation", controller: _occupation),

             // const SizedBox(height: 12),

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

              TermsCheckbox(
                value: _accepted,
                onChanged: (v) {
                  setState(() => _accepted = v!);
                },
              ),

              const SizedBox(height: 5),

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
                  onPressed: _loading ? null : _handleSignup,
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
