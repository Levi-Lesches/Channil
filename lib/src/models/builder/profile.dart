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

  @override
  Future<void> init() async {
    for (final controller in allControllers) {
      controller.addListener(notifyListeners);
    }
    for (final socialModel in socialModels) {
      socialModel.addListener(notifyListeners);
    }
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
    _authSubscription?.cancel();
    super.dispose();
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
