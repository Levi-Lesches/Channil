import "package:channil/widgets.dart";
import "package:flutter/material.dart";

import "package:channil/pages.dart";

AppBar channilAppBar({
  required BuildContext context,
  required String title,
  Widget? leading,
  String? header,
  List<Widget> actions = const [],
}) => AppBar(
  title: Text(title),
  leading: leading,
  scrolledUnderElevation: 8,
  shadowColor: Colors.black,
  bottom: header == null ? null : PreferredSize(
    preferredSize: const Size.fromHeight(24), 
    child: Text(header, style: context.textTheme.displaySmall),
  ),
  actions: [
    ...actions,
    IconButton(
      icon: const Icon(Icons.settings),
      tooltip: "Settings",
      onPressed: () => context.go(Routes.settings),
    ),
  ],
);
