import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/widgets.dart";

class BusinessSignUpPage extends ReactiveWidget<BusinessBuilder> {
  @override
  BusinessBuilder createModel() => BusinessBuilder();
  
  @override
  Widget build(BuildContext context, BusinessBuilder model) => Scaffold(
    body: Center(child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(children: [
        const Center(child: ChannilLogo()),
        const Spacer(flex: 2),
        if (model.pageIndex == 0) ..._authInfo(model)
        else if (model.pageIndex == 1) ..._companyInfo(model)
        else if (model.pageIndex == 2) ..._uploadImages(context, model),
        const Spacer(),
        ButtonBar(
          children: [
            if (model.pageIndex == 0) OutlinedButton(
              onPressed: context.pop,
              child: const Text("Cancel"),
            ) else OutlinedButton(
              onPressed: model.prevPage,
              child: const Text("Back"),
            ),
            if (model.pageIndex == 2) OutlinedButton(
              onPressed: model.isPageReady ? model.save : null,
              child: const Text("Save"),
            ) else OutlinedButton(
              onPressed: model.isPageReady ? model.nextPage : null,
              child: const Text("Next"),
            ),
          ],
        ),
      ],),
    ),),
  );

  List<Widget> _authInfo(BusinessBuilder model) => [
    ChannilTextField(controller: model.nameController, hint: "Company Name"),
    const SizedBox(height: 16),
    AuthenticationWidget(onPressed: model.authenticate, status: model.authStatus),
  ];

  List<Widget> _companyInfo(BusinessBuilder model) => [
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
    Text("Add a company logo", style: context.textTheme.titleLarge),
    const SizedBox(height: 12),
    OutlinedButton(
      onPressed: model.uploadLogo,
      child: const Text("Select image"),
    ),
    const SizedBox(height: 24),
    Text("Add a product image", style: context.textTheme.titleLarge),
    const SizedBox(height: 12),
    OutlinedButton(
      onPressed: model.uploadProductImage,
      child: const Text("Select image"),
    ),
    const SizedBox(height: 24),
    Text("Add additional images", style: context.textTheme.titleLarge),
    const SizedBox(height: 12),
    OutlinedButton(
      onPressed: model.uploadAdditionalImage,
      child: const Text("Select image"),
    ),
    for (final (index, image) in model.additionalImages.enumerate) ListTile(
      title: const Text("Image"),
      leading: Image.network(image, key: ValueKey(index)),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => model.deleteAdditionalImage(index),
      ),
    ),
  ];
}
