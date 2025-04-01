abstract class AsyncIterable<T> {
  int get length;

  bool get isEmpty;

  int? get maxIndex;

  T elementAt(int index);

  Future<bool> hasElement(int index);
}
