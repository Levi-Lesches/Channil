import "dart:typed_data";
import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/pages.dart";
import "package:channil/models.dart";

class BusinessBuilder extends ProfileBuilder<ChannilUser> {
  // Text fields
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final websiteController = TextEditingController();
  Set<Sport> sports = {};
  Set<Industry> industries = {};

  @override
  int get preferencesIndex => 3;

  @override
  int get lastPageIndex => 4;


  @override
  List<TextEditingController> get allControllers => [
    nameController, locationController, websiteController,
  ];

  @override
  bool get isBusiness => true;

  @override
  void prefillFields(ChannilUser user) {
    final profile = user.profile as BusinessProfile;
    nameController.text = user.name;
    locationController.text = profile.location;
    websiteController.text = profile.website ?? "";
    sports = profile.sports;
    industries = profile.industries;
    logo.setImage(profile.logo);
    productImage.setImage(profile.productImage);
    for (final (index, image) in profile.additionalImages.enumerate) {
      additionalImages[index].setImage(image);
    }
    for (final socialProfile in profile.socials) {
      final platform = socialProfile.platform;
      final model = socialModels.firstWhere((element) => element.platform == platform);
      model.prefill(socialProfile);
    }
  }

  // Images
  late final logo = SingleImageUploader(
    filename: "logo", 
    getDir: getCloudDir,
  );
  late final productImage = SingleImageUploader(
    filename: "product", 
    getDir: getCloudDir,
  );
  late final additionalImages = [
    for (var index = 0; index < 4; index++) MultipleImageUploader(
      filename: "additional_$index", 
      handleMultiple: (images) => updateAdditionalImages(images, index),
      getDir: getCloudDir,
    ),
  ];

  void updateAdditionalImages(List<Uint8List> images, int index) => MultipleImageUploader.uploadMultiple(
    models: additionalImages, images: images, startIndex: index,
  );

  BusinessBuilder({super.editPreferences}) {
    for (final imageModel in [logo, productImage, ...additionalImages]) {
      imageModel.addListener(notifyListeners);
    }
  }

  void toggleSport(Sport sport, {required bool isSelected}) {
    if (isSelected) {
      sports.add(sport);
    } else {
      sports.remove(sport);
    }
    notifyListeners();
  }

  @override
  bool isPageReady(int page) => switch (page) {
    0 => nameController.text.isNotEmpty 
      && models.user.isAuthenticated
      && !models.user.hasAccount,
    1 => industries.isNotEmpty
      && locationController.text.isNotEmpty
      && socialModels.any((social) => social.isReady),
    2 => logo.getImage() != null,
    3 => true,
    4 => acceptTos,
    _ => true,  // Should not happen but safer to not throw
  };

  @override
  void dispose() {
    logo.dispose();
    productImage.dispose();
    for (final uploader in additionalImages) {
      uploader.dispose();
    }
    super.dispose();
  }

  void toggleIndustry(Industry industry, {required bool isSelected}) {
    if (isSelected) { 
      industries.add(industry);
    } else {
      industries.remove(industry);
    }
    notifyListeners();
  }

  @override
  ChannilUser get value => ChannilUser(
    id: models.user.uid!,
    name: nameController.text.trim(),
    email: models.user.email!,
    profile: BusinessProfile(
      industries: industries,
      location: locationController.text,
      socials: [
        for (final socialModel in socialModels) 
          if (socialModel.isReady) socialModel.value,
      ],
      website: websiteController.text.isEmpty ? null : websiteController.text,
      sports: sports,
      logo: logo.getImage()!,
      productImage: productImage.getImage(),
      additionalImages: [
        for (final model in additionalImages) 
          model.getImage(),
      ],
    ),
  );

  @override
  Future<void> save() async {
    isLoading = true;
    loadingProgress = null;
    loadingStatus = "Uploading profile...";
    notifyListeners();
    await models.user.saveUser(value);
    isLoading = false;
    loadingStatus = "Saved";
    router.goNamed(Routes.profile);
    notifyListeners();
  }
}
