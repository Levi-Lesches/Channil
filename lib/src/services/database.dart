import "package:cloud_firestore/cloud_firestore.dart";

import "package:channil/data.dart";

import "service.dart";

extension on CollectionReference {
  CollectionReference<T> convert<T>({
    required T Function(Json) fromJson,
    required Json Function(T) toJson,
  }) => withConverter(
    fromFirestore: (snapshot, options) => fromJson(snapshot.data()!), 
    toFirestore: (item, options) => toJson(item),
  );
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
}
