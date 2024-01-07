import "dart:typed_data";

import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/services.dart";

class AthleteBuilder extends ProfileBuilder<Athlete> {
  final firstController = TextEditingController();
  final lastController = TextEditingController();
  final collegeController = TextEditingController();
  final gradYearController = TextEditingController();
  final sportController = TextEditingController();
  final pronounsController = TextEditingController();
  final socialMediaController = TextEditingController();
  final followerCountController = TextEditingController();
  final promptControllers = [
    for (final _ in allPrompts) TextEditingController(),
  ];
  final captionControllers = List.generate(6, (_) => TextEditingController());

  bool showPrompt = true;
  Sport? sport;

  AthleteBuilder() {
    for (final imageModel in profilePics) {
      imageModel.addListener(notifyListeners);
    }
  }

  @override
  void dispose() {
    for (final imageModel in profilePics) {
      imageModel.dispose();
    }
    super.dispose();
  }

  @override
  List<TextEditingController> get allControllers => [
    firstController, lastController, collegeController, gradYearController,
    sportController, pronounsController, socialMediaController, followerCountController,
    ...captionControllers, ...promptControllers,
  ];

  @override
  bool get isBusiness => false;

  final Set<DealCategory> dealPreferences = {};

  bool enableNotifications = false;
  bool acceptTos = false;

  late final profilePics = [ 
    for (int index = 0; index < 6; index++) MultipleImageUploader(
      filename: "$index", 
      handleMultiple: (images) => updateProfilePics(images, index),
      getDir: getCloudDir,
    ),
  ];

  Future<void> updateProfilePics(List<Uint8List> images, int startIndex) => MultipleImageUploader.uploadMultiple(
    models: profilePics, images: images, startIndex: startIndex,
  );

  @override
  bool isPageReady(int page) => switch (page) {
    0 => firstController.text.isNotEmpty
      && lastController.text.isNotEmpty
      && uid != null
      && email != null,
    1 => collegeController.text.isNotEmpty
      && gradYearController.text.isNotEmpty
      && sportController.text.isNotEmpty
      && pronounsController.text.isNotEmpty
      && socialMediaController.text.isNotEmpty
      && followerCountController.text.isNotEmpty
      && sport != null,
    2 => profilePics.every((model) => model.getImage() != null),
    3 => numPrompts == 2,
    4 => true,  // deal preferences are not mandatory
    5 => acceptTos,
    _ => true,  // should not happen but safer to not throw
  };

  List<ChannilImage> getProfilePics() {
    final result = <ChannilImage>[];
    for (final (index, model) in profilePics.enumerate) {
      final image = model.getImage()!;
      final caption = captionControllers[index].text;
      image.caption = caption.isEmpty ? null : caption;
      result.add(image);
    }
    return result;
  }
  
  int get numPrompts => promptControllers.where(
    (controller) => controller.text.isNotEmpty,
  ).length;

  @override
  Athlete get value => Athlete(
    id: uid!,
    first: firstController.text,
    last: lastController.text,
    email: email!,
    profile: AthleteProfile(
      college: collegeController.text,
      graduationYear: int.parse(gradYearController.text),
      sport: sport!,  // TODO <--
      pronouns: pronounsController.text,
      socialMedia: socialMediaController.text,
      followerCount: int.parse(followerCountController.text),
      profilePics: getProfilePics(),
      prompts: {
        for (final (prompt, controller) in zip(allPrompts, promptControllers))
          if (controller.text.isNotEmpty)
            prompt: controller.text,
      },
      dealPreferences: dealPreferences,
    ),
  );

  void updateDealType(DealCategory dealType, {required bool selected}) {
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

  @override
  Future<void> save() async {
    isLoading = true;
    loadingProgress = null;
    errorStatus = null;
    loadingStatus = "Uploading profile...";
    
    try { 
      await services.database.saveAthlete(value);
    } catch (error) {
      errorStatus = "Could not save profile";
      rethrow;
    }
    
    isLoading = false;
    notifyListeners();
  }
}
