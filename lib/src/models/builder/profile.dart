import "package:flutter/material.dart";

import "package:channil/services.dart";

import "../model.dart";

abstract class ProfileBuilder<T> extends BuilderModel<T> {
  // -------------------- Page handling --------------------  
  static const pageDelay = Duration(milliseconds: 250);
  static const pageCurve = Curves.easeInOut;
  final pageController = PageController();
  int pageIndex = 0;
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

  // -------------------- Text fields -------------------- 
  List<TextEditingController> get allControllers;
  ProfileBuilder() {
    for (final controller in allControllers) {
      controller.addListener(notifyListeners);
    }
  }

  @override
  void dispose() {
    for (final controller in allControllers) {
      controller.dispose();
    }
    super.dispose();
  }
  
  // -------------------- Authentication -------------------- 
  String? email;
  String? uid;
  String authStatus = "Pending";

  Future<void> authenticateWithGoogle() async {
    authStatus = "Loading...";
    email = null; 
    notifyListeners();
    await services.auth.signOut();
    final FirebaseUser? user;
    try {
      user = await services.auth.signIn();
    } catch (error) {
      authStatus = "Error signing in";
      notifyListeners();
      return;
    }
    if (user == null) {
      authStatus = "Cancelled";
      notifyListeners();
    } else {
      email = user.email;
      uid = user.uid;
      authStatus = "Authenticated as $email";
      notifyListeners();
    }
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
}
