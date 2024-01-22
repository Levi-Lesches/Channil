import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/widgets.dart";

class ProfilePage extends ReactiveWidget<ProfileViewModel> {
  @override
  ProfileViewModel createModel() => ProfileViewModel();
  
  @override
  Widget build(BuildContext context, ProfileViewModel model) => model.isLoading 
    ? const Center(child: CircularProgressIndicator()) 
    : switch (model.user.profile) {
      BusinessProfile() => BusinessProfilePage(model),
      AthleteProfile() => AthleteProfilePage(model),
    };
}

class BusinessProfilePage extends StatelessWidget {
  final ProfileViewModel model;
  final BusinessProfile profile;
  final ChannilUser user;
  BusinessProfilePage(this.model) : 
    user = model.user,
    profile = model.user.profile as BusinessProfile;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(48),
    children: [
      Text(user.name, style: context.textTheme.headlineLarge, textAlign: TextAlign.center),
      const SizedBox(height: 24),
      ChannilImageViewer(profile.logo, aspectRatio: 2),
      const SizedBox(height: 24),
      InfoBox(children: [
        boldAndNormal(context, "Company: ", user.name),
        const Divider(),
        boldAndNormal(context, "Industry: ", profile.industries.map((i) => i.displayName).join(", ")),
        const Divider(),
        boldAndNormal(context, "Location: ", profile.location),
        const Divider(),
        if (profile.website != null) ...[
          const Divider(),
          boldAndNormal(context, "Website: ", profile.website!),
        ],
        for (final social in profile.socials) 
          SocialMediaViewer(social),          
      ],),
      if (profile.productImage != null) ...[
        const SizedBox(height: 24),
        Text("Our product", style: context.textTheme.headlineSmall, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        ChannilImageViewer(profile.productImage!),
      ],
      if (profile.additionalImages.any((i) => i != null)) ...[
        const SizedBox(height: 24),
        Text("More images", style: context.textTheme.headlineSmall, textAlign: TextAlign.center),
        const SizedBox(height: 8),
      ],
      for (final image in profile.additionalImages) 
        if (image != null) ...[
          ChannilImageViewer(image),
          const SizedBox(height: 24),
        ],
    ],
  );
}

class AthleteProfilePage extends StatelessWidget {
  final ProfileViewModel model;
  final AthleteProfile profile;
  final ChannilUser user;
  AthleteProfilePage(this.model) : 
    profile = model.user.profile as AthleteProfile,
    user = model.user;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(48),
    children: [
      Text(user.name, style: context.textTheme.headlineLarge, textAlign: TextAlign.center),
      const SizedBox(height: 24),
      ChannilImageViewer(profile.profilePics[0]),
      const SizedBox(height: 24),
      InfoBox(children: [
        boldAndNormal(context, "Graduation year: ", profile.graduationYear.toString()),
        const Divider(),
        boldAndNormal(context, "Sport: ", profile.sport.displayName),
        const Divider(),
        boldAndNormal(context, "School: ", profile.college),
        const Divider(),
        for (final social in profile.socials) 
          SocialMediaViewer(social),
      ],),
      const SizedBox(height: 24),
      ChannilImageViewer(profile.profilePics[1]),
      const SizedBox(height: 24),
      InfoBox(children: [
        Text(profile.prompts.keys.first, style: context.textTheme.titleLarge),
        const SizedBox(height: 12),
        Text(profile.prompts.values.first, style: context.textTheme.bodyLarge,),
      ],),
      const SizedBox(height: 24),
      ChannilImageViewer(profile.profilePics[2]),
      const SizedBox(height: 24),
      ChannilImageViewer(profile.profilePics[3]),
      const SizedBox(height: 24),
      InfoBox(children: [
        Text(profile.prompts.keys.last, style: context.textTheme.titleLarge),
        const SizedBox(height: 12),
        Text(profile.prompts.values.last, style: context.textTheme.bodyLarge,),
      ],),
      const SizedBox(height: 24),
      ChannilImageViewer(profile.profilePics[4]),
      const SizedBox(height: 24),
      ChannilImageViewer(profile.profilePics[5]),
      const SizedBox(height: 24),
    ],
  );
}
