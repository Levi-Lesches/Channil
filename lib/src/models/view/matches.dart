import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/pages.dart";
import "package:channil/services.dart";

class MatchesViewModel extends ViewModel {
  late ChannilUser user;
  late List<Connection> allConnections;

  Connection? toConfirm;

  Iterable<Connection> get incomingConnections => allConnections.where(
    (connection) => connection.to == user.id 
      && connection.status == ConnectionStatus.pending,
  );

  Iterable<Connection> get outgoingConnections => allConnections.where(
    (connection) => connection.from == user.id 
      && connection.status == ConnectionStatus.pending,
  );

  Iterable<Connection> get acceptedConnections => allConnections.where(
    (connection) => connection.status == ConnectionStatus.accepted,
  );

  @override
  Future<void> init() async { 
    isLoading = true;
    user = models.user.channilUser!;
    allConnections = await services.database.getConnections(user.id);    
    isLoading = false;
  }

  bool get needsConfirmation => toConfirm != null;
  void confirm(Connection connection) {
    toConfirm = connection;
    notifyListeners();
  }

  Future<void> accept(Connection connection) async {
    connection.status = ConnectionStatus.accepted;
    await services.database.saveConnection(connection);
  }

  Future<void> reject(Connection connection) async {
    connection.status = ConnectionStatus.rejected;
    await services.database.saveConnection(connection);
    toConfirm = null;
    notifyListeners();
  }

  void chatWith(Connection connection) => 
    router.go("/chats/${connection.id}");
}
