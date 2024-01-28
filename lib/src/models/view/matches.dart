import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/services.dart";

class MatchesViewModel extends ViewModel {
  late ChannilUser user;
  List<Connection> get allConnections => home.connections;
  Connection? toConfirm;

  final HomeModel home;
  MatchesViewModel(this.home);

  Iterable<Connection> get pendingConnections => allConnections.where(
    (connection) => connection.to == user.id 
      && connection.status == ConnectionStatus.pending,
  );

  Iterable<Connection> get acceptedConnections => allConnections.where(
    (connection) => connection.status == ConnectionStatus.accepted,
  );

  @override
  Future<void> init() async { 
    isLoading = true;
    user = models.user.channilUser!;
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

  void chatWith(Connection connection) => 
    home.updatePageIndex(2);
}
