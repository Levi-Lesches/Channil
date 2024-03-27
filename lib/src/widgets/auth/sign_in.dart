import "dart:async";

import "package:flutter/material.dart";

import "package:channil/models.dart";
import "package:channil/services.dart";
import "package:channil/widgets.dart";

class SignInViewModel extends ViewModel {
  final VoidCallback onSignIn;
  SignInViewModel(this.onSignIn);
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Future<void> init() async {
    models.user.addListener(_listener);
  }

  @override
  void dispose() {
    models.user.removeListener(_listener);
    super.dispose();
  }

  Future<void> _listener() async {
    errorText = null;
    if (!models.user.isAuthenticated) return;
    if (!models.user.hasAccount) errorText = "No account exists for that email. Please sign up below";
    onSignIn();
    notifyListeners();
  }

  String? emailError;
  String? passwordError;
  Future<void> signInWithEmailAndPassword() async {
    emailError = null;
    passwordError = null;
    notifyListeners();
    final email = emailController.text;
    final password = passwordController.text;
    final result = await services.auth.signInWithEmailAndPassword(email: email, password: password);
    switch (result) {
      case SignInResult.wrongPassword: passwordError = "Incorrect password";
      case SignInResult.invalidEmail: emailError = "Invalid email";
      case SignInResult.missingPassword: passwordError = "Missing password";
      case SignInResult.disabledAccount: emailError = "Account has been disabled";
      case SignInResult.unknownError: passwordError = "An unknown error has occurred";
      case SignInResult.ok: break;
    }
    notifyListeners();
  }

  bool obscureText = true;
  void updateObscurity(bool input) {  // ignore: avoid_positional_boolean_parameters
    obscureText = input;
    notifyListeners();
  }
}

class SignInWidget extends ReactiveWidget<SignInViewModel> {
  final VoidCallback onSignIn;
  const SignInWidget({
    required this.onSignIn,
  });

  @override
  SignInViewModel createModel() => SignInViewModel(onSignIn);
  
  @override
  Widget build(BuildContext context, SignInViewModel model) => Column(
    children: [
      GoogleAuthButton(signUp: false, expanded: true),
      if (model.errorText != null) 
        Text(model.errorText!, style: const TextStyle(color: Colors.red)),
      const SizedBox(height: 8),
      Text(
        "or\n",
        textAlign: TextAlign.center,
        style: context.textTheme.titleLarge?.copyWith(fontSize: 20),
      ),
      const SizedBox(height: 8),
      ChannilTextField(
        controller: model.emailController,
        capitalization: TextCapitalization.none,
        type: TextInputType.emailAddress,
        hint: "Email",
        error: model.emailError,
      ),
      const SizedBox(height: 8),
      ChannilTextField(
        controller: model.passwordController,
        hint: "Password",
        obscureText: model.obscureText,
        onObscure: model.updateObscurity,
        action: TextInputAction.done,
        capitalization: TextCapitalization.none,
        type: TextInputType.visiblePassword,
        error: model.passwordError,
        onEditingComplete: model.signInWithEmailAndPassword,
      ),
      const SizedBox(height: 8),
      OutlinedButton(
        onPressed: model.signInWithEmailAndPassword,
        child: Text(
          "Sign in with email and password", 
          style: context.textTheme.titleLarge?.copyWith(fontSize: 20),
        ),
      ).widen(),
    ],
  );
}
