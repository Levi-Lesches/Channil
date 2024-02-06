import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/pages.dart";
import "package:channil/services.dart";

extension ConnectionUtils on Connection {
  String get otherImage => models.user.channilUser!.id == from
    ? toImageUrl : fromImageUrl;

  String get otherName => models.user.channilUser!.id == from
    ? toName : fromName;

  UserID get otherID => models.user.channilUser!.id == from
    ? toName : fromName;
}

class ChatsViewModel extends ViewModel {
  late List<Connection> connections;

  @override
  Future<void> init() async {
    isLoading = true;
    connections = await services.database.getConnections(models.user.uid!);
    isLoading = false;
  }

  void openChat(Connection connection) => router.go("/chats/${connection.id}");
}
