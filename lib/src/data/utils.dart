typedef Json = Map<String, dynamic>;

extension ListUtils<E> on List<E> {
  Iterable<(int, E)> get enumerate sync* {
    for (var i = 0; i < length; i++) {
      yield (i, this[i]);
    }
  }
}

extension StringUtils on String {
  String get extension => Uri.parse(this).pathSegments.last.split(".").last;
}

Iterable<(E1, E2)> zip<E1, E2>(List<E1> list1, List<E2> list2) sync* {
  if (list1.length != list2.length) throw ArgumentError("Trying to zip lists of different lengths");
  for (var index = 0; index < list1.length; index++) {
    yield (list1[index], list2[index]);
  }
}
