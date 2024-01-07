import "dart:async";

import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/services.dart";

abstract class ProfileBuilder<T> extends BuilderModel<T> {
  // -------------------- Page handling --------------------  
  static const pageDelay = Duration(milliseconds: 250);
  static const pageCurve = Curves.easeInOut;
  final pageController = PageController();
  int pageIndex = 0;
  bool isPageReady(int page);

  StreamSubscription<GoogleAccount?>? _authSubscription;

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

  ProfileBuilder() {
    final user = services.auth.user;
    updateUser(user);
    for (final controller in allControllers) {
      controller.addListener(notifyListeners);
    }
    for (final socialModel in socialModels) {
      socialModel.addListener(notifyListeners);
    }
    _authSubscription = services.auth.google.onCurrentUserChanged.listen(_onUserChanged);
  }

  @override
  void dispose() {
    for (final controller in allControllers) {
      controller.dispose();
    }
    for (final socialModel in socialModels) {
      socialModel.dispose();
    }
    _authSubscription?.cancel();
    super.dispose();
  }
  
  // -------------------- Authentication -------------------- 
  String? email;
  String? uid;
  String authStatus = "Pending";

  void updateUser(FirebaseUser? user) {
    if (user == null) return;
    email = user.email;
    uid = user.uid;
    authStatus = "Authenticated as $email";
    notifyListeners();
  }

  Future<void> signInGoogleMobile() async {
    authStatus = "Loading...";
    email = null; 
    notifyListeners();
    await services.auth.signOut();
    final FirebaseUser? user;
    try {
      user = await services.auth.signIn();
      updateUser(user);
    } catch (error) {
      authStatus = "Error signing in";
      notifyListeners();
      return;
    }
    if (user == null) {
      authStatus = "Cancelled";
      notifyListeners();
    } else {
    }
  }

  // Needed for Web
  Future<void> _onUserChanged(GoogleAccount? account) async {
    if (account == null) return;
    final user = await services.auth.signInWithGoogleWeb(account);
    if (user == null) return;
    updateUser(user);
  }

  // -------------------- Loading --------------------  
  bool isLoading = false;
  String? errorStatus;
  String? loadingStatus;
  double? loadingProgress;

  // -------------------- Misc --------------------  
  Future<void> save();
  CloudStorageDir getCloudDir() => services.cloudStorage.getAssetsDir(uid: uid!, isBusiness: isBusiness);
  bool get isBusiness;

  List<TextEditingController> get allControllers;
  final socialModels = [
    for (final platform in SocialMediaPlatform.values)
      SocialMediaBuilder(platform),
  ];
}
