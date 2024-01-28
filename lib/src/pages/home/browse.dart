import "package:channil/src/pages/home/profile.dart";
import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/widgets.dart";

class BrowsePage extends ReactiveWidget<BrowseViewModel> {
  final HomeModel home;
  const BrowsePage(this.home);
  
  @override
  BrowseViewModel createModel() => BrowseViewModel(home);

  Future<void> accept(BuildContext context, BrowseViewModel model) async {
    final user = model.currentUser!;
    final message = await showDialog<Message>(
      context: context,
      builder: (context) => MessageEditor(title: "Connect with ${user.name}"),
    );
    if (message == null) return;
    if (!context.mounted) return;
    await model.connect(message);
  }

  @override
  Widget build(BuildContext context, BrowseViewModel model) => model.isLoading
    ? const Center(child: CircularProgressIndicator())
    : model.errorText != null 
      ? Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(model.errorText!, textAlign: TextAlign.center, style: context.textTheme.bodyLarge),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: model.clearRejections, 
            child: const Text("Clear rejections"),
          ),
        ],
      ),)
      : Stack(children: [
        ProfilePage(home, user: model.currentUser!.id),
        SquareButton(
          left: 24, 
          icon: const Icon(Icons.close, size: 48, color: Colors.red), 
          onPressed: model.reject,
        ),
        SquareButton(
          right: 24, 
          icon: const Icon(Icons.handshake, size: 48, color: Colors.green), 
          onPressed: () => accept(context, model),
        ),
      ],);
}
