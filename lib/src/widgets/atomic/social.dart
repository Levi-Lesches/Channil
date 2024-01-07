import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/widgets.dart";

class SocialMediaWidget extends ReusableReactiveWidget<SocialMediaBuilder> {
  const SocialMediaWidget(super.model);

  ImageProvider get logo => AssetImage(switch (model.platform) {
    SocialMediaPlatform.facebook => "assets/facebook.png",
    SocialMediaPlatform.instagram => "assets/instagram.png",
    SocialMediaPlatform.linkedin => "assets/linkedin.png",
    SocialMediaPlatform.tikTok => "assets/tiktok.jpg",
    SocialMediaPlatform.twitter => "assets/x.webp",
  },);

  @override
  Widget build(BuildContext context, SocialMediaBuilder model) => Column(children: [
    ListTile(
      leading: CircleAvatar(backgroundImage: logo),
      title: Text(model.platform.displayName),
    ),
    const SizedBox(height: 4),
    Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0), 
      child: ChannilTextField(controller: model.usernameController, hint: "Enter your username"),
    ),
    const SizedBox(height: 4),
    if (model.platform.urlPrefix == null) Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0), 
      child: ChannilTextField(controller: model.urlController, hint: "Enter your URL"),
    ),
    Row(children: [
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
