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

  ProfileBuilder() {
    final prefill = models.user.channilUser;
    if (prefill == null) {
      pageController = PageController();
      pageIndex = 0;
    } else {
      pageController = PageController(initialPage: 1);
      pageIndex = 1;
      prefillFields(prefill);
    }
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
