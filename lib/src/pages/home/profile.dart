import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/widgets.dart";

class ProfilePage extends ReactiveWidget<ProfileViewModel> {
  final UserID? user;
  final HomeModel home;
  ProfilePage(this.home, {this.user}) : super(key: ValueKey(user));
  
  @override
  ProfileViewModel createModel() => ProfileViewModel(home, profileID: user);
  
  @override
  Widget build(BuildContext context, ProfileViewModel model) => model.isLoading 
    ? const Center(child: CircularProgressIndicator()) 
    : model.user.matchProfileType<Widget>(
      handleBusiness: (profile) => BusinessProfilePage(user: model.user, profile: profile),
      handleAthlete: (profile) => AthleteProfilePage(user: model.user, profile: profile),
    );
}

class BusinessProfilePage extends StatelessWidget {
  final BusinessProfile profile;
  final ChannilUser user;
  const BusinessProfilePage({required this.user, required this.profile});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(48),
    cacheExtent: MediaQuery.of(context).size.height * 2,
    children: [
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
          boldAndNormal(context, "Website: ", profile.website!),
          const Divider(),
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
  final AthleteProfile profile;
  final ChannilUser user;
  const AthleteProfilePage({required this.user, required this.profile});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(48),
    shrinkWrap: true,
    cacheExtent: MediaQuery.of(context).size.height * 8,
    children: [
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
        Text(profile.prompts.keys.first, style: context.textTheme.titleMedium),
        const SizedBox(height: 12),
        Text(profile.prompts.values.first, style: context.textTheme.titleLarge),
      ],),
      const SizedBox(height: 24),
      ChannilImageViewer(profile.profilePics[2]),
      const SizedBox(height: 24),
      ChannilImageViewer(profile.profilePics[3]),
      const SizedBox(height: 24),
      InfoBox(children: [
        Text(profile.prompts.keys.last, style: context.textTheme.titleMedium),
        const SizedBox(height: 12),
        Text(profile.prompts.values.last, style: context.textTheme.titleLarge),
      ],),
      const SizedBox(height: 24),
      ChannilImageViewer(profile.profilePics[4]),
      const SizedBox(height: 24),
      ChannilImageViewer(profile.profilePics[5]),
      const SizedBox(height: 24),
    ],
  );
}
