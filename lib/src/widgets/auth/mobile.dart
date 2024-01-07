import "package:flutter/material.dart";

class GoogleAuthButton extends StatelessWidget {
  final VoidCallback onMobile;
  final String? status;
  final bool signUp;
  const GoogleAuthButton({required this.onMobile, required this.signUp, this.status, super.key});

  @override
  Widget build(BuildContext context) => Row(children: [
    if (status != null) Expanded(child: SizedBox(width: 150, child: ListTile(
      title: const Text("Authentication"),
      subtitle: Text(status!),
    ),),),
    if (status == null) Expanded(child: 
      OutlinedButton(
        onPressed: onMobile,
        child: const Text("Sign in with Google"),
      ),
    ) else SizedBox(
      width: 200, 
      child: OutlinedButton(
        onPressed: onMobile,
        child: const Text("Sign in with Google"),
      ),
    ),
  ],);
}
