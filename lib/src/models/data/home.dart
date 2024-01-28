import "package:channil/data.dart";
import "package:channil/main.dart";
import "package:flutter/material.dart";
import "package:channil/models.dart";
import "package:channil/pages.dart";

enum ChannilDestination {
  swipes("Browse"),
  matches("My Matches"),
  chats("Chats"),
  profile("Profile");

  final String title;
  const ChannilDestination(this.title);

  Widget getIcon({required bool isSelected}) => switch (this) {
    swipes => Image.asset("assets/logos/channil_small.png", color: isSelected ? channilGreen : Colors.black),
    matches => Icon(Icons.handshake, size: 36, color: isSelected ? channilGreen : null),
    chats => Icon(Icons.chat, size: 36, color: isSelected ? channilGreen : null),
    profile => Icon(Icons.account_circle, size: 36, color: isSelected ? channilGreen : null),
  };
}

class HomeModel extends DataModel {
  ChannilDestination destination;
  HomeModel(this.destination);
  final List<UserID> rejectedIDs = [];

  String? appBarText;

  @override
  Future<void> init() async { }

  void updatePageIndex(int index) {
    final route = ChannilDestination.values[index];
    router.replaceNamed<void>(switch (route) {
      ChannilDestination.profile => Routes.profile,
      ChannilDestination.swipes => Routes.browse,
      ChannilDestination.chats => Routes.profile,
      ChannilDestination.matches => Routes.profile,
    },);
  }

  void updatePage(ChannilDestination value) {
    destination = value;
    appBarText = switch (destination) {
      ChannilDestination.profile => models.user.channilUser?.name,
      ChannilDestination.chats => null,
      ChannilDestination.matches => null,
      ChannilDestination.swipes => appBarText,
    };
  }

  void updateAppBarText(String? value) {
    appBarText = value;
    notifyListeners();
  }
}
