import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/widgets.dart";

class AthleteSignUpPage extends ReactiveWidget<AthleteBuilder> {
  @override
  AthleteBuilder createModel() => AthleteBuilder();
  
  @override
  Widget build(BuildContext context, AthleteBuilder model) => Scaffold(
    body: Center(child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: ListView(children: [
        const Center(child: ChannilLogo()),
        const SizedBox(height: 75),

        if (model.pageIndex == 0) ..._basicInfo(model)
        else if (model.pageIndex == 1) ..._athleteProfile(model)
        else if (model.pageIndex == 2) ..._profilePics(context, model)
        else if (model.pageIndex == 3) ..._prompts(context, model)
        else if (model.pageIndex == 4) ..._deals(context, model)
        else if (model.pageIndex == 5) ..._confirm(context, model),
        const SizedBox(height: 16),

        ButtonBar(
          children: [
            if (model.pageIndex == 0) OutlinedButton(
              onPressed: context.pop,
              child: const Text("Cancel"),
            ) else OutlinedButton(
              onPressed: model.prevPage,
              child: const Text("Back"),
            ),
            if (model.pageIndex == 5) OutlinedButton(
              onPressed: model.isReady ? model.save : null,
              child: const Text("Save"),
            ) else OutlinedButton(
              onPressed: model.isReady ? model.nextPage : null,
              child: const Text("Next"),
            ),
          ],
        ),
      ],),
    ),),
  );

  List<Widget> _basicInfo(AthleteBuilder model) => [
    ChannilTextField(controller: model.firstController, hint: "First name"),
    const SizedBox(height: 16),
    ChannilTextField(controller: model.lastController, hint: "Last name"),
    const SizedBox(height: 16),
    AuthenticationWidget(onPressed: model.authenticate, status: model.authStatus),
  ];

  List<Widget> _athleteProfile(AthleteBuilder model) => [
    ChannilTextField(controller: model.collegeController, hint: "College"),
    const SizedBox(height: 16),
    ChannilTextField(controller: model.gradYearController, hint: "Graduation Year", error: model.gradYearError),
    const SizedBox(height: 16),
    ChannilTextField(controller: model.sportController, hint: "Sport"),
    const SizedBox(height: 16),
    ChannilTextField(controller: model.pronounsController, hint: "Pronouns"),
    const SizedBox(height: 16),
    ChannilTextField(controller: model.socialMediaController, hint: "Social Media"),
    const SizedBox(height: 16),
    ChannilTextField(controller: model.followerCountController, hint: "Follower count", error: model.followerCountError),
  ];

  List<Widget> _profilePics(BuildContext context, AthleteBuilder model) => [
    Center(child: Text("Choose six profile pictures", style: context.textTheme.titleLarge),),
    const SizedBox(height: 4),
    Text("Tap a box to select a photo from your gallery", textAlign: TextAlign.center, style: context.textTheme.labelLarge),
    const SizedBox(height: 16),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      for (final index in [0, 1, 2]) ImagePicker(
        image: model.profilePics[index],
        onTap: () => model.replaceImage(index),
        onChanged: (caption) => model.updateCaption(index, caption),
        key: ValueKey(index),
      ),
    ],),
    const SizedBox(height: 16),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      for (final index in [3, 4, 5]) ImagePicker(
        image: model.profilePics[index],
        onTap: () => model.replaceImage(index),
        onChanged: (caption) => model.updateCaption(index, caption),
        key: ValueKey(index),
      ),
    ],),
  ];

  List<Widget> _prompts(BuildContext context, AthleteBuilder model) => [
    Text("Choose at least two prompts", style: context.textTheme.titleLarge, textAlign: TextAlign.center),
    const SizedBox(height: 16),
    for (final (index, prompt) in allPrompts.enumerate) ...[
      Text(prompt), 
      ChannilTextField(controller: model.promptControllers[index], hint: ""),
      const SizedBox(height: 12),
    ],
  ];

  List<Widget> _deals(BuildContext context, AthleteBuilder model) => [
    Text("Deal Preferences", style: context.textTheme.titleLarge, textAlign: TextAlign.center,),
    const SizedBox(height: 4),
    Text("Select all of your preferences", style: context.textTheme.bodyLarge, textAlign: TextAlign.center,),
    const SizedBox(height: 12),
    Wrap(
      alignment: WrapAlignment.center,
      runSpacing: 8,
      spacing: 8,
      children: [
        for (final dealType in allDealTypes) FilterChip(
          label: Text(dealType),
          selected: model.dealPreferences.contains(dealType),
          onSelected: (selected) => model.updateDealType(dealType, selected: selected),
        ),
      ],
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
    const SizedBox(height: 16),
    CheckboxListTile(
      title: const Text("Accept the Terms of Service"),
      value: model.acceptTos, 
      onChanged: (input) => model.toggleTos(input ?? false),
    ),
  ];
}
