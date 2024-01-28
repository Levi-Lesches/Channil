import "package:channil/main.dart";
import "package:flutter/material.dart";
import "package:channil/models.dart";

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

class HomeViewModel extends ViewModel { 
  ChannilDestination destination;
  HomeViewModel(this.destination);

  void updatePage(int index) {
    destination = ChannilDestination.values[index];
    notifyListeners();
  }

  String? get appBarText => switch (destination) {
    ChannilDestination.profile => models.user.channilUser?.name,
    _ => null,
  };
}
