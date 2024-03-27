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
          Text(connection.otherName, style: context.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Expanded(child: Image.network(connection.otherImage, fit: BoxFit.contain)),
          const SizedBox(height: 16),
        ],),
      ),
    ),
  );
}

class AcceptedConnectionWidget extends StatelessWidget {
  final Connection connection;
  const AcceptedConnectionWidget(this.connection);

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
          CircleAvatar(backgroundImage: NetworkImage(connection.otherImage)),
          const SizedBox(width: 16),
          Text(connection.otherName, style: context.textTheme.bodyLarge),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.account_circle), 
            onPressed: () => context.push("/profile/${connection.otherID}"),
          ),
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () => context.push("/chats/${connection.id}"),
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
          CircleAvatar(backgroundImage: NetworkImage(connection.otherImage)),
          const SizedBox(width: 16),
          Text(connection.otherName, style: context.textTheme.bodyLarge),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.account_circle), 
            onPressed: () => context.push("/profile/${connection.otherID}"),
          ),
          const SizedBox(width: 16),
        ],),
      ),
    ),
  );
}
