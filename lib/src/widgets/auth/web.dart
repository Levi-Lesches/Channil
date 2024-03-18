import "package:flutter/material.dart";
import "package:google_sign_in_web/web_only.dart";

import "package:channil/models.dart";
import "package:channil/widgets.dart";
import "package:channil/services.dart";

class GoogleAuthButton extends ReusableReactiveWidget<UserModel> {
  final bool signUp;
  final bool expanded;
  GoogleAuthButton({
    required this.signUp,
    this.expanded = false,
  }) : super(models.user) {
    services.auth.google.signInSilently();
    prerenderButton();
  }

  late final Widget googleWidget;
  void prerenderButton() => googleWidget = renderButton(
    configuration: GSIButtonConfiguration(
      text: signUp ? GSIButtonText.signupWith : GSIButtonText.signinWith,
      shape: GSIButtonShape.pill,
      size: GSIButtonSize.large,
    ),
  );
    
  @override
  Widget build(BuildContext context, UserModel model) => Row(children: [
    Expanded(child: SizedBox(width: 150, child: ListTile(
      title: const Text("Authentication"),
      subtitle: Text(model.authStatus),
    ),),),
    SizedBox(
      width: 200, 
      child: googleWidget,
    ),
  ],);
}
