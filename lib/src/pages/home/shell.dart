import "package:flutter/material.dart";
import "package:channil/pages.dart";
import "package:channil/models.dart";
import "package:channil/widgets.dart";

import "profile.dart";

class HomeShell extends ReactiveWidget<HomeViewModel> {
  static const double iconSize = 48;

  final ChannilDestination initialDestination;
  const HomeShell(this.initialDestination);
  
  @override
  HomeViewModel createModel() => HomeViewModel(initialDestination);

  @override
  Widget build(BuildContext context, HomeViewModel model) => Scaffold(
    appBar: AppBar(
      title: Text(model.destination.title),
      bottom: model.appBarText == null ? null : PreferredSize(
        preferredSize: const Size.fromHeight(36),
        child: Center(child: Text(model.appBarText!, style: context.textTheme.headlineLarge)),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => context.pushNamed(Routes.settings),
        ),
      ],
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: model.destination.index,
      indicatorColor: context.colorScheme.primary.withOpacity(0),
      onDestinationSelected: model.updatePage,
      elevation: 16,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      destinations: [
        for (final destination in ChannilDestination.values) NavigationDestination(
          label: "",
          icon: SizedBox(width: iconSize, height: iconSize, child: destination.icon),
        ),
      ],
    ),
    body: Center(child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: switch (model.destination) {
        ChannilDestination.swipes => const Placeholder(),
        ChannilDestination.matches => const Placeholder(),
        ChannilDestination.chats => const Placeholder(),
        ChannilDestination.profile => ProfilePage(),
      },
    ),),
  );
}
