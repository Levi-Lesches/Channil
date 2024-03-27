import "dart:async";

import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/services.dart";

abstract class ProfileBuilder<T> extends BuilderModel<T> {
  // -------------------- Page handling --------------------  
  static const pageDelay = Duration(milliseconds: 250);
  static const pageCurve = Curves.easeInOut;

  late final PageController pageController;
  late int pageIndex;
  late int startIndex;
  late int endIndex;
  int get lastPageIndex;

  ProfileBuilder({int? startIndex, int? endIndex}) {
    this.startIndex = startIndex ?? 0;
    this.endIndex = endIndex ?? lastPageIndex;
    final prefill = models.user.channilUser;
    if (prefill != null) prefillFields(prefill);
    pageIndex = this.startIndex;
    pageController = PageController(initialPage: this.startIndex);
  }

  void prefillFields(ChannilUser user);
  bool isPageReady(int page);

  @override
  bool get isReady => isPageReady(pageIndex);

  void nextPage() {
    pageIndex++;
    pageController.nextPage(duration: pageDelay, curve: pageCurve);
    notifyListeners();
  }

  void prevPage() {
    pageIndex--;
    pageController.previousPage(duration: pageDelay, curve: pageCurve);
    notifyListeners();
  }

  // -------------------- Lifecycle -------------------- 

  @override
  Future<void> init() async {
    for (final controller in allControllers) {
      controller.addListener(notifyListeners);
    }
    for (final socialModel in socialModels) {
      socialModel.addListener(notifyListeners);
    }
    models.user.addListener(notifyListeners);
    await super.init();
  }

  @override
  void dispose() {
    for (final controller in allControllers) {
      controller.dispose();
    }
    for (final socialModel in socialModels) {
      socialModel.dispose();
    }
    models.user.removeListener(notifyListeners);
    super.dispose();
  }

  // -------------------- Authentication --------------------  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscureText = true;
  void updateObscurity(bool input) {  // ignore: avoid_positional_boolean_parameters
    obscureText = input;
    notifyListeners();
  }

  String? emailError;
  String? passwordError;
  bool accountCreated = false;
  bool get enableAccountCreation => !accountCreated
    && !models.user.isAuthenticated      
    && !models.user.hasAccount;

  Future<void> createAccount() async {
    emailError = null;
    passwordError = null;
    notifyListeners();
    final email = emailController.text;
    final password = passwordController.text;
    final confirmation = confirmPasswordController.text;
    if (email.isEmpty) {
      emailError = "Email must not be empty";
      notifyListeners();
      return;
    }
    if (password.isEmpty) {
      passwordError = "Password must not be empty";
      notifyListeners();
      return;
    }
    if (password != confirmation) {
      passwordError = "Passwords do not match";
      notifyListeners();
      return;
    }
    final result = await services.auth.signUpWithEmailAndPassword(email: email, password: password);
    switch (result) {
      case SignUpResult.accountExists: emailError = "There is already an account with this email";
      case SignUpResult.invalidEmail: emailError = "Invalid email";
      case SignUpResult.notAllowed: emailError = "New accounts are not accepted at this time";
      case SignUpResult.unknownError: passwordError = "An unknown error occurred";
      case SignUpResult.weakPassword: passwordError = "Password is too weak";
      case SignUpResult.ok: accountCreated = true;
    }
    notifyListeners();
  }

  // -------------------- Loading --------------------  
  String? errorStatus;
  String? loadingStatus;
  double? loadingProgress;

  // -------------------- Misc --------------------  
  
  Future<void> save();
  CloudStorageDir getCloudDir() => services.cloudStorage.getAssetsDir(uid: models.user.uid!, isBusiness: isBusiness);
  bool get isBusiness;

  List<TextEditingController> get allControllers;
  final socialModels = [
    for (final platform in SocialMediaPlatform.values)
      SocialMediaBuilder(platform),
  ];
  
  bool enableNotifications = false;
  bool acceptTos = false;

  // ignore: avoid_positional_boolean_parameters
  void toggleNotifications(bool input) {
    enableNotifications = input;
    notifyListeners();
  }

  // ignore: avoid_positional_boolean_parameters
  void toggleTos(bool input) {
    acceptTos = input;
    notifyListeners();
  }
}
