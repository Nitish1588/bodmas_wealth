import 'package:flutter/material.dart';
import 'auth_service.dart';
import '../auth/login_screen.dart';
import '../core/colors.dart';
import 'widgets/auth_text_field.dart';
class OtpScreen extends StatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otp = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendOtp();
    });
  }

  Future<void> _sendOtp() async {
    try {
      await _auth.sendOtp(widget.phone);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _verify() async {
    setState(() => _loading = true);

    try {
      await _auth.verifyOtp(_otp.text.trim());

      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Phone Verified")));



      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );

     // Navigator.pushReplacementNamed(context, AppRoutes.login);
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
      appBar: AppBar(title: const Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Text(
              "OTP sent to ${widget.phone}",
              style: TextStyle(
                color: Color(0xFFDDDDDD),      // Text color
                fontSize: 16.0,            // Text size
                fontWeight: FontWeight.w400, // Font weight (w400, w500, w600, bold, etc.)
              ),
            ),

            const SizedBox(height: 15),

            AuthTextField(
              label: "",
              controller: _otp,
              keyboardType: TextInputType.number,
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
                onPressed: _loading ? null : _verify,
                child: const Text("Verify"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
