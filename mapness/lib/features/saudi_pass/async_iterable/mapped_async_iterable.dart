import 'package:mapness/features/saudi_pass/async_iterable/async_iterable.dart';

/// This implementation maps decorated AsyncIterable<T> to AsyncIterable<O>
/// [transformation] function used to map T type to O type
class MappedAsyncIterable<I, O> implements AsyncIterable<O> {
  final AsyncIterable<I> decorated;
  final O Function(I) transformation;

  MappedAsyncIterable({
    required this.decorated,
    required this.transformation,
  });

  final map = <int, O>{};

  @override
  O elementAt(int index) => map.putIfAbsent(index, () => transformation(decorated.elementAt(index)));

  @override
  Future<bool> hasElement(int index) => decorated.hasElement(index);

  @override
  int get length => decorated.length;

  @override
  int? get maxIndex => decorated.maxIndex;

  @override
  bool get isEmpty => decorated.isEmpty;
}
