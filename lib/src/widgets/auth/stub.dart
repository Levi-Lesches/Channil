import "package:flutter/material.dart";

class GoogleAuthButton extends StatelessWidget {
  final bool signUp;
  final bool expanded;
  // Reason: The web and mobile versions aren't const
  // ignore: prefer_const_constructors_in_immutables
  GoogleAuthButton({
    required this.signUp, 
    this.expanded = false,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) => Container();
}
