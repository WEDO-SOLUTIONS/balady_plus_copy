import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:mapness/features/saudi_pass/async_iterable/async_iterable.dart';
import 'package:mapness/features/saudi_pass/async_iterable/chunked_async_iterable.dart';

/// This implementation is client of AsyncIterable to be used with ListView, SliverList, etc
/// Asks forward [moreItems] and notifies on length updates
class AsyncIterableListingNotifier<T> extends ChangeNotifier implements AsyncIterable<T> {
  final AsyncIterable<T> decorated;

  final int moreItems;

  AsyncIterableListingNotifier(this.decorated, {this.moreItems = 1});

  int uxPageSize = 20;

  final pageIndexes = <int>{};

  bool isPageStart(int index) => index % uxPageSize == 0;

  @override
  int get length {
    if (pageIndexes.isEmpty) {
      return moreItems;
    }

    final page = pageIndexes.fold(0, max) + 1;

    final pagedLength = uxPageSize * page;

    if (pagedLength < decorated.length) {
      return pagedLength + moreItems;
    }

    return decorated.length;
  }

  @override
  int? get maxIndex => decorated.maxIndex;

  @override
  T elementAt(int index) => decorated.elementAt(index);

  @override
  Future<bool> hasElement(int index) async {
    final result = await decorated.hasElement(index);

    final pageIndex = chunkIndexForIndex(index, uxPageSize);

    if (isPageStart(index) && !pageIndexes.contains(pageIndex)) {
      pageIndexes.add(pageIndex);

      notifyListeners();
    }

    return result;
  }

  @override
  bool get isEmpty => decorated.isEmpty;
}
