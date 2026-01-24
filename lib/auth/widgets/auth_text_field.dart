import 'package:flutter/material.dart';
// Reusable input field widget jo login / signup screens mein use hota hai
class AuthTextField extends StatefulWidget {

  // Field ka label (Email, Password, etc.)
  final String label;

  // Controller jo input text ko handle karta hai
  final TextEditingController controller;

  // Agar true ho to field password ban jaati hai
  final bool isPassword;

  // Keyboard type (text, email, number, etc.)
  final TextInputType keyboardType;

  // Optional icon jo left side show hota hai
  final IconData? prefixIcon;

  const AuthTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {

  // Password hide/show karne ke liye variable
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {

    return TextFormField(

      // User jo text likhega uska style
      style: const TextStyle(
        color: Color(0xFFDDDDDD),
        fontSize: 16,
      ),

      // Controller assign kiya
      controller: widget.controller,

      // Agar password field hai to text hide hoga
      obscureText: widget.isPassword ? _obscureText : false,

      // Keyboard ka type set kiya
      keyboardType: widget.keyboardType,

      // Validation logic (error messages)
      validator: (value) {

        // Empty field check
        if (value == null || value.trim().isEmpty) {
          return "${widget.label} required";
        }

        // Email validation
        if (widget.label == "Email" && !value.contains("@")) {
          return "Invalid email";
        }

        // Password validation rules
        if (widget.label.contains("Password")) {

          // Minimum length check
          if (value.length < 8) {
            return "Password must be at least 8 characters";
          }

          // At least 1 uppercase letter
          if (!RegExp(r'[A-Z]').hasMatch(value)) {
            return "Include at least 1 uppercase letter";
          }

          // At least 1 lowercase letter
          if (!RegExp(r'[a-z]').hasMatch(value)) {
            return "Include at least 1 lowercase letter";
          }

          // At least 1 number
          if (!RegExp(r'[0-9]').hasMatch(value)) {
            return "Include at least 1 number";
          }

          // At least 1 special character
          if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
            return "Include at least 1 special character";
          }
        }

        // Sab sahi ho to null return
        return null;
      },

      // UI decoration (design)
      decoration: InputDecoration(

        // Field ka label
        labelText: widget.label,
        labelStyle: const TextStyle(
          color: Color(0xFFD2D2DC),
        ),

        // Hint text (placeholder)
        hintText: 'Enter ${widget.label}',
        hintStyle: const TextStyle(
          color: Color(0x80DDDDDD),
        ),

        // Left side icon (agar diya ho)
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: Color(0xFFD2D2DC))
            : null,

        // Password ke liye show/hide icon
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_off
                : Icons.visibility,
            color: Color(0xFFD2D2DC),
          ),
          onPressed: () {
            // Icon press par password hide/show
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : null,

        // Background fill
        filled: true,
        fillColor: const Color(0x1A99A1AF),

        // Default border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),

        // Border jab field active na ho
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFD9D9D9),
            width: 2,
          ),
        ),

        // Border jab field focus mein ho
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFB974FF),
            width: 2,
          ),
        ),
      ),
    );
  }
}
