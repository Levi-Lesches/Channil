import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/widgets.dart";
import "package:flutter/material.dart";

final class MessageWidget extends StatelessWidget {
  final Message message;
  final Connection connection;
  final Message? prevMessage;
  const MessageWidget({required this.message, required this.connection, required this.prevMessage});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity, 
    // height: 72,
    child: Row(children: [
      if (!message.isFromSelf && (prevMessage == null || prevMessage!.isFromSelf)) ...[
        const SizedBox(width: 12),
        CircleAvatar(backgroundImage: NetworkImage(connection.otherImage), radius: 24),
      ] else const SizedBox(width: 36),
      Flexible(child: Align(
        alignment: message.isFromSelf ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          child: Text(message.content),
        ),
      ),),
      if (!message.isFromSelf) const SizedBox(width: 36),
    ],),
  );
}

class ChatPage extends ReactiveWidget<ChatViewModel> {
  final ConnectionID id;
  const ChatPage(this.id);
  
  @override
  ChatViewModel createModel() => ChatViewModel(id);

  @override
  Widget build(BuildContext context, ChatViewModel model) => Scaffold(
    appBar: AppBar(
      title: TextButton(
        onPressed: model.isLoading ? null : () => context.push("/profile/${model.connection.otherID}"),
        child: Text(model.isLoading ? "Loading..." : model.connection.otherName),
      ),
    ),
    body: model.isLoading
      ? const Center(child: CircularProgressIndicator())
      : Column(
        children: [
          Expanded(child: ListView(
            reverse: true,
            children: [
              for (final message in model.messages)
                MessageWidget(message: message, connection: model.connection, prevMessage: null),
            ],
          ),),
          Container(
            height: 100, 
            padding: const EdgeInsets.all(8),
            color: context.colorScheme.surface,
            child: Row(children: [
              Expanded(child: ChannilTextField(
                controller: model.controller,
                hint: "Type your message...",
                action: TextInputAction.send,
                onEditingComplete: model.send,
              ),),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: model.send,
              ),
            ],),
          ),
        ],
      ),
  );
}
