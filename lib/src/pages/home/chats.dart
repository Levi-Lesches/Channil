import "package:flutter/material.dart";
import "package:channil/models.dart";
import "package:channil/widgets.dart";

class ChatsPage extends ReactiveWidget<ChatsViewModel> {
  @override
  ChatsViewModel createModel() => ChatsViewModel();

  @override
  Widget build(BuildContext context, ChatsViewModel model) => Scaffold(
    appBar: channilAppBar(context: context, title: "Chats"),
    body: model.isLoading
      ? const Center(child: CircularProgressIndicator()) 
      : model.connections.isEmpty
        ? const Center(child: Text("You don't have any chats. Try making a connection first!"))
        : ListView(
          children: [
            for (final connection in model.connections)
              ListTile(
                title: Text(connection.otherName),
                leading: CircleAvatar(backgroundImage: NetworkImage(connection.otherImage)),
                onTap: () => model.openChat(connection),
              ),
          ],
        ),
  );
}
