import "package:channil/services.dart";
import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/main.dart";
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

class HomeModel extends ViewModel {
  int index;
  ChannilDestination destination;
  UserID? userID;
  HomeModel(this.index, {this.userID}) : 
    destination = ChannilDestination.values[index];

  List<Connection> connections = [];
  final List<UserID> rejectedIDs = [];
  Set<UserID> get matchedIDs => {
    for (final connection in connections) ...[
      connection.from,
      connection.to,
    ],
  };

  String? appBarText;

  @override
  Future<void> init() async {
    await getConnections();
  }

  void updateIndex(int value) {
    index = value;
    destination = ChannilDestination.values[index];
    notifyListeners();
  }
  
  Future<void> getConnections() async {
    connections = await services.database.getConnections(models.user.channilUser!.id);
    notifyListeners();
  }

  void updatePageIndex(int index) {
    userID = null;
    final dest = ChannilDestination.values[index];
    router.goNamed(switch (dest) {
      ChannilDestination.profile => Routes.profile,
      ChannilDestination.swipes => Routes.browse,
      ChannilDestination.chats => Routes.chats,
      ChannilDestination.matches => Routes.matches,
    },);
  }

  void updateDestination(ChannilDestination newDestination) {
    destination = newDestination;
    appBarText = switch (destination) {
      ChannilDestination.profile => models.user.channilUser?.name,
      ChannilDestination.chats => null,
      ChannilDestination.matches => null,
      ChannilDestination.swipes => appBarText,
    };
    notifyListeners();
  }

  void updateAppBarText(String? value) {
    appBarText = value;
    notifyListeners();
  }
}
