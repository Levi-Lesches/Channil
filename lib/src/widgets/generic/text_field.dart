import "package:flutter/material.dart";

class ChannilTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? error;
  const ChannilTextField({
    required this.controller,
    required this.hint,
    this.error,
  });

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      labelText: hint,
      errorText: error,
    ),
  );
}
