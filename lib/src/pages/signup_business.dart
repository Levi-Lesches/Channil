import "package:channil/data.dart";
import "package:flutter/material.dart";

import "package:channil/models.dart";
import "package:channil/widgets.dart";

import "signup_base.dart";

class BusinessSignUpPage extends ReactiveWidget<BusinessBuilder> {
  final int? startIndex;
  final int? endIndex;
  const BusinessSignUpPage({this.startIndex, this.endIndex});
  
  @override
  BusinessBuilder createModel() => BusinessBuilder(startIndex: startIndex, endIndex: endIndex);
  
  @override
  Widget build(BuildContext context, BusinessBuilder model) => SignUpPage(
    buttons: [
      if (model.pageIndex == 0) OutlinedButton(
        onPressed: context.pop,
        child: const Text("Cancel"),
      ) else OutlinedButton(
        onPressed: model.pageIndex == model.startIndex ? null : model.prevPage,
        child: const Text("Back"),
      ),
      if (model.pageIndex == model.endIndex) OutlinedButton(
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
        ListView(children: _authInfo(context, model)),
        ListView(children: _companyInfo(context, model)),
        ListView(children: _uploadImages(context, model)),
        ListView(children: _selectSports(context, model)),
        ListView(children: _confirm(context, model)),
      ],
    ),
  );

  List<Widget> _authInfo(BuildContext context, BusinessBuilder model) => [
    const SizedBox(height: 16),
    ChannilTextField(controller: model.nameController, hint: "Company Name", isRequired: true),
    const SizedBox(height: 16),
    const Divider(),
    const SizedBox(height: 16),
    GoogleAuthButton(signUp: true),
      if (models.user.hasAccount) 
        const Text("An account with this email already exists", style: TextStyle(color: Colors.red)),
    const SizedBox(height: 8),
    Text(
      "or\n",
      textAlign: TextAlign.center,
      style: context.textTheme.titleLarge,
    ),
    const SizedBox(height: 8),
    ChannilTextField(
      controller: model.emailController,
      capitalization: TextCapitalization.none,
      type: TextInputType.emailAddress,
      hint: "Email",
      error: model.emailError,
    ),
    const SizedBox(height: 8),
    ChannilTextField(
      controller: model.passwordController,
      hint: "Password",
      obscureText: model.obscureText,
      onObscure: model.updateObscurity,
      action: TextInputAction.done,
      capitalization: TextCapitalization.none,
      type: TextInputType.visiblePassword,
      error: model.passwordError,
      onEditingComplete: model.createAccount,
    ),
    const SizedBox(height: 8),
    OutlinedButton(
      onPressed: model.createAccount,
      child: Text(
        "Sign up with email and password", 
        style: context.textTheme.titleLarge?.copyWith(fontSize: 20),
      ),
    ),
  ];

  List<Widget> _companyInfo(BuildContext context, BusinessBuilder model) => [
    const SizedBox(height: 16),
    Row(children: [
      Expanded(child: DropdownSelect<Industry>(
        title: addRequiredStar("Select industries"),
        getName: (industry) => industry.displayName,
        items: Industry.values,
        selectedItems: model.industries,
        onChanged: model.toggleIndustry,
      ),),
    ],),
    const SizedBox(height: 16),
    ChannilTextField(controller: model.locationController, hint: "Location", isRequired: true),
    const SizedBox(height: 16),
    ChannilTextField(controller: model.websiteController, hint: "Website", type: TextInputType.url, capitalization: TextCapitalization.none),
    const SizedBox(height: 16),
    Text("Social media profiles (Choose at least one)", style: context.textTheme.titleMedium),
    for (final socialModel in model.socialModels) 
      SocialMediaWidget(socialModel),
  ];

  List<Widget> _uploadImages(BuildContext context, BusinessBuilder model) => [
    const SizedBox(height: 16),
    addRequiredStar("Add a company logo", style: context.textTheme.titleLarge),
    const SizedBox(height: 12),
    if (model.logo.state is! ImageStateEmpty) ChannilImagePicker(
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
    if (model.productImage.state is! ImageStateEmpty) ChannilImagePicker(
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
      for (final index in [0, 1]) Expanded(child: ChannilImagePicker(
        model.additionalImages[index],
        profileModel: model,
      ),),
    ],),
    const SizedBox(height: 8),
    Row(children: [
      for (final index in [2, 3]) Expanded(child: ChannilImagePicker(
        model.additionalImages[index],
        profileModel: model,
      ),),
    ],),
  ];

  List<Widget> _selectSports(BuildContext context, BusinessBuilder model) => [
    Text("Select your preferred sports", style: context.textTheme.headlineMedium, textAlign: TextAlign.center),
    const SizedBox(height: 16),
    GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 2.5,
      children: [
        for (final sport in Sport.values) ChannilChoice(
          name: sport.displayName, 
          image: AssetImage(sport.assetPath),
          onChanged: (value) => model.toggleSport(sport, isSelected: value), 
          isPicked: model.sports.contains(sport),
        ),
      ],
    ),
  ];

  List<Widget> _confirm(BuildContext context, BusinessBuilder model) => [
    Text("Almost there!", style: context.textTheme.displaySmall, textAlign: TextAlign.center,),
    const SizedBox(height: 16),
    CheckboxListTile(
      title: const Text("Enable notifications"),
      subtitle: const Text("This is not required to continue"),
      value: model.enableNotifications, 
      onChanged: (input) => model.toggleNotifications(input ?? false),
    ),
    CheckboxListTile(
      title: addRequiredStar("Accept the Terms of Service"),
      value: model.acceptTos, 
      onChanged: (input) => model.toggleTos(input ?? false),
    ),
    const SizedBox(height: 24),
    if (model.isLoading) LinearProgressIndicator(value: model.loadingProgress),
    if (model.loadingStatus != null) Text(model.loadingStatus!),
    if (model.errorStatus != null) Text(model.errorStatus!, style: TextStyle(color: context.colorScheme.error)),
  ];
}
