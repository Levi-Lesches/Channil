import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/widgets.dart";

class SocialMediaWidget extends ReusableReactiveWidget<SocialMediaBuilder> {
  const SocialMediaWidget(super.model);

  @override
  Widget build(BuildContext context, SocialMediaBuilder model) => Column(children: [
    ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(model.platform.assetPath),
        backgroundColor: Colors.transparent,
        radius: 16,
      ),
      title: Text(model.platform.displayName),
    ),
    const SizedBox(height: 4),
    if (model.showUsername) Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0), 
      child: ChannilTextField(
        controller: model.usernameController, 
        hint: "Enter your username",
        prefix: model.platform == SocialMediaPlatform.instagram ? "@" : null,
      ),
    ),
    const SizedBox(height: 4),
    if (model.platform.urlPrefix == null) Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0), 
      child: ChannilTextField(controller: model.urlController, hint: "Enter your URL"),
    ),
    if (model.needsFollowers) Row(children: [
      const SizedBox(width: 8),
      const Text("Followers:"),
      const Spacer(),
      DropdownMenu<FollowerRange>(
        onSelected: model.updateRange,
        initialSelection: model.followerRange,
        dropdownMenuEntries: [
          for (final (min, max) in followerRanges)
            if (max == null) DropdownMenuEntry(label: ">$min", value: (min, max))
            else DropdownMenuEntry(value: (min, max), label: "$min - $max"),
        ],
      ),
    ],),
  ],);
}

class SocialMediaViewer extends StatelessWidget {
  final SocialMediaProfile social;
  const SocialMediaViewer(this.social);
  
  @override
  Widget build(BuildContext context) => ListTile(
    leading: Image.asset(social.platform.assetPath),
    title: Text(social.username),
    subtitle: social.platform.showFollowers
      ? Text("Followers: ${social.followerCount.$1}-${social.followerCount.$2}") : null,
  );
}
