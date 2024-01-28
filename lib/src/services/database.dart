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

  Future<List<ChannilUser>> queryAthletes(BusinessProfile profile) => users
    .where(FieldPath(const ["profile", "type"]), isEqualTo: "profile")
    .where(FieldPath(const ["profile", "sport"]), whereIn: [
      for (final sport in profile.sports) sport.name,
    ],)
    .limit(10)
    .getAll();

  Future<List<ChannilUser>> queryBusinesses(AthleteProfile profile) => users
    .where(FieldPath(const ["profile", "type"]), isEqualTo: "profile")
    .where(FieldPath(const ["profile", "industries"]), arrayContainsAny: [
      for (final industry in profile.dealPreferences) industry.name,
    ],)
    .limit(10)
    .getAll();
}
