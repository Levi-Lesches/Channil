import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/pages.dart";
import "package:channil/widgets.dart";
import "package:flutter/material.dart";

class MatchesPage extends ReactiveWidget<MatchesViewModel> {  
  @override
  MatchesViewModel createModel() => MatchesViewModel();

  @override
  Widget build(BuildContext context, MatchesViewModel model) => Scaffold(
    appBar: channilAppBar(
      context: context, 
      title: "My Matches",
      leading: !model.needsConfirmation ? null : IconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: "Cancel",
        onPressed: model.cancel,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: "Refresh",
          onPressed: model.init,
        ),
      ],
    ),
    body: DefaultTabController(
      length: 3,
      child: model.isLoading
      ? const Center(child: CircularProgressIndicator())
      : Column(
        children: [
          if (model.needsConfirmation) Expanded(
            child: ConfirmConnectionPage(model: model, connection: model.toConfirm!),
          ) else ...[
            const TabBar(tabs: [
              Tab(child: Text("Incoming")), 
              Tab(child: Text("Outgoing")), 
              Tab(child: Text("Accepted")),
            ],),
            Expanded(child: TabBarView(children: [
              PendingConnectionsView(model: model, connections: model.incomingConnections),
              OutgoingConnectionsView(model: model, connections: model.outgoingConnections),
              AcceptedConnectionsView(model: model, connections: model.acceptedConnections),
            ],),),
          ],
        ],
      ),
    ),
  );
}

class PendingConnectionsView extends StatelessWidget {
  final Iterable<Connection> connections;
  final MatchesViewModel model;
  const PendingConnectionsView({required this.model, required this.connections});

  @override
  Widget build(BuildContext context) => connections.isEmpty 
    ? Center(child: Text("You have no pending connections", style: context.textTheme.bodyLarge))
    : ListView(
      shrinkWrap: true,
      children: [
        for (final connection in connections)
          PendingConnectionWidget(
            connection: connection, 
            onTap: () => model.confirm(connection),
          ),
      ],
    );
}

class OutgoingConnectionsView extends StatelessWidget {
  final Iterable<Connection> connections;
  final MatchesViewModel model;
  const OutgoingConnectionsView({required this.model, required this.connections});

  @override
  Widget build(BuildContext context) => connections.isEmpty 
    ? Center(child: Text("You have no pending connections", style: context.textTheme.bodyLarge))
    : ListView(
      shrinkWrap: true,
      children: [
        for (final connection in connections)
          OutgoingConnectionWidget(connection),
      ],
    );
}

class AcceptedConnectionsView extends StatelessWidget {
  final Iterable<Connection> connections;
  final MatchesViewModel model;
  const AcceptedConnectionsView({required this.model, required this.connections});

  @override
  Widget build(BuildContext context) => connections.isEmpty 
    ? Center(child: Text("You have no connections\nGo make some!", textAlign: TextAlign.center, style: context.textTheme.bodyLarge,))
    : ListView(
      shrinkWrap: true,
      children: [
        for (final connection in connections)
          AcceptedConnectionWidget(connection),
      ],
  );
}
