import "package:channil/data.dart";
import "package:flutter/material.dart";

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
      if (model.pageIndex == 4) OutlinedButton(
        onPressed: model.isReady && !model.isLoading ? model.save : null,
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
        ListView(children: _selectSports(context, model)),
        ListView(children: _confirm(context, model)),
      ],
    ),
  );

  List<Widget> _authInfo(BusinessBuilder model) => [
    const SizedBox(height: 16),
    ChannilTextField(controller: model.nameController, hint: "Company Name"),
    const SizedBox(height: 16),
    AuthenticationWidget(onPressed: model.authenticateWithGoogle, status: model.authStatus),
  ];

  List<Widget> _companyInfo(BusinessBuilder model) => [
    const SizedBox(height: 16),
    Row(children: [
      Expanded(child: DropdownMenu(
        label: const Text("Industry"),
        expandedInsets: EdgeInsets.zero,
        controller: model.industryController,
        onSelected: (industry) => model.industry = industry,
        dropdownMenuEntries: [
          for (final category in DealCategory.values) 
            DropdownMenuEntry(value: category, label: category.displayName),
        ],
      ),),
    ],),
    // ChannilTextField(controller: model.industryController, hint: "Industry"),
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
    if (model.logo.state is! ImageStateEmpty) ImagePicker(
      model.logo,
      profileModel: model,
    ),
    const SizedBox(height: 8),
    OutlinedButton(
      onPressed: model.logo.onTap,
      child: const Text("Select image"),
    ),
    const SizedBox(height: 24),
    Text("Add a product image", style: context.textTheme.titleLarge),
    const SizedBox(height: 12),
    if (model.productImage.state is! ImageStateEmpty) ImagePicker(
      model.productImage,
      profileModel: model,
    ),
    const SizedBox(height: 8),
    OutlinedButton(
      onPressed: model.productImage.onTap,
      child: const Text("Select image"),
    ),
    const SizedBox(height: 24),
    Text("Add additional images", style: context.textTheme.titleLarge),
    const SizedBox(height: 12),
    OutlinedButton(
      onPressed: model.additionalImages[0].onTap,
      child: const Text("Select images"),
    ),
    const SizedBox(height: 8),
    Row(children: [
      for (final index in [0, 1]) Expanded(child: ImagePicker(
        model.additionalImages[index],
        profileModel: model,
      ),),
    ],),
    const SizedBox(height: 8),
    Row(children: [
      for (final index in [2, 3]) Expanded(child: ImagePicker(
        model.additionalImages[index],
        profileModel: model,
      ),),
    ],),
  ];

  List<Widget> _selectSports(BuildContext context, BusinessBuilder model) => [
    Text("Select your preferred sports", style: context.textTheme.headlineMedium, textAlign: TextAlign.center),
    const SizedBox(height: 16),
    Wrap(
      runSpacing: 8,
      spacing: 8,
      runAlignment: WrapAlignment.center,
      alignment: WrapAlignment.center,
      children: [
        for (final sport in Sport.values) FilterChip.elevated(
          label: Text(sport.displayName), 
          onSelected: (value) => model.toggleSport(sport, isSelected: value), 
          selected: model.sports.contains(sport),
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
