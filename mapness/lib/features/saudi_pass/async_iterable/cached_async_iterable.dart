import 'package:async/async.dart';
import 'package:mapness/features/saudi_pass/async_iterable/async_iterable.dart';

///This implementation caches queries to decorated [AsyncIterable]
class CachedAsyncIterable<T> implements AsyncIterable<T> {
  final AsyncIterable<T> decorated;

  CachedAsyncIterable(this.decorated);

  final elements = <int, T>{};
  final hasElements = <int, ResultFuture<bool>>{};

  @override
  T elementAt(int index) => elements.putIfAbsent(index, () => decorated.elementAt(index));

  @override
  Future<bool> hasElement(int index) {
    ResultFuture<bool> getNew() => ResultFuture(decorated.hasElement(index));
    return hasElements.update(
      index,
      (resultFuture) => resultFuture.result?.isError ?? false ? getNew() : resultFuture,
      ifAbsent: getNew,
    );
  }

  @override
  int get length => decorated.length;

  @override
  int? get maxIndex => decorated.maxIndex;

  @override
  bool get isEmpty => decorated.isEmpty;
}
