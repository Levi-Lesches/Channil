import "package:flutter/material.dart";

import "package:channil/models.dart";
import "package:channil/widgets.dart";

class GoogleAuthButton extends ReusableReactiveWidget<UserModel> {
  final bool signUp;
  GoogleAuthButton({required this.signUp}) : super(models.user);

  @override
  Widget build(BuildContext context, UserModel model) => Row(children: [
    Expanded(flex: 3, child: ListTile(
      title: const Text("Authentication"),
      subtitle: Text(model.authStatus, style: context.textTheme.labelMedium),
    ),),
    SizedBox(
      width: 200, 
      child: OutlinedButton(
        onPressed: model.signInWithGoogle,
        child: const Text("Sign in with Google"),
      ),
    ),
  ],);
}
