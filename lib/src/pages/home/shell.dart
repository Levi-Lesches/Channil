import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/pages.dart";
import "package:channil/widgets.dart";

class HomeShell extends ReactiveWidget<HomeModel> {
  static const double iconSize = 48;

  final ChannilDestination destination;
  final UserID? userID;
  final Widget child;
  HomeShell({required String? name, required this.child, this.userID}) : 
    destination = switch (name) {
      Routes.profile => ChannilDestination.profile,
      Routes.chats => ChannilDestination.chats,
      Routes.matches => ChannilDestination.matches,
      Routes.browse => ChannilDestination.swipes,
      _ => throw ArgumentError("Unknown name"),
    };

  @override
  HomeModel createModel() => HomeModel(destination, userID: userID);

  @override
  void didUpdateWidget(HomeShell oldWidget, HomeModel model) {
    model.updateDestination(destination);
  }

  @override
  Widget build(BuildContext context, HomeModel model) => Scaffold(
    body: child,
    bottomNavigationBar: model.userID != null ? null : NavigationBar(
      selectedIndex: model.destination.index,
      indicatorColor: context.colorScheme.primary.withOpacity(0),
      onDestinationSelected: model.updatePageIndex,
      elevation: 16,
      destinations: [
        for (final destination in ChannilDestination.values) NavigationDestination(
          label: destination.title,
          icon: SizedBox(
            width: iconSize, 
            height: iconSize, 
            child: destination.getIcon(isSelected: model.destination == destination),
          ),
        ),
      ],
    ),
  );
}
