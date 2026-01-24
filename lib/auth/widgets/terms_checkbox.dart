import 'package:flutter/material.dart';

// Reusable Terms & Conditions checkbox widget
class TermsCheckbox extends StatelessWidget {

  // Current checkbox value (checked/unchecked)
  final bool value;

  // Function jo checkbox change hone par call hoti hai
  final Function(bool?) onChanged;

  const TermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        // Actual checkbox
        Checkbox(
          value: value,           // Checkbox ka current state
          onChanged: onChanged,   // Checkbox change hone par call hone wali function

          // Colors
          activeColor: Color(0xFF9144FF), // Jab checked ho
          checkColor: Color(0xFFFFFFFF),  // Check mark color

          // Border color & width
          side: BorderSide(
            color: Colors.grey,
            width: 2,
          ),
        ),

        // Checkbox ke saath text
        const Text(
          "Accept Terms and Conditions",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFFD2D2DC),
          ),
        ),
      ],
    );
  }
}
