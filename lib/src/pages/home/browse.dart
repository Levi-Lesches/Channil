import "package:flutter/material.dart";

import "package:channil/models.dart";
import "package:channil/widgets.dart";

class BrowsePage extends ReactiveWidget<BrowseViewModel> {
  @override
  BrowseViewModel createModel() => BrowseViewModel();

  @override
  Widget build(BuildContext context, BrowseViewModel model) => const Center(child: Text("Placeholder"));
}
