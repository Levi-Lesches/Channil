import "package:flutter/material.dart";

class GoogleAuthButton extends StatelessWidget {
  final VoidCallback onMobile;
  final String? status;
  final bool signUp;
  const GoogleAuthButton({required this.onMobile, required this.signUp, this.status, super.key});
  
  @override
  Widget build(BuildContext context) => Container();
}
