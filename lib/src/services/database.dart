import "package:cloud_firestore/cloud_firestore.dart";

import "package:channil/data.dart";

import "firestore.dart";
import "service.dart";

class DatabaseService extends Service {
  late final firebase = FirebaseFirestore.instance;
  
  @override
  Future<void> init() async { }

  @override
  Future<void> dispose() async { }

  Collection<ChannilUser, UserID> get users => firebase.collection("users").convert(
    fromJson: ChannilUser.fromJson,
    toJson: (user) => user.toJson(),
  );

  Collection<Connection, ConnectionID> get connections => firebase.collection("connections").convert(
    fromJson: Connection.fromJson,
    toJson: (connection) => connection.toJson(),
  );

  Future<void> saveUser(ChannilUser user) => users.doc(user.id).set(user);
  Future<ChannilUser?> getUser(UserID id) => users.doc(id).getData(); 

  Future<(DocumentSnapshot<ChannilUser>?, List<ChannilUser>)> queryAthletes(BusinessProfile profile, {required DocumentSnapshot<ChannilUser>? startAfter}) => users
    .where("isHidden", isEqualTo:  false)
    .where(FieldPath(const ["profile", "type"]), isEqualTo: "athlete")
    .safeWhereIn(FieldPath(const ["profile", "sport"]), [
      for (final sport in profile.sports) sport.name,
    ])
    .orderBy("id")
    .limit(3)
    .safeStartAfterDocument(startAfter)
    .getAllPaged();

  Future<(DocumentSnapshot<ChannilUser>?, List<ChannilUser>)> queryBusinesses(AthleteProfile profile, {required DocumentSnapshot<ChannilUser>? startAfter}) => users
    .where("isHidden", isEqualTo:  false)
    .where(FieldPath(const ["profile", "type"]), isEqualTo: "business")
    .safeContainsAny(FieldPath(const ["profile", "industries"]), [
      for (final industry in profile.dealPreferences) industry.name,
    ],)
    .orderBy("id")
    .limit(3)
    .safeStartAfterDocument(startAfter)
    .getAllPaged();

  Future<List<Connection>> getConnections(UserID user) => connections
    .where("between", arrayContains: user)
    .getAll();

  Future<Connection?> getConnection(ConnectionID id) => connections
    .doc(id).getData();

  Future<void> saveConnection(Connection connection) => connections
    .doc(connection.id).set(connection);

  Stream<Connection?> listenToConnection(ConnectionID id) => connections
    .doc(id).snapshots().map((event) => event.data());

  Future<void> deleteConnection(Connection connection) => 
    connections.doc(connection.id).delete();

  Future<void> deleteAccount(UserID id) async {
    await users.doc(id).delete();
    for (final connection in await getConnections(id)) {
      await deleteConnection(connection);
    }
  }
}
