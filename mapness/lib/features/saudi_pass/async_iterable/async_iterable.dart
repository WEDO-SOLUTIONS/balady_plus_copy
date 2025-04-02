/// Interface for async query iterable items
/// First ask if it [hasElement]
/// Then query by [elementAt]
abstract class AsyncIterable<T> {
  int get length;

  bool get isEmpty;

  int? get maxIndex;

  T elementAt(int index);

  Future<bool> hasElement(int index);
}
