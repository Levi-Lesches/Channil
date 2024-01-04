import "dart:io";
import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/services.dart";

import "../model.dart";

class BusinessBuilder extends BuilderModel<Business> {  
  final pageController = PageController();
  final nameController = TextEditingController();
  final industryController = TextEditingController();
  final locationController = TextEditingController();
  final socialController = TextEditingController();
  final websiteController = TextEditingController();
  
  String? logoPath;
  String? logoUrl;
  String? productImagePath;
  String? productImageUrl;
  List<String> additionalImages = [];
  List<String> additionalUrls = [];
  
  String authStatus = "Pending";
  String? email;
  String? uid;
  int pageIndex = 0;

  bool isLoading = false;
  double? loadingProgress;
  String? loadingStatus;
  String? errorStatus;

  @override
  bool get isReady => switch (pageIndex) {
    0 => nameController.text.isNotEmpty && uid != null && email != null,
    1 => industryController.text.isNotEmpty
      && locationController.text.isNotEmpty
      && socialController.text.isNotEmpty,
    2 => logoPath != null,
    3 => true,
    _ => true,  // Should not happen but safer to not throw
  };

  BusinessBuilder() {
    nameController.addListener(notifyListeners);
    industryController.addListener(notifyListeners);
    locationController.addListener(notifyListeners);
    socialController.addListener(notifyListeners);
    websiteController.addListener(notifyListeners);
  }

  @override
  void dispose() {
    nameController.removeListener(notifyListeners);
    industryController.removeListener(notifyListeners);
    locationController.removeListener(notifyListeners);
    socialController.removeListener(notifyListeners);
    websiteController.removeListener(notifyListeners);
    super.dispose();
  }

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

  Future<void> uploadLogo() async {
    logoPath = await services.files.pickImage();
    if (logoPath == null) return;
    notifyListeners();
  }
  
  Future<void> uploadProductImage() async {
    productImagePath = await services.files.pickImage();
    if (productImagePath == null) return;
    notifyListeners();
  }
  
  Future<void> uploadAdditionalImage() async {
    final imagePaths = await services.files.pickImages();
    if (imagePaths == null) return;
    for (final path in imagePaths) {
      additionalImages.add(path); 
    }
    notifyListeners();
  }

  Future<void> deleteAdditionalImage(int index) async {
    // TODO: Actually delete the image
    additionalImages.removeAt(index);
    notifyListeners();
  }
  
  @override
  Business get value => Business(
    id: uid!,
    name: nameController.text,
    email: email!,
    industry: industryController.text,
    location: locationController.text,
    socialMediaLink: socialController.text,
    website: websiteController.text.isEmpty ? null : websiteController.text,
    logoUrl: logoUrl!,
    productImageUrl: productImageUrl,
    additionalImageUrls: additionalUrls,
  );

  void onTaskUpdate(TaskSnapshot snapshot) {
    if (snapshot.state == TaskState.error) {
      errorStatus = "Could not upload photo. Check your internet and try again";
    } else {
      loadingProgress = snapshot.progress;
    }
    notifyListeners();
  }

  Future<String?> uploadImage({
    required String localFilename,
    required String cloudFilename,
  }) async {
    loadingProgress = null;
    final task = services.cloudStorage.uploadImage(
      isBusiness: true,
      uid: uid!, 
      localFile: File(localFilename),
      filename: cloudFilename,
    );
    try {
      await task.monitor(onTaskUpdate);
      return await services.cloudStorage.getImageUrl(uid: uid!, filename: cloudFilename);
    } catch (error) {
      errorStatus = "Could not upload photo. Please check your internet and try again";
      notifyListeners();
      return null;
    }
  }

  Future<void> saveImages() async {
    // [!] Logo is non-null because of [isReady] on page 
    isLoading = true;
    loadingStatus = "Uploading logo...";
    notifyListeners();
    logoUrl = await uploadImage(localFilename: logoPath!, cloudFilename: "logo");
    if (logoUrl == null) return;
    if (productImagePath != null) {
      loadingStatus = "Uploading product image...";
      notifyListeners();
      productImageUrl = await uploadImage(localFilename: productImagePath!, cloudFilename: "product");
      if (productImageUrl == null) return;
    }
    final length = additionalImages.length;
    additionalUrls.clear();
    for (final (index, image) in additionalImages.enumerate) {
      loadingStatus = "Uploading additional images (${index + 1}/$length)...";
      notifyListeners();
      final url = await uploadImage(localFilename: image, cloudFilename: "additional_$index");
      if (url == null) return;
      additionalUrls.add(url);
    }
  }

  Future<void> saveProfile() async {
    loadingProgress = null;
    loadingStatus = "Uploading profile...";
    notifyListeners();
    final business = value;
    await services.database.saveBusiness(business);
  }

  Future<void> save() async {
    await saveImages();
    if (logoUrl == null) return;
    if (errorStatus != null) return;
    await saveProfile();
    isLoading = false;
    notifyListeners();
  }
}
