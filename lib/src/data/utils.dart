typedef Json = Map<String, dynamic>;

extension ListUtils<E> on List<E> {
  Iterable<(int, E)> get enumerate sync* {
    for (var i = 0; i < length; i++) {
      yield (i, this[i]);
    }
  }
}
