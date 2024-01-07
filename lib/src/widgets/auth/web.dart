import "package:flutter/material.dart";
import "package:google_sign_in_web/web_only.dart";

import "package:channil/services.dart";

class GoogleAuthButton extends StatelessWidget {
  final VoidCallback onMobile;
  final String? status;
  final bool signUp;
  GoogleAuthButton({required this.onMobile, required this.signUp, this.status, super.key}) {
    services.auth.google.signInSilently();
  }

  @override
  Widget build(BuildContext context) => Row(children: [
    if (status != null) Expanded(child: SizedBox(width: 150, child: ListTile(
      title: const Text("Authentication"),
      subtitle: Text(status!),
    ),),),
    if (status != null) SizedBox(
      width: 200, 
      child: renderButton(
        configuration: GSIButtonConfiguration(
          text: signUp ? GSIButtonText.signupWith : GSIButtonText.signinWith,
          shape: GSIButtonShape.pill,
        ),
      ),
    ) else Expanded(child: renderButton(
      configuration: GSIButtonConfiguration(
        text: signUp ? GSIButtonText.signupWith : GSIButtonText.signinWith,
        shape: GSIButtonShape.pill,
        size: GSIButtonSize.large,
      ),
    ),),
  ],);
}
