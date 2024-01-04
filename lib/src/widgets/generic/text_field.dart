import "package:flutter/material.dart";
// import "package:flutter/services.dart";

class ChannilTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hint;
  final String? error;
  final ValueChanged<String>? onChanged;
  final TextInputType? type;
  final TextInputAction action;
  final bool autofocus;

  const ChannilTextField({
    required this.controller,
    this.hint,
    this.action = TextInputAction.next,
    this.autofocus = false,
    this.type,
    this.onChanged,
    this.error,
  });

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    onChanged: onChanged,
    autofocus: autofocus,
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      labelText: hint,
      errorText: error,
    ),
    keyboardType: type,
    textInputAction: action,
  );
}
