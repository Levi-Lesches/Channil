import "dart:async";

import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/services.dart";

extension MessageUtils on Message {
  bool get isFromSelf => models.user.uid == author;
}

class ChatViewModel extends ViewModel {
  final String id;
  final controller = TextEditingController();
  ChatViewModel(this.id);
  
  late Connection connection;
  late final StreamSubscription<Connection?> _subscription;

  @override
  Future<void> init() async {
    isLoading = true;
    connection = (await services.database.getConnection(id))!;
    isLoading = false;
    _subscription = services.database.listenToConnection(id).listen(_onUpdate);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _onUpdate(Connection? data) {
    if (data == null) return;
    connection = data;
    notifyListeners();
  }

  Iterable<Message> get messages => connection.messages.reversed;

  bool get hasValidMessage => controller.text.trim().isNotEmpty;

  Future<void> send() async {
    final message = Message(
      author: models.user.uid!,
      content: controller.text.trim(), 
      timestamp: DateTime.now(),
    );
    connection.messages.add(message);
    await services.database.saveConnection(connection);
    controller.clear();
  }
}
