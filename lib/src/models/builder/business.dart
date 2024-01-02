import "package:flutter/material.dart";

import "package:channil/data.dart";
import "../model.dart";

class BusinessBuilder extends BuilderModel<Business> {  
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final industryController = TextEditingController();
  final locationController = TextEditingController();
  final socialController = TextEditingController();
  final websiteController = TextEditingController();
  
  String? logoUrl;
  String? productImageUrl;
  List<String> additionalImages = [];
  
  String authStatus = "Pending";
  bool authenticated = false;
  int pageIndex = 0;

  bool get isPageReady => switch (pageIndex) {
    0 => authenticated,
    1 => industryController.text.isNotEmpty
      && locationController.text.isNotEmpty
      && socialController.text.isNotEmpty,
    2 => logoUrl != null,
    _ => true,  // Should not happen but safer to not throw
  };

  BusinessBuilder() {
    nameController.addListener(notifyListeners);
    emailController.addListener(notifyListeners);
    industryController.addListener(notifyListeners);
    locationController.addListener(notifyListeners);
    socialController.addListener(notifyListeners);
    websiteController.addListener(notifyListeners);
  }

  @override
  void dispose() {
    nameController.removeListener(notifyListeners);
    emailController.removeListener(notifyListeners);
    industryController.removeListener(notifyListeners);
    locationController.removeListener(notifyListeners);
    socialController.removeListener(notifyListeners);
    websiteController.removeListener(notifyListeners);
    super.dispose();
  }

  void nextPage() {
    pageIndex++;
    notifyListeners();
  }

  void prevPage() {
    pageIndex--;
    notifyListeners();
  }
  
  Future<void> authenticate() async {
    authStatus = "Loading...";
    notifyListeners();
    await Future<void>.delayed(const Duration(seconds: 1));
    authStatus = "Authenticated";
    notifyListeners();
    authenticated = true;
  }

  Future<void> uploadLogo() async {
    // TODO: Upload the image
    logoUrl = "Fake URL";
    notifyListeners();
  }
  
  Future<void> uploadProductImage() async {
    // TODO: Upload the image
  }
  
  Future<void> uploadAdditionalImage() async {
    // TODO: Upload the image
    additionalImages.add("https://picsum.photos/200");
    notifyListeners();
  }

  Future<void> deleteAdditionalImage(int index) async {
    // TODO: Actually delete the image
    additionalImages.removeAt(index);
    notifyListeners();
  }
  
  @override
  bool get isReady => isPageReady;
  
  @override
  Business get value => Business(
    name: nameController.text,
    email: emailController.text,
    industry: industryController.text,
    location: locationController.text,
    socialMediaLink: socialController.text,
    website: websiteController.text.isEmpty ? null : websiteController.text,
    logoUrl: "",
    productImageUrl: "",
    additionalImageUrls: [],    
  );

  Future<void> save() async {

  }
}
