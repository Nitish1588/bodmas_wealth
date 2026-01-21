import 'package:flutter/material.dart';

// Reusable input field for auth screens
class AuthTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
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
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        color: Color (0xFFDDDDDD), // INPUT text color
        fontSize: 16,
      ),
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      keyboardType: widget.keyboardType,

      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "${widget.label} required";
        }

        if (widget.label == "Email" && !value.contains("@")) {
          return "Invalid email";
        }

        if (widget.label.contains("Password")) {
          if (value.length < 8) {
            return "Password must be at least 8 characters";
          }
          if (!RegExp(r'[A-Z]').hasMatch(value)) {
            return "Include at least 1 uppercase letter";
          }
          if (!RegExp(r'[a-z]').hasMatch(value)) {
            return "Include at least 1 lowercase letter";
          }
          if (!RegExp(r'[0-9]').hasMatch(value)) {
            return "Include at least 1 number";
          }
          if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
            return "Include at least 1 special character";
          }
        }


        return null;
      },

      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: const TextStyle(
          color: Color (0xFFD2D2DC), // label text color
        ),
        hintText: 'Enter ${widget.label}',
        hintStyle: const TextStyle(
          color: Color (0x80DDDDDD), // suggestion / hint text color
        ),

        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: Color (0xFFD2D2DC))
            : null,

        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Color (0xFFD2D2DC),
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : null,

        filled: true,
        fillColor: const Color(0x1A99A1AF),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFD9D9D9),
            width: 2,
          ),
        ),

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
