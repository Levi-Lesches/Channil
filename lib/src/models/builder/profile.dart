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
  int get preferencesIndex;
  int get lastPageIndex;

  ProfileBuilder({bool editPreferences = false}) {
    final prefill = models.user.channilUser;
    if (editPreferences && prefill != null) {
      startIndex = preferencesIndex;
      endIndex = preferencesIndex;
      prefillFields(prefill);
    } else if (prefill == null) {
      startIndex = 0;
      endIndex = lastPageIndex;
    } else {
      startIndex = 1;
      endIndex = preferencesIndex - 1;
      prefillFields(prefill);
    }
    pageIndex = startIndex;
    pageController = PageController(initialPage: startIndex);
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
