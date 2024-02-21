import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/widgets.dart";

class HomeShell extends ReactiveWidget<HomeModel> {
  static const double iconSize = 36;

  final int index;
  final UserID? userID;
  final StatefulNavigationShell child;
  HomeShell({required this.child, this.userID}) : 
    index = child.currentIndex;

  @override
  HomeModel createModel() => HomeModel(child.currentIndex, userID: userID);

  @override
  void didUpdateWidget(HomeShell oldWidget, HomeModel model) {
    model.updateIndex(index);
    super.didUpdateWidget(oldWidget, model);
  }

  @override
  Widget build(BuildContext context, HomeModel model) => Scaffold(
    body: child,
    bottomNavigationBar: model.userID != null ? null : NavigationBar(
      selectedIndex: model.index,
      indicatorColor: context.colorScheme.primary.withOpacity(0),
      onDestinationSelected: child.goBranch,
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
