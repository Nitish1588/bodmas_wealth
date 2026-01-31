import 'package:flutter/material.dart';

Widget darkTextField(
    String label,
    TextEditingController ctrl, {
      TextInputType keyboard = TextInputType.text,
    }) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      validator: (v) => v!.isEmpty ? "Required" : null,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFFD2D2DC)),
        filled: true,
        fillColor: const Color(0x1AFFFFFF),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
          const BorderSide(color: Color(0x3499A1AF), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
          const BorderSide(color: Color(0xFF9144FF), width: 2),
        ),
      ),
    ),
  );
}

Widget darkDropdown(
    String label,
    String value,
    List<String> items,
    Function(String) onChanged,
    ) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: DropdownButtonFormField(
      initialValue: value,
      isExpanded: true,
      dropdownColor: const Color(0xFF181625),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFFD2D2DC)),
        filled: true,
        fillColor: const Color(0x1AFFFFFF),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
          const BorderSide(color: Color(0x1A99A1AF), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
          const BorderSide(color: Color(0xFF9144FF), width: 2),
        ),
      ),
      items: items
          .map(
            (e) => DropdownMenuItem(
          value: e,
          child: Text(e,
              style: const TextStyle(color: Colors.white)),
        ),
      )
          .toList(),
      onChanged: (v) => onChanged(v!),
    ),
  );
}

Widget darkCheckbox(
    String title,
    bool value,
    Function(bool) onChanged,
    ) {
  return CheckboxListTile(
    title: Text(title, style: const TextStyle(color: Colors.white)),
    value: value,
    activeColor: const Color(0xFFB974FF),
    checkColor: Colors.white,
    onChanged: (v) => onChanged(v!),
  );
}
