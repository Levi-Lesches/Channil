import "dart:typed_data";
import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/services.dart";
import "package:channil/models.dart";

class BusinessBuilder extends ProfileBuilder<Business> {
  // Text fields
  final nameController = TextEditingController();
  final industryController = TextEditingController();
  final locationController = TextEditingController();
  final websiteController = TextEditingController();
  final Set<Sport> sports = {};
  DealCategory? industry;

  @override
  List<TextEditingController> get allControllers => [
    nameController, industryController, locationController, websiteController,
  ];

  @override
  bool get isBusiness => true;

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

  BusinessBuilder() {
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
    0 => nameController.text.isNotEmpty && uid != null && email != null,
    1 => industryController.text.isNotEmpty
      && industry != null
      && locationController.text.isNotEmpty
      && socialModels.any((social) => social.isReady),
    2 => logo.getImage() != null,
    3 => true,
    4 => true,
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

  @override
  Business get value => Business(
    id: uid!,
    name: nameController.text,
    email: email!,
    industry: industry!,
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
  );

  @override
  Future<void> save() async {
    isLoading = true;
    loadingProgress = null;
    loadingStatus = "Uploading profile...";
    notifyListeners();
    await services.database.saveBusiness(value);
    isLoading = false;
    notifyListeners();
  }
}
