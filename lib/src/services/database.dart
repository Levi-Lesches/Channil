import "package:cloud_firestore/cloud_firestore.dart";

import "package:channil/data.dart";

import "service.dart";

class DatabaseService extends Service {
  late final firebase = FirebaseFirestore.instance;
  
  @override
  Future<void> init() async { }

  @override
  Future<void> dispose() async { }

  CollectionReference<Athlete> get athletes => firebase.collection("athletes").withConverter(
    fromFirestore: (snapshot, options) => Athlete.fromJson(snapshot.data()!),
    toFirestore: (athlete, options) => athlete.toJson(),
  );

  CollectionReference<Business> get businesses => firebase.collection("businesses").withConverter(
    fromFirestore: (snapshot, options) => Business.fromJson(snapshot.data()!),
    toFirestore: (business, options) => business.toJson(),
  );

  Future<void> saveBusiness(Business business) async {
    final doc = businesses.doc(business.id);
    await doc.set(business);
  }

  Future<void> saveAthlete(Athlete athlete) async {
    final doc = athletes.doc(athlete.id);
    await doc.set(athlete);
  }
}
