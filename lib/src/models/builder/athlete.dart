import "dart:typed_data";

import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/services.dart";

class AthleteBuilder extends ProfileBuilder<ChannilUser> {
  final firstController = TextEditingController();
  final lastController = TextEditingController();
  final collegeController = TextEditingController();
  final gradYearController = TextEditingController();
  final sportController = TextEditingController();
  final pronounsController = TextEditingController();
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
    sportController, pronounsController,
    ...captionControllers, ...promptControllers,
  ];

  @override
  bool get isBusiness => false;

  final Set<Industry> dealPreferences = {};

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
    0 => firstController.text.trim().isNotEmpty
      && lastController.text.trim().isNotEmpty
      && models.user.isAuthenticated      
      && !models.user.hasAccount,
    1 => collegeController.text.trim().isNotEmpty
      && gradYearController.text.trim().isNotEmpty
      && sportController.text.trim().isNotEmpty
      && pronounsController.text.trim().isNotEmpty
      && socialModels.any((model) => model.isReady)
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
  ChannilUser get value => ChannilUser(
    id: models.user.uid!,
    name: "${firstController.text.trim()} ${lastController.text.trim()}",
    email: models.user.email!,
    profile: AthleteProfile(
      college: collegeController.text,
      graduationYear: int.parse(gradYearController.text.trim()),
      sport: sport!,  // TODO <--
      pronouns: pronounsController.text.trim(),
      socials: [
        for (final socialModel in socialModels)
          if (socialModel.isReady)
            socialModel.value,
      ],
      profilePics: getProfilePics(),
      prompts: {
        for (final (prompt, controller) in zip(allPrompts, promptControllers))
          if (controller.text.isNotEmpty)
            prompt: controller.text,
      },
      dealPreferences: dealPreferences,
    ),
  );

  void updateDealType(Industry dealType, {required bool selected}) {
    if (selected) {
      dealPreferences.add(dealType);
    } else {
      dealPreferences.remove(dealType);
    }
    notifyListeners();
  }


  @override
  Future<void> save() async {
    isLoading = true;
    loadingProgress = null;
    errorStatus = null;
    loadingStatus = "Uploading profile...";
    
    try { 
      await services.database.saveUser(value);
    } catch (error) {
      errorStatus = "Could not save profile";
      rethrow;
    }
    
    loadingStatus = "Saved";
    isLoading = false;
    notifyListeners();
  }
}
