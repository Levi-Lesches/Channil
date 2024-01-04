import "dart:async";
import "dart:io";
import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/services.dart";

import "../model.dart";

class AthleteBuilder extends BuilderModel<Athlete> {
  final pageController = PageController();
  final firstController = TextEditingController();
  final lastController = TextEditingController();
  final collegeController = TextEditingController();
  final gradYearController = TextEditingController();
  final sportController = TextEditingController();
  final pronounsController = TextEditingController();
  final socialMediaController = TextEditingController();
  final followerCountController = TextEditingController();
  final List<ImageWithCaption?> profilePics = List.filled(6, null);
  final Map<String, String> prompts = {};
  final Set<String> dealPreferences = {};

  final List<TextEditingController> promptControllers = [
    for (final _ in allPrompts) 
      TextEditingController(),
  ];

  String? email;
  String? uid;
  String? gradYearError;
  String? followerCountError;
  int? gradYear;
  int? followerCount;
  bool enableNotifications = false;
  bool acceptTos = false;

  int pageIndex = 0;
  bool isLoading = false;
  String authStatus = "Pending";
  String? loadingStatus;
  double? loadingProgress;
  String? errorStatus;

  @override
  bool get isReady => switch (pageIndex) {
    0 => firstController.text.isNotEmpty
      && lastController.text.isNotEmpty
      && uid != null
      && email != null,
    1 => collegeController.text.isNotEmpty
      && gradYearController.text.isNotEmpty
      && gradYear != null
      && sportController.text.isNotEmpty
      && pronounsController.text.isNotEmpty
      && socialMediaController.text.isNotEmpty
      && followerCountController.text.isNotEmpty
      && followerCount != null,
    2 => profilePics.every((pic) => pic != null && pic.caption.isNotEmpty),
    3 => prompts.length >= 2,
    4 => true,  // deal preferences are not mandatory
    5 => acceptTos,
    _ => true,  // should not happen but safer to not throw
  };

  void nextPage() {
    pageIndex++;
    pageController.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
    notifyListeners();
  }

  void prevPage() {
    pageIndex--;
    pageController.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
    notifyListeners();
  }
  
  @override
  Athlete get value => Athlete(
    id: uid!,
    first: firstController.text,
    last: lastController.text,
    email: email!,
    profile: AthleteProfile(
      college: collegeController.text,
      graduationYear: gradYear!,
      sport: sportController.text,
      pronouns: pronounsController.text,
      socialMedia: socialMediaController.text,
      followerCount: followerCount!,
      profilePics: List<ImageWithCaption>.from(profilePics),
      prompts: prompts,
      dealPreferences: dealPreferences,
    ),
  );

  AthleteBuilder() {
    // Parse numbers
    gradYearController.addListener(gradYearListener);
    followerCountController.addListener(followerCountListener);
    // Listen for prompts that have been filled out
    for (final (index, controller) in promptControllers.enumerate) {
      controller.addListener(() => updatePrompt(index));
    }
    // Everything else
    firstController.addListener(notifyListeners);
    lastController.addListener(notifyListeners);
    collegeController.addListener(notifyListeners);
    sportController.addListener(notifyListeners);
    pronounsController.addListener(notifyListeners);
    socialMediaController.addListener(notifyListeners);
  }

  @override
  void dispose() {
    gradYearController.removeListener(gradYearListener);
    followerCountController.removeListener(followerCountListener);
    firstController.removeListener(notifyListeners);
    lastController.removeListener(notifyListeners);
    collegeController.removeListener(notifyListeners);
    sportController.removeListener(notifyListeners);
    pronounsController.removeListener(notifyListeners);
    socialMediaController.removeListener(notifyListeners);
    super.dispose();
  }

  void gradYearListener() {
    gradYear = int.tryParse(gradYearController.text.trim());
    if (gradYearController.text.isEmpty) {
      gradYearError = null;
    } else if (gradYear != null && gradYear! < 0) {
      gradYearError = "Can't graduate in a negative year";
      gradYear = null;
    } else if (gradYear != null && gradYear! >= 0) {
      gradYearError = null;
    } else {
      gradYearError = "Invalid integer";
    }
    notifyListeners();
  }

