import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/widgets.dart";

import "signup_base.dart";

class BusinessSignUpPage extends ReactiveWidget<BusinessBuilder> {
  @override
  BusinessBuilder createModel() => BusinessBuilder();
  
  @override
  Widget build(BuildContext context, BusinessBuilder model) => SignUpPage(
    buttons: [
      if (model.pageIndex == 0) OutlinedButton(
        onPressed: context.pop,
        child: const Text("Cancel"),
      ) else OutlinedButton(
        onPressed: model.prevPage,
        child: const Text("Back"),
      ),
      if (model.pageIndex == 3) OutlinedButton(
        onPressed: model.isReady ? model.save : null,
        child: const Text("Save"),
      ) else OutlinedButton(
        onPressed: model.isReady ? model.nextPage : null,
        child: const Text("Next"),
      ),
    ],
    child: PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: model.pageController,
      children: [
        ListView(children: _authInfo(model)),
        ListView(children: _companyInfo(model)),
        ListView(children: _uploadImages(context, model)),
        ListView(children: _confirm(context, model)),
      ],
    ),
  );

  List<Widget> _authInfo(BusinessBuilder model) => [
    const SizedBox(height: 16),
    ChannilTextField(controller: model.nameController, hint: "Company Name"),
    const SizedBox(height: 16),
    AuthenticationWidget(onPressed: model.authenticate, status: model.authStatus),
  ];

  List<Widget> _companyInfo(BusinessBuilder model) => [
    const SizedBox(height: 16),
    ChannilTextField(controller: model.industryController, hint: "Industry"),
    const SizedBox(height: 16),
    ChannilTextField(controller: model.locationController, hint: "Location"),
    const SizedBox(height: 16),
    ChannilTextField(controller: model.socialController, hint: "Social Media"),
    const SizedBox(height: 16),
    ChannilTextField(controller: model.websiteController, hint: "Website"),
    const SizedBox(height: 16),
  ];

  List<Widget> _uploadImages(BuildContext context, BusinessBuilder model) => [
    const SizedBox(height: 16),
    Text("Add a company logo", style: context.textTheme.titleLarge),
    const SizedBox(height: 12),
    if (model.logoPath != null) ImagePicker(
      image: model.logoPath == null ? null : ImageWithCaption.fromFile(model.logoPath!),
      onTap: () { },
      onChanged: (caption) { },
      key: ValueKey(model.logoPath),
      hasCaption: false,
    ),
    const SizedBox(height: 8),
    OutlinedButton(
      onPressed: model.uploadLogo,
      child: const Text("Select image"),
    ),
    const SizedBox(height: 24),
    Text("Add a product image", style: context.textTheme.titleLarge),
    const SizedBox(height: 12),
    if (model.productImagePath != null) ImagePicker(
      image: model.productImagePath == null ? null : ImageWithCaption.fromFile(model.productImagePath!),
      onTap: () { },
      onChanged: (caption) { },
      key: ValueKey(model.productImagePath),
      hasCaption: false,
    ),
    const SizedBox(height: 8),
    OutlinedButton(
      onPressed: model.uploadProductImage,
      child: const Text("Select image"),
    ),
    const SizedBox(height: 24),
    Text("Add additional images", style: context.textTheme.titleLarge),
    const SizedBox(height: 12),
    OutlinedButton(
      onPressed: model.uploadAdditionalImage,
      child: const Text("Select images"),
    ),
    for (final (index, image) in model.additionalImages.enumerate) Row(
      children: [
        Expanded(child: SizedBox(
          height: 150, 
          child: ImagePicker(
            image: ImageWithCaption.fromFile(image),
            onTap: () { },
            onChanged: (caption) { },
            key: ValueKey(image),
            hasCaption: false,
          ),
        ),),
        OutlinedButton(
          onPressed: () => model.deleteAdditionalImage(index),
          key: ValueKey(image),
          child: const Text("Delete"),
        ),
      ],
    ),
  ];

  List<Widget> _confirm(BuildContext context, BusinessBuilder model) => [
    Center(child: Text("Confirm and Save", style: context.textTheme.displaySmall)),
    const SizedBox(height: 24),
    if (model.isLoading) LinearProgressIndicator(value: model.loadingProgress),
    if (model.loadingStatus != null) Text(model.loadingStatus!),
    if (model.errorStatus != null) Text(model.errorStatus!, style: TextStyle(color: context.colorScheme.error)),
  ];
}
