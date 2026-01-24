import 'package:flutter/material.dart';
import 'auth_service.dart';
import '../auth/login_screen.dart';
import '../core/colors.dart';
import 'widgets/auth_text_field.dart';

// OTP Verification Screen
class OtpScreen extends StatefulWidget {
  final String phone; // Phone number to verify
  const OtpScreen({super.key, required this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otp = TextEditingController(); // Controller for OTP input
  final _auth = AuthService();          // Auth service instance
  bool _loading = false;                // Loading state for verify button

  @override
  void initState() {
    super.initState();

    // Automatically send OTP after screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendOtp();
    });
  }

  // =========================
  // SEND OTP
  // =========================
  Future<void> _sendOtp() async {
    try {
      await _auth.sendOtp(widget.phone); // Call AuthService to send OTP
    } catch (e) {
      if (!mounted) return;
      // Show error message if OTP sending fails
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // =========================
  // VERIFY OTP
  // =========================
  void _verify() async {
    setState(() => _loading = true); // Show loading state

    try {
      // Verify OTP via AuthService
      await _auth.verifyOtp(_otp.text.trim());

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Phone Verified")));

      // Navigate to login screen after verification
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );

    } catch (e) {
      // Show error if OTP verification fails
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() => _loading = false); // Hide loading state
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(title: const Text("Verify OTP")),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [

            const SizedBox(height: 20),

            // =========================
            // INFO TEXT
            // =========================
            Text(
              "OTP sent to ${widget.phone}",
              style: const TextStyle(
                color: Color(0xFFDDDDDD),
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 15),

            // =========================
            // OTP INPUT FIELD
            // =========================
            AuthTextField(
              label: "", // No label for OTP
              controller: _otp,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 15),

            // =========================
            // VERIFY BUTTON
            // =========================
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFFFFF), // Button color
                  foregroundColor: const Color(0xFF9144FF), // Text color
                  textStyle: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: _loading ? null : _verify, // Disable button if loading
                child: const Text("Verify"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
