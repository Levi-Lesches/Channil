import "package:meta/meta.dart";

import "package:cloud_firestore/cloud_firestore.dart";

import "package:channil/data.dart";

extension CollectionUtils<T> on CollectionReference<T> {
  Collection<R, I> convert<R, I>({
    required R Function(Json) fromJson,
    required Json Function(R) toJson,
  }) => withConverter(
    fromFirestore: (snapshot, options) => fromJson(snapshot.data()!), 
    toFirestore: (item, options) => toJson(item),
  ) as Collection<R, I>;
}

/// A safe view over [CollectionReference] that only allows the correct ID type.
extension type Collection<T, I>(CollectionReference<T> collection) implements CollectionReference<T> {
  /// Checks whether a document ID exists in this collection.
  Future<bool> contains(I id) async => (await doc(id).get()).exists;

  /// Gets the document with the given ID, or a new ID if needed.
  @redeclare
  DocumentReference<T> doc([I? path]) => collection.doc(path as String?);

  /// Gets a new ID for this collection.
  I get newID => doc().id as I;
}

extension QueryUtils<T> on Query<T> {
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

extension DocumentUtils<T> on DocumentReference<T> {
  Future<T?> getData() async => (await get()).data();
}
