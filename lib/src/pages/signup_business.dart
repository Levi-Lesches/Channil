import "package:flutter/material.dart";

import "package:channil/models.dart";
import "package:channil/widgets.dart";

Widget textField(TextEditingController controller, String hint) => TextField(
  controller: controller,
  decoration: InputDecoration(
    border: const OutlineInputBorder(),
    hintText: hint,
  ),
);

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
    textField(model.nameController, "Company Name"),
    const SizedBox(height: 16),
    textField(model.emailController, "Email"),
    const SizedBox(height: 16),
    Row(children: [
      SizedBox(width: 200, child: ListTile(
        title: const Text("Authentication"),
        subtitle: Text(model.authStatus),
      ),),
      // const Spacer(),
      OutlinedButton(
        onPressed: model.authenticate, 
        child: const Text("Sign in with Google"),
      ),
    ],),
  ];

  List<Widget> _companyInfo(BusinessBuilder model) => [
    textField(model.industryController, "Industry"),
    const SizedBox(height: 16),
    textField(model.locationController, "Location"),
    const SizedBox(height: 16),
    textField(model.socialController, "Social Media"),
    const SizedBox(height: 16),
    textField(model.websiteController, "Website"),
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

extension <E> on List<E> {
  Iterable<(int, E)> get enumerate sync* {
    for (var i = 0; i < length; i++) {
      yield (i, this[i]);
    }
  }
}
