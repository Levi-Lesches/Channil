import "dart:math";

import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/widgets.dart";
import "package:flutter/material.dart";

class ConfirmationModel extends ViewModel {
  final Connection connection;
  final MatchesViewModel model;
  ConfirmationModel({required this.model, required this.connection});

  ConnectionStatus get status => connection.status;

  Future<void> accept() async {
    await model.accept(connection);
    notifyListeners();
  }

  Future<void> reject() => model.reject(connection);

  void chat() => model.chatWith(connection);
}

class ConfirmConnectionPage extends ReactiveWidget<ConfirmationModel> {
  final Connection connection;
  final MatchesViewModel model;
  const ConfirmConnectionPage({required this.model, required this.connection});
  
  @override
  ConfirmationModel createModel() => ConfirmationModel(model: model, connection: connection);

  @override
  Widget build(BuildContext context, ConfirmationModel model) => Stack(
    children: [
      Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          Text("From: ${connection.fromName}", style: context.textTheme.titleLarge),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity, 
            child: InfoBox(
              children: [
                Text(connection.messages.first.content, style: context.textTheme.headlineSmall),
              ],
            ),
          ),
          const SizedBox(height: 72),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 250), 
            opacity: model.status == ConnectionStatus.accepted ? 1 : 0,
            child: Text("Connected!", style: context.textTheme.headlineLarge),
          ),
        ],),
      ),
      if (model.status != ConnectionStatus.accepted) rejectButton(onPressed: model.reject),
      if (model.status != ConnectionStatus.accepted) acceptButton(onPressed: model.accept),
      AnimatedPositioned(
        left: model.status == ConnectionStatus.accepted
          ? 50
          : -350,
        bottom: 200,
        duration: const Duration(milliseconds: 250),
        child: SizedBox(
          height: 150, 
          width: 150, 
          child: Transform.rotate(
            angle: -pi/10,
            child: Column(children: [
              Text(connection.fromName),
              const SizedBox(height: 8),
              Material(
                shape: Border.all(),
                elevation: 16,
                child: Image.network(connection.fromImageUrl),
              ),
            ],),
          ),
        ),
      ),
      AnimatedPositioned(
        right: model.status == ConnectionStatus.accepted
          ? 50
          : -350,
        bottom: 200,
        duration: const Duration(milliseconds: 250),
        child: SizedBox(
          height: 150, 
          width: 150, 
          child: Transform.rotate(
            angle: pi/10,
            child: Column(children: [
              Text(connection.toName),
              const SizedBox(height: 8),
              Material(
                shape: Border.all(),
                elevation: 16,
                child: Image.network(connection.toImageUrl),
              ),
            ],),
          ),
        ),
      ),
      AnimatedAlign(
        alignment: model.status == ConnectionStatus.accepted 
          ? const Alignment(0, 0.85) : const Alignment(0, 2),
        duration: const Duration(milliseconds: 250),
        child: OutlinedButton(
          onPressed: model.chat,
          child: const Text("Chat"),
        ),
      ),
    ],
  );
}
