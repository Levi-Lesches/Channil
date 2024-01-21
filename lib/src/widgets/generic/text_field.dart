import "package:flutter/material.dart";
import "package:flutter/services.dart";

Widget addRequiredStar(String text, {TextStyle? style}) => Text.rich(
  TextSpan(
    text: text, 
    style: style,
    children: const [
      TextSpan(
        text: " *", 
        style: TextStyle(color: Colors.red),
      ),
    ],
  ),
);

class ChannilTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hint;
  final String? error;
  final String? prefix;
  final ValueChanged<String>? onChanged;
  final TextInputType? type;
  final TextInputAction action;
  final TextCapitalization capitalization;
  final bool autofocus;
  final bool enabled;
  final bool isRequired;

  const ChannilTextField({
    required this.controller,
    this.hint,
    this.action = TextInputAction.next,
    this.autofocus = false,
    this.enabled = true,
    this.capitalization = TextCapitalization.sentences,
    this.type,
    this.onChanged,
    this.error,
    this.prefix,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    onChanged: onChanged,
    autofocus: autofocus,
    textCapitalization: capitalization,
    keyboardType: type,
    textInputAction: action,
    enabled: enabled,
    inputFormatters: [
      if (type == TextInputType.number) 
        FilteringTextInputFormatter.allow(RegExp(r"\d")),
    ],
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      labelText: isRequired ? null : hint,
      label: isRequired && hint != null 
        ? addRequiredStar(hint!) : null, 
      errorText: error,
      prefixText: prefix,
    ),
  );
}
