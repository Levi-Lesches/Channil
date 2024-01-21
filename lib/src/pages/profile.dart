import "package:flutter/material.dart";

import "package:channil/models.dart";
import "package:channil/widgets.dart";

class ProfilePage extends ReactiveWidget<ProfileViewModel> {
  @override
  ProfileViewModel createModel() => ProfileViewModel();
  
  @override
  Widget build(BuildContext context, ProfileViewModel model) => Scaffold(
    appBar: AppBar(
      title: const Text("Profile"),
    ),
  );
}
