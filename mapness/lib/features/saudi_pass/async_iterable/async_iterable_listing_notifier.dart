import 'package:flutter/foundation.dart';
import 'package:mapness/features/saudi_pass/async_iterable/async_iterable.dart';

class AsyncIterableListingNotifier<T> extends ChangeNotifier implements AsyncIterable<T> {
  final AsyncIterable<T> decorated;

  final int moreItems;

  AsyncIterableListingNotifier(this.decorated, {this.moreItems = 1});

  @override
  int get length => decorated.length + more;

  int get more {
    if (isEmpty) {
      return 0;
    }
    if (maxIndex != null) {
      return 0;
    }
    return moreItems;
  }

  @override
  int? get maxIndex => decorated.maxIndex;

  @override
  T elementAt(int index) => decorated.elementAt(index);

  @override
  Future<bool> hasElement(int index) async {
    final shouldUpdate = index >= decorated.length;

    final result = await decorated.hasElement(index);

    if (shouldUpdate) {
      notifyListeners();
    }

    return result;
  }

  @override
  bool get isEmpty => decorated.isEmpty;
}
