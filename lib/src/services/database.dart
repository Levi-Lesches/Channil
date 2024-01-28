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
  Future<List<T>> getAll() async =>  [
    for (final snapshot in (await get()).docs)
      snapshot.data()!,
  ];

  Query<T> safeWhereIn(Object field, List<Object> list) => list.isEmpty ? this : where(field, whereIn: list);
  Query<T> safeWhereNotIn(Object field, List<Object> list) => list.isEmpty ? this : where(field, whereNotIn: list);
  Query<T> safeContainsAny(Object field, List<Object> list) => list.isEmpty ? this : where(field, arrayContainsAny: list);
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

  Future<void> saveUser(ChannilUser user) => users.doc(user.id).set(user);
  Future<ChannilUser?> getUser(UserID id) => users.doc(id).getData(); 

  Future<List<ChannilUser>> queryAthletes(BusinessProfile profile, {required List<UserID> rejectedIDs}) => users
    .where(FieldPath(const ["profile", "type"]), isEqualTo: "athlete")
    .safeWhereIn(FieldPath(const ["profile", "sport"]), [
      for (final sport in profile.sports) sport.name,
    ])
    .safeWhereNotIn(FieldPath(const ["id"]), rejectedIDs)
    .limit(3)
    .getAll();

  Future<List<ChannilUser>> queryBusinesses(AthleteProfile profile, {required List<UserID> rejectedIDs}) => users
    .where(FieldPath(const ["profile", "type"]), isEqualTo: "business")
    .safeContainsAny(FieldPath(const ["profile", "industries"]), [
      for (final industry in profile.dealPreferences) industry.name,
    ],)
    .safeWhereNotIn(FieldPath(const ["id"]), rejectedIDs)
    .limit(3)
    .getAll();
}
