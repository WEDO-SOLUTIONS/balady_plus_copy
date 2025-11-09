import 'dart:async';

import 'package:mapness/features/saudi_pass/async_iterable/chunked_async_iterable.dart';

import 'async_iterable.dart';

/// This implementation flattens chunked iterable
/// [0,1,2,3,4,5,6,7,8,9]     Some iterable
/// [[0,1,2,3,4],[5,6,7,8,9]] Chunked iterable
/// [0,1,2,3,4,5,6,7,8,9]     Flat iterable
class FlatChunkedAsyncIterable<T> implements AsyncIterable<T> {
  final AsyncIterable<Chunk<T>> chunkedAsyncIterable;

  FlatChunkedAsyncIterable(this.chunkedAsyncIterable, this.chunkSize);

  final int chunkSize;

  @override
  int length = 0;

  @override
  int? maxIndex;

  @override
  T elementAt(int index) {
    final chunk = chunkedAsyncIterable.elementAt(chunkIndexForIndex(index, chunkSize));

    return chunk.elementAt(indexRelatedToChunk(index, chunkSize));
  }

  @override
  Future<bool> hasElement(int index) async {
    final chunkIndex = chunkIndexForIndex(index, chunkSize);

    final hasChunk = await chunkedAsyncIterable.hasElement(chunkIndex);

    if (!hasChunk) {
      return false;
    }

    final chunk = chunkedAsyncIterable.elementAt(chunkIndex);

    length = chunk.totalItems;

    final maxIndex = this.maxIndex = length - 1;

    return index <= maxIndex;
  }

  @override
  bool get isEmpty => chunkedAsyncIterable.isEmpty;
}