  void followerCountListener() {
    followerCount = int.tryParse(followerCountController.text.trim());
    if (followerCountController.text.isEmpty) {
      followerCountError = null;
    } else if (followerCount != null && followerCount! < 0) {
      followerCountError = "Can't have negative followers";
      followerCount = null;
    } else if (followerCount != null && followerCount! >= 0) {
      followerCountError = null;
    } else {
      followerCountError = "Invalid integer";
    } 
    notifyListeners();
  }

  Future<void> authenticate() async {
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
      authStatus = "Pending";
      notifyListeners();
    } else {
      email = user.email;
      uid = user.uid;
      authStatus = "Authenticated as $email";
      notifyListeners();
    }
  }

  Future<String?> uploadImage({
    required String localFilename,
    required String cloudFilename,
  }) async {
    loadingProgress = null;
    final task = services.cloudStorage.uploadImage(
      isBusiness: false,
      uid: uid!, 
      localFile: File(localFilename),
      filename: cloudFilename,
    );
    try {
      await task.monitor(onTaskUpdate);
      await Future<void>.delayed(const Duration(milliseconds: 500));
      return await services.cloudStorage.getImageUrl(
        uid: uid!, 
        isBusiness: false,
        filename: cloudFilename,
      );
    } catch (error) {
      errorStatus = "Could not upload photo. Please check your internet and try again";
      notifyListeners();
      return null;
    }
  }

  Future<void> replaceImage(int index) async {
    final imagePaths = await services.files.pickImages();
    if (imagePaths == null) return;
    for (final (i, path) in imagePaths.enumerate.take(6)) {
      profilePics[index + i] = ImageWithCaption(
        type: ImageType.file,
        imageUrl: path,
        caption: "",
      );
    }
    notifyListeners();
  }

  void updateCaption(int index, String caption) {
    profilePics[index]?.caption = caption;
    notifyListeners();
  }

  void updatePrompt(int index) {
    final controller = promptControllers[index];
    final response = controller.text.trim();
    final prompt = allPrompts[index];
    if (response.isEmpty) {
      prompts.remove(prompt);
    } else {
      prompts[prompt] = controller.text;
    }
    notifyListeners();
  }

  void updateDealType(String dealType, {required bool selected}) {
    if (selected) {
      dealPreferences.add(dealType);
    } else {
      dealPreferences.remove(dealType);
    }
    notifyListeners();
  }

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

  void onTaskUpdate(TaskSnapshot snapshot) {
    if (snapshot.state == TaskState.error) {
      errorStatus = "Could not upload photo. Check your internet and try again";
    } else {
      loadingProgress = snapshot.progress;
    }
    notifyListeners();
  }

  Future<void> saveImages() async {
    isLoading = true;
    errorStatus = null;
    loadingStatus = "Uploading photos...";
    notifyListeners();

    for (final (index, image) in profilePics.enumerate) {
      loadingStatus = "Uploading photo ${index + 1}/6...";
      loadingProgress = null;
      notifyListeners();
      if (image == null) continue;
      final extension = image.imageUrl.extension;
      final filename = "$index.$extension";
      final url = await uploadImage(localFilename: image.imageUrl, cloudFilename: filename);
      if (url == null) return;
      image.imageUrl = url;
      image.type = ImageType.network;
    }
  }

  Future<void> saveProfile() async {
    isLoading = true;
    errorStatus = null;
    loadingProgress = null;
    loadingStatus = "Uploading profile...";
    notifyListeners();

    try { 
      final athlete = value;
      await services.database.saveAthlete(athlete);
    } catch (error) {
      isLoading = false;
      errorStatus = "Could not save profile";
      notifyListeners();
      return;
    }
  }

  Future<void> save() async {
    await saveImages();
    await saveProfile();
    errorStatus = null;
    isLoading = false;
    notifyListeners();
  }
}
