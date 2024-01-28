import "package:flutter/material.dart";
import "package:channil/models.dart";

enum ChannilDestination {
  swipes("Match"),
  matches("My Matches"),
  chats("Chats"),
  profile("Profile");

  final String title;
  const ChannilDestination(this.title);

  Widget get icon => switch (this) {
    swipes => Image.asset("assets/logos/channil_small.png"),
    matches => const Icon(Icons.handshake, size: 36),
    chats => const Icon(Icons.chat, size: 36),
    profile => const Icon(Icons.account_circle, size: 36),
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
