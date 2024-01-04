import "package:flutter/material.dart";

import "package:channil/widgets.dart";

class SignUpPage extends StatelessWidget {
  final Widget child;
  final List<Widget> buttons;
  const SignUpPage({required this.child, required this.buttons});
  
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          children: [
            const Center(child: ChannilLogo()),
            const SizedBox(height: 24),
            Expanded(child: child),
            ButtonBar(children: buttons),
            const SizedBox(height: 24),
          ],
        ),
      ),
    ),
  );
}
