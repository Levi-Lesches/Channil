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
    SizedBox(width: 200, child: ListTile(
      title: const Text("Authentication"),
      subtitle: Text(status),
    ),),
    const Spacer(),
    OutlinedButton(
      onPressed: onPressed, 
      child: const Text("Sign in with Google"),
    ),
  ],);
}
