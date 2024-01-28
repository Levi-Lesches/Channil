import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/pages.dart";
import "package:channil/widgets.dart";

import "profile.dart";
import "browse.dart";
import "matches.dart";

class HomeShell extends ReactiveWidget<HomeModel> {
  static const double iconSize = 48;

  final ChannilDestination destination;
  final UserID? userID;
  const HomeShell(this.destination, {this.userID});

  @override
  HomeModel createModel() => HomeModel(destination, userID: userID);

  @override
  Widget build(BuildContext context, HomeModel model) => Scaffold(
    appBar: AppBar(
      title: Text(model.destination.title),
      bottom: model.appBarText == null ? null : PreferredSize(
        preferredSize: const Size.fromHeight(36),
        child: Padding(
          padding: const EdgeInsets.all(8), 
          child: Text(model.appBarText!, style: context.textTheme.headlineLarge),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => context.pushNamed(Routes.settings),
        ),
      ],
    ),
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
    body: Center(child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: switch (model.destination) {
        ChannilDestination.swipes => BrowsePage(model),
        ChannilDestination.matches => MatchesPage(model),
        ChannilDestination.chats => const Placeholder(),
        ChannilDestination.profile => ProfilePage(model, user: model.userID),
      },
    ),),
  );
}
