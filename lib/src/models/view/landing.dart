import "package:channil/services.dart";
import "package:flutter/material.dart";

import "package:channil/models.dart";
import "package:channil/pages.dart";

class LandingViewModel extends ViewModel {
  int state = 0;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void next() {
    state++;
    notifyListeners();
  }

  void back() {
    state--;
    notifyListeners();
  }

  @override
  Future<void> init() async {
    models.user.addListener(onAuth);
  }

  @override
  void dispose() {
    models.user.removeListener(onAuth);
    super.dispose();
  }

  void onAuth() {
    if (!models.user.isAuthenticated) return;
    if (models.user.hasAccount) {
      router.goNamed(Routes.profile);
    } else {
      errorText = "No account exists for that email. Please sign up below";
      notifyListeners();
    }
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
