import "package:flutter/material.dart";

import "package:channil/models.dart";
import "package:channil/widgets.dart";

class SignUpWidget extends ReusableReactiveWidget<ProfileBuilder<dynamic>> {
  const SignUpWidget(super.model);
  
  @override
  Widget build(BuildContext context, ProfileBuilder<dynamic> model) => Column(
    children: [
      GoogleAuthButton(signUp: true),
      if (models.user.hasAccount) 
        const Text("An account with this email already exists", style: TextStyle(color: Colors.red)),
      const SizedBox(height: 8),
      Text(
        "or\n",
        textAlign: TextAlign.center,
        style: context.textTheme.titleLarge,
      ),
      const SizedBox(height: 8),
      ChannilTextField(
        enabled: model.enableAccountCreation,
        controller: model.emailController,
        capitalization: TextCapitalization.none,
        type: TextInputType.emailAddress,
        hint: "Email",
        error: model.emailError,
      ),
      const SizedBox(height: 8),
      ChannilTextField(
        enabled: model.enableAccountCreation,
        controller: model.passwordController,
        hint: "Password",
        capitalization: TextCapitalization.none,
        type: TextInputType.visiblePassword,
        error: model.passwordError,
        obscureText: model.obscureText,
        onObscure: model.updateObscurity,
      ),
      const SizedBox(height: 8),
      ChannilTextField(
        enabled: model.enableAccountCreation,
        controller: model.confirmPasswordController,
        hint: "Confirm password",
        obscureText: model.obscureText,
        onObscure: model.updateObscurity,
        action: TextInputAction.done,
        capitalization: TextCapitalization.none,
        type: TextInputType.visiblePassword,
        onEditingComplete: model.createAccount,
      ),
      const SizedBox(height: 8),
      OutlinedButton(
        onPressed: model.enableAccountCreation ? model.createAccount : null,
        child: const Text("Sign up with email and password"),
      ),
    ],
  );
}
