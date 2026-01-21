import 'package:flutter/material.dart';

// Reusable Terms & Conditions checkbox
class TermsCheckbox extends StatelessWidget {

  final bool value;
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
        Checkbox(
          value: value,
          onChanged: onChanged,

          activeColor: Color(0xFF9144FF),
          checkColor: Color(0xFFFFFFFF),
          side: BorderSide(
            color: Colors.grey,
            width: 2,
          ),
        ),
        const Text("Accept Terms and Conditions",
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
