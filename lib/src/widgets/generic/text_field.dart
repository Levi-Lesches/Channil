import "package:flutter/material.dart";

class ChannilTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? error;
  final ValueChanged<String>? onChanged;
  const ChannilTextField({
    required this.controller,
    required this.hint,
    this.onChanged,
    this.error,
  });

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    onChanged: onChanged,
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      labelText: hint,
      errorText: error,
    ),
  );
}
