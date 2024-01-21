import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/pages.dart";
import "package:channil/widgets.dart";

class ProfilePage extends ReactiveWidget<ProfileViewModel> {
  @override
  ProfileViewModel createModel() => ProfileViewModel();
  
  @override
  Widget build(BuildContext context, ProfileViewModel model) => Scaffold(
    appBar: AppBar(
      title: const Text("Profile"),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => context.pushNamed(Routes.settings),
        ),
      ],
    ),
    body: model.isLoading 
      ? const Center(child: CircularProgressIndicator()) 
      : switch (model.user.profile) {
        BusinessProfile() => BusinessProfilePage(model),
        AthleteProfile() => AthleteProfilePage(model),
      },
  );
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
      AspectRatio(
        aspectRatio: 1,
        child: ChannilImageViewer(profile.profilePics[0]),
      ),
    ],
  );
}
