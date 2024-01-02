import "package:channil/data.dart";
import "package:flutter/material.dart";

import "../model.dart";

class AthleteBuilder extends BuilderModel<Athlete> {
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

  
  String authStatus = "Pending";
  String? email;
  String? gradYearError;
  String? followerCountError;
  int? gradYear;
  int? followerCount;
  int pageIndex = 0;
  bool enableNotifications = false;
  bool acceptTos = false;

  @override
  bool get isReady => switch (pageIndex) {
    0 => firstController.text.isNotEmpty
      && lastController.text.isNotEmpty
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
    3 => prompts.length == 2,
    4 => true,  // deal preferences are not mandatory
    5 => acceptTos,
    _ => true,  // should not happen but safer to not throw
  };

  void nextPage() {
    pageIndex++;
    notifyListeners();
  }

  void prevPage() {
    pageIndex--;
    notifyListeners();
  }
  
  @override
  Athlete get value => Athlete(
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
      profileImagesUrls: profilePics as List<ImageWithCaption>,
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
    } else if (gradYear == null) {
      gradYearError = "Invalid integer";
    } else if (gradYear! < 0) {
      gradYearError = "Can't graduate in a negative year";
      gradYear = null;
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
    await Future<void>.delayed(const Duration(seconds: 1));
    authStatus = "Authenticated";
    email = "athlete@gmail.com";
    notifyListeners();
  }

  Future<void> save() async {

  }

  Future<void> replaceImage(int index) async {
    profilePics[index] = ImageWithCaption(
      imageUrl: "https://picsum.photos/200",
      caption: "",
    );
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
}
