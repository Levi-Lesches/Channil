import "package:cloud_firestore/cloud_firestore.dart";

import "package:channil/data.dart";

import "service.dart";

extension <T> on CollectionReference<T> {
  CollectionReference<R> convert<R>({
    required R Function(Json) fromJson,
    required Json Function(R) toJson,
  }) => withConverter(
    fromFirestore: (snapshot, options) => fromJson(snapshot.data()!), 
    toFirestore: (item, options) => toJson(item),
  );

}

extension <T> on Query<T> {
  Future<(DocumentSnapshot<T>?, List<T>)> getAllPaged() async {
    final snapshots = (await get()).docs;
    if (snapshots.isEmpty) return (null, <T>[]);
    return (
      snapshots.last, 
      [
        for (final snapshot in snapshots)
          snapshot.data()!,
      ],
    );
  }

  Future<List<T>> getAll() async => [
    for (final snapshot in (await get()).docs)
      snapshot.data()!,
  ];

  Query<T> safeWhereIn(Object field, List<Object> list) => list.isEmpty ? this : where(field, whereIn: list);
  Query<T> safeContainsAny(Object field, List<Object> list) => list.isEmpty ? this : where(field, arrayContainsAny: list);
  Query<T> safeStartAfterDocument(DocumentSnapshot<T>? snapshot) => snapshot == null ? this : startAfterDocument(snapshot);
}

extension <T> on DocumentReference<T> {
  Future<T?> getData() async => (await get()).data();
}

class DatabaseService extends Service {
  late final firebase = FirebaseFirestore.instance;
  
  @override
  Future<void> init() async { }

  @override
  Future<void> dispose() async { }

  CollectionReference<ChannilUser> get users => firebase.collection("users").convert(
    fromJson: ChannilUser.fromJson,
    toJson: (user) => user.toJson(),
  );

  CollectionReference<Connection> get connections => firebase.collection("connections").convert(
    fromJson: Connection.fromJson,
    toJson: (connection) => connection.toJson(),
  );

  Future<void> saveUser(ChannilUser user) => users.doc(user.id).set(user);
  Future<ChannilUser?> getUser(UserID id) => users.doc(id).getData(); 

  Future<(DocumentSnapshot<ChannilUser>?, List<ChannilUser>)> queryAthletes(BusinessProfile profile, {required DocumentSnapshot<ChannilUser>? startAfter}) => users
    .where(FieldPath(const ["profile", "type"]), isEqualTo: "athlete")
    .safeWhereIn(FieldPath(const ["profile", "sport"]), [
      for (final sport in profile.sports) sport.name,
    ])
    .orderBy("name")
    .limit(3)
    .safeStartAfterDocument(startAfter)
    .getAllPaged();

  Future<(DocumentSnapshot<ChannilUser>?, List<ChannilUser>)> queryBusinesses(AthleteProfile profile, {required DocumentSnapshot<ChannilUser>? startAfter}) => users
    .where(FieldPath(const ["profile", "type"]), isEqualTo: "business")
    .safeContainsAny(FieldPath(const ["profile", "industries"]), [
      for (final industry in profile.dealPreferences) industry.name,
    ],)
    .orderBy("name")
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
}
