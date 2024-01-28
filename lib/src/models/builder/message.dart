import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:flutter/material.dart";

class MessageBuilder extends BuilderModel<Message> {
  final messageController = TextEditingController();
  
  String get message => messageController.text.trim();

  MessageBuilder() {
    messageController.addListener(notifyListeners);
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
  
  @override
  bool get isReady => message.isNotEmpty;

  @override
  Message get value => Message(content: message, timestamp: DateTime.now());
}
