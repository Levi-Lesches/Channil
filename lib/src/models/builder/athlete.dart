import "dart:typed_data";

import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/pages.dart";

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
  Set<Industry> dealPreferences = {};
  late final profilePics = [ 
    for (int index = 0; index < 6; index++) MultipleImageUploader(
      filename: "$index", 
      handleMultiple: (images) => updateProfilePics(images, index),
      getDir: getCloudDir,
    ),
  ];

  @override
  int get preferencesIndex => 4;

  @override
  int get lastPageIndex => 5;

  bool showPrompt = true;
  Sport? sport;

  AthleteBuilder({super.editPreferences}) {
    for (final imageModel in profilePics) {
      imageModel.addListener(notifyListeners);
    }
  }

  @override
  void prefillFields(ChannilUser user) {
    final parts = user.name.split(" ");
    final first = parts.first;
    final last = parts.last;
    final profile = user.profile as AthleteProfile;
    firstController.text = first;
    lastController.text = last;
    collegeController.text = profile.college;
    gradYearController.text = profile.graduationYear.toString();
    sportController.text = profile.sport.displayName;
    pronounsController.text = profile.pronouns;
    sport = profile.sport;
    dealPreferences = profile.dealPreferences;
    for (final (prompt, response) in profile.prompts.records) {
      final index = allPrompts.indexOf(prompt);
      promptControllers[index].text = response;
    }
    for (final (index, image) in profile.profilePics.enumerate) {
      final controller = captionControllers[index];
      controller.text = image.caption ?? "";
      profilePics[index].setImage(image);
    }
    for (final socialProfile in profile.socials) {
      final platform = socialProfile.platform;
      final model = socialModels.firstWhere((element) => element.platform == platform);
      model.prefill(socialProfile);
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
      sport: sport!,
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
      await models.user.saveUser(value);
    } catch (error) {
      errorStatus = "Could not save profile";
      rethrow;
    }
    
    loadingStatus = "Saved";
    isLoading = false;
    notifyListeners();
    router.goNamed(Routes.profile);
  }
}
