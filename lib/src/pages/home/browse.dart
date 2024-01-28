import "package:channil/src/pages/home/profile.dart";
import "package:flutter/material.dart";

import "package:channil/models.dart";
import "package:channil/widgets.dart";

class BrowsePage extends ReactiveWidget<BrowseViewModel> {
  @override
  BrowseViewModel createModel() => BrowseViewModel();

  @override
  Widget build(BuildContext context, BrowseViewModel model) => model.isLoading
    ? const Center(child: CircularProgressIndicator())
    : model.errorText != null 
      ? Center(child: Text(model.errorText!))
      : Stack(children: [
        ProfilePage(user: model.currentUser, key: ValueKey(model.currentUser!.id)),
        BrowseButton(
          left: 24, 
          icon: const Icon(Icons.close, size: 48, color: Colors.red), 
          onPressed: model.reject,
        ),
        BrowseButton(
          right: 24, 
          icon: const Icon(Icons.handshake, size: 48, color: Colors.green), 
          // onPressed: model.accept,
          onPressed: () {},
        ),
      ],);
}

class BrowseButton extends StatelessWidget {
  final double? left;
  final double? right;
  final Widget icon;
  final VoidCallback onPressed;
  const BrowseButton({
    required this.onPressed,
    required this.icon,
    this.left,
    this.right,
  });

  @override
  Widget build(BuildContext context) => Positioned(
    bottom: 72, 
    left: left, 
    right: right,
    child: SizedBox(
      height: 100, 
      width: 100, 
      child: Material(
        elevation: 16,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onPressed,
          child: icon, 
        ),
      ),
    ),
  );
}
