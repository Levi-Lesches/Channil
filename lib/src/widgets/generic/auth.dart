import "package:flutter/material.dart";

class AuthenticationWidget extends StatelessWidget {
  final String status;
  final VoidCallback onPressed;
  const AuthenticationWidget({
    required this.onPressed,
    required this.status,
  });

  @override
  Widget build(BuildContext context) => Row(children: [
    Expanded(child: SizedBox(width: 150, child: ListTile(
      title: const Text("Authentication"),
      subtitle: Text(status),
    ),),),
    SizedBox(width: 200, child: OutlinedButton(
      onPressed: onPressed, 
      child: const Text("Sign in with Google"),
    ),),
  ],);
}
