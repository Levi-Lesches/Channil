import "package:flutter/material.dart";
import "package:channil/widgets.dart";

class InfoBox extends StatelessWidget {
  final List<Widget> children;
  const InfoBox({required this.children});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      border: Border.all(width: 2),
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  );
}

Widget boldAndNormal(BuildContext context, String bold, String normal) => Text.rich(
  TextSpan(children: [
    TextSpan(text: bold, style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
    TextSpan(text: normal, style: context.textTheme.bodyLarge),
  ],),
);
