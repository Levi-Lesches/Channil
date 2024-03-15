import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/widgets.dart";

class PendingConnectionWidget extends StatelessWidget {
  final Connection connection;
  final VoidCallback onTap;
  const PendingConnectionWidget({
    required this.connection,
    required this.onTap,
  });
  
  String get otherImage => models.user.channilUser!.id == connection.from
    ? connection.toImageUrl : connection.fromImageUrl;

  String get otherName => models.user.channilUser!.id == connection.from
    ? connection.toName : connection.fromName;

  UserID get otherID => models.user.channilUser!.id == connection.from
    ? connection.toName : connection.fromName;
  
  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 1,
    child: Card(
      elevation: 12,
      margin: const EdgeInsets.all(12),
      shape: Border.all(),
      child: InkWell(
        onTap: onTap,
        child: Column(children: [
          const SizedBox(height: 8),
          Text(otherName, style: context.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Expanded(child: Image.network(otherImage, fit: BoxFit.contain)),
          const SizedBox(height: 16),
        ],),
      ),
    ),
  );
}

class AcceptedConnectionWidget extends StatelessWidget {
  final Connection connection;
  // final VoidCallback onView;
  final VoidCallback onChat;
  const AcceptedConnectionWidget({
    required this.connection,
    required this.onChat,
    // required this.onView,
  });

  String get otherImage => models.user.channilUser!.id == connection.from
    ? connection.toImageUrl : connection.fromImageUrl;

  String get otherName => models.user.channilUser!.id == connection.from
    ? connection.toName : connection.fromName;

  UserID get otherID => models.user.channilUser!.id == connection.from
    ? connection.to : connection.from;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 100, 
    child: Card(
      elevation: 8,
      margin: const EdgeInsets.all(12),
      shape: Border.all(),
      child: InkWell( 
        child: Row(children: [
          const SizedBox(width: 16),
          CircleAvatar(backgroundImage: NetworkImage(otherImage)),
          const SizedBox(width: 16),
          Text(otherName, style: context.textTheme.bodyLarge),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.account_circle), 
            onPressed: () => context.go("/profile/$otherID"),
          ),
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: onChat,
          ),
          const SizedBox(width: 16),
        ],),
      ),
    ),
  );
}

class OutgoingConnectionWidget extends StatelessWidget {
  final Connection connection;
  const OutgoingConnectionWidget(this.connection);

  String get otherImage => models.user.channilUser!.id == connection.from
    ? connection.toImageUrl : connection.fromImageUrl;

  String get otherName => models.user.channilUser!.id == connection.from
    ? connection.toName : connection.fromName;

  UserID get otherID => models.user.channilUser!.id == connection.from
    ? connection.to : connection.from;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 100, 
    child: Card(
      elevation: 8,
      margin: const EdgeInsets.all(12),
      shape: Border.all(),
      child: InkWell( 
        child: Row(children: [
          const SizedBox(width: 16),
          CircleAvatar(backgroundImage: NetworkImage(otherImage)),
          const SizedBox(width: 16),
          Text(otherName, style: context.textTheme.bodyLarge),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.account_circle), 
            onPressed: () => context.go("/profile/$otherID"),
          ),
          const SizedBox(width: 16),
        ],),
      ),
    ),
  );
}
