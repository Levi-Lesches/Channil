import "package:flutter/material.dart";
import "package:google_sign_in_web/web_only.dart";

import "package:channil/services.dart";

class GoogleAuthButton extends StatefulWidget {
  final VoidCallback onMobile;
  final String? status;
  final bool signUp;
  GoogleAuthButton({required this.onMobile, required this.signUp, this.status, super.key}) {
    services.auth.google.signInSilently();
  }

  @override
  State<GoogleAuthButton> createState() => _GoogleAuthButtonState();
}

class _GoogleAuthButtonState extends State<GoogleAuthButton> {
  late final Widget googleWidget;
  void prerenderButton() => googleWidget = renderButton(
    configuration: GSIButtonConfiguration(
      text: widget.signUp ? GSIButtonText.signupWith : GSIButtonText.signinWith,
      shape: GSIButtonShape.pill,
      size: widget.status == null ? GSIButtonSize.large : null,
    ),
  );
  
  @override
  void initState() {
    super.initState();
    prerenderButton();
  }

  @override
  void didUpdateWidget(GoogleAuthButton oldWidget) {
    if (oldWidget.status != widget.status || oldWidget.signUp != widget.signUp) prerenderButton();
    super.didUpdateWidget(oldWidget);
  }
  
  @override
  Widget build(BuildContext context) => Row(children: [
    if (widget.status != null) Expanded(child: SizedBox(width: 150, child: ListTile(
      title: const Text("Authentication"),
      subtitle: Text(widget.status!),
    ),),),
    if (widget.status != null) SizedBox(
      width: 200, 
      child: googleWidget,  // renderButton(
        // configuration: GSIButtonConfiguration(
        //   text: widget.signUp ? GSIButtonText.signupWith : GSIButtonText.signinWith,
        //   shape: GSIButtonShape.pill,
        // ),
      // ),
    ) else Expanded(child: googleWidget, // renderButton(
      // configuration: GSIButtonConfiguration(
      //   text: widget.signUp ? GSIButtonText.signupWith : GSIButtonText.signinWith,
      //   shape: GSIButtonShape.pill,
      //   size: GSIButtonSize.large,
      // ),
    ),
  ],);
}
