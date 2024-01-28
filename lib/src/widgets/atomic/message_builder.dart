import "package:channil/models.dart";
import "package:channil/widgets.dart";
import "package:flutter/material.dart";

class MessageEditor extends ReactiveWidget<MessageBuilder> {
  final String title;
  const MessageEditor({required this.title});
  
  @override
  MessageBuilder createModel() => MessageBuilder();

  @override
  Widget build(BuildContext context, MessageBuilder model) => AlertDialog(
    title: Text(title),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ChannilTextField(
          maxLines: null,
          controller: model.messageController,
          action: TextInputAction.newline,
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => context.pop(),
        child: const Text("Cancel"), 
      ),
      ElevatedButton(
        onPressed: model.isReady ? () => context.pop(model.value) : null,
        child: const Text("Send"),
      ),
    ],
  );
}
