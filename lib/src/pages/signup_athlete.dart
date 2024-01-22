import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/widgets.dart";

import "signup_base.dart";

class AthleteSignUpPage extends ReactiveWidget<AthleteBuilder> {
  @override
  AthleteBuilder createModel() => AthleteBuilder();
  
  @override
  Widget build(BuildContext context, AthleteBuilder model) => Scaffold(
    body: SignUpPage(
      buttons: [
        if (model.pageIndex == 0) OutlinedButton(
          onPressed: context.pop,
          child: const Text("Cancel"),
        ) else OutlinedButton(
          onPressed: model.pageIndex == 1 && model.isPrefill ? null : model.prevPage,
          child: const Text("Back"),
        ),
        if (model.pageIndex == 5) OutlinedButton(
          onPressed: model.isReady && !model.isLoading ? model.save : null,
          child: const Text("Save"),
        ) else OutlinedButton(
          onPressed: model.isReady ? model.nextPage : null,
          child: const Text("Next"),
        ),
      ],
      child: PageView(
        controller: model.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ListView(children: _basicInfo(model)),
          ListView(children: _athleteProfile(context, model)),
          ListView(children: _profilePics(context, model)),
          ListView(children: _prompts(context, model)),
          ListView(children: _deals(context, model)),
          ListView(children: _confirm(context, model),),
        ],
      ),
    ),
  );

  List<Widget> _basicInfo(AthleteBuilder model) => [
    const SizedBox(height: 16),
    ChannilTextField(controller: model.firstController, hint: "First name", isRequired: true),
    const SizedBox(height: 16),
    ChannilTextField(controller: model.lastController, hint: "Last name", isRequired: true),
    const SizedBox(height: 16),
    GoogleAuthButton(signUp: true),
    if (models.user.hasAccount) 
      const Text("An account with this email already exists", style: TextStyle(color: Colors.red)),
  ];

  List<Widget> _athleteProfile(BuildContext context, AthleteBuilder model) => [
    const SizedBox(height: 16),
    ChannilTextField(controller: model.collegeController, hint: "College", isRequired: true),
    const SizedBox(height: 16),
    ChannilTextField(controller: model.gradYearController, hint: "Graduation Year", type: TextInputType.number, isRequired: true),
    const SizedBox(height: 16),
    Row(children: [
      Expanded(child: DropdownMenu(
        label: addRequiredStar("Sport"),
        expandedInsets: EdgeInsets.zero,
        controller: model.sportController,
        onSelected: (sport) => model.sport = sport,
        dropdownMenuEntries: [
          for (final sport in Sport.values) 
            DropdownMenuEntry(value: sport, label: sport.displayName),
        ],
      ),),
    ],),
    const SizedBox(height: 16),
    ChannilTextField(controller: model.pronounsController, hint: "Pronouns", isRequired: true),
    const SizedBox(height: 16),
    Text("Socials (Fill in at least one)", style: context.textTheme.titleMedium),
    for (final socialModel in model.socialModels) ...[
      SocialMediaWidget(socialModel),
      const SizedBox(height: 8),
    ],
  ];

  List<Widget> _profilePics(BuildContext context, AthleteBuilder model) => [
    Center(child: Text("Choose six profile pictures", style: context.textTheme.titleLarge),),
    const SizedBox(height: 4),
    Text("Tap a box to select a photo from your gallery", textAlign: TextAlign.center, style: context.textTheme.labelLarge),
    const SizedBox(height: 16),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      for (final index in [0, 1, 2]) Expanded(child: ChannilImagePicker(
        model.profilePics[index],
        profileModel: model,
        captionController: model.captionControllers[index],
        onPressedOverride: model.showPrompt ? () => showPrompt(context, model) : null,
      ),),
    ],),
    const SizedBox(height: 16),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      for (final index in [3, 4, 5]) Expanded(child: ChannilImagePicker(
        model.profilePics[index],
        profileModel: model,
        captionController: model.captionControllers[index],
        onPressedOverride: model.showPrompt ? () => showPrompt(context, model) : null,
      ),),
    ],),
  ];

  Future<void> showPrompt(BuildContext context, AthleteBuilder model) {
    model.showPrompt = false;
    return  showDialog(
      context: context, 
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Remember!"),
        content: const Text.rich(
          TextSpan(
            children: [
              TextSpan(text: "You're creating your brand!\n\n"),
              TextSpan(
                text: "Choose",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: " professional pictures that best represent you and your brand. Consider ",
              ),
              TextSpan(
                text: "avoiding",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: " pictures including illegal substances, profanity, and excessive skin exposure.",
              ),
            ],
          ),
        ),
        actions: [
          TextButton(child: const Text("Ok"), onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }

  List<Widget> _prompts(BuildContext context, AthleteBuilder model) => [
    Text("Choose at least two prompts", style: context.textTheme.titleLarge, textAlign: TextAlign.center),
    const SizedBox(height: 16),
    for (final (prompt, controller) in zip(allPrompts, model.promptControllers)) ...[
      Text(prompt, style: controller.text.isEmpty ? null : const TextStyle(fontWeight: FontWeight.bold)), 
      ChannilTextField(
        controller: controller, 
        enabled: controller.text.isNotEmpty || model.numPrompts < 2,
        hint: controller.text.isEmpty && model.numPrompts >= 2 ? "Only two prompts can be answered" : null,
      ),
      const SizedBox(height: 12),
    ],
  ];

  List<Widget> _deals(BuildContext context, AthleteBuilder model) => [
    Text("Deal Preferences", style: context.textTheme.titleLarge, textAlign: TextAlign.center),
    const SizedBox(height: 4),
    Text("Select all of your preferences", style: context.textTheme.bodyLarge, textAlign: TextAlign.center,),
    const SizedBox(height: 12),
    GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 2.5,
      mainAxisSpacing: 8,
      children: [
        for (final category in Industry.values) 
          if (category != Industry.other) ChannilChoice(
            name: category.displayName,
            isPicked: model.dealPreferences.contains(category),
            onChanged: (selected) => model.updateDealType(category, selected: selected),
            image: AssetImage(category.assetPath!),
          ),
      ],
    ),
    const SizedBox(height: 8),
    FractionallySizedBox(
      widthFactor: 1/2,
      child: SizedBox(height: 80, child: ChannilChoice(
        name: "Other",
        isPicked: model.dealPreferences.contains(Industry.other),
        onChanged: (selected) => model.updateDealType(Industry.other, selected: selected),
      ),),
    ),
  ];

  List<Widget> _confirm(BuildContext context, AthleteBuilder model) => [
    Text("Almost there!", style: context.textTheme.titleLarge, textAlign: TextAlign.center,),
    const SizedBox(height: 16),
    CheckboxListTile(
      title: const Text("Enable notifications"),
      subtitle: const Text("This is not required to continue"),
      value: model.enableNotifications, 
      onChanged: (input) => model.toggleNotifications(input ?? false),
    ),
    // const SizedBox(height: 16),
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
