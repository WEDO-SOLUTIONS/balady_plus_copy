import 'package:mapness/features/saudi_pass/async_iterable/async_iterable.dart';

abstract class ChunkedAsyncIterable<T> implements AsyncIterable<Chunk<T>> {
  int get chunkSize;

  final _chunks = <int, Chunk<T>>{};

  Future<Chunk<T>> getChunk(int chunkIndex);

  @override
  Chunk<T> elementAt(int index) =>
      _chunks.remove(index) ?? (throw Exception('Before need to await True from hasElement($index)'));

  @override
  Future<bool> hasElement(int index) async {
    final chunk = await getChunk(index);

    length = chunk.totalChunks;

    final maxIndex = this.maxIndex = length - 1;

    _chunks.update(index, (oldPage) => chunk, ifAbsent: () => chunk);

    return index <= maxIndex;
  }

  @override
  int length = 0;

  @override
  int? maxIndex;

  @override
  bool get isEmpty => maxIndex != null && length == 0;
}

/// All indexes start from 0
int chunkIndexForIndex(int index, int pageSize) => index ~/ pageSize;

int indexRelatedToChunk(int index, int pageSize) => index % pageSize;

abstract class Chunk<T> extends Iterable<T> {
  int get totalChunks;

  int get totalItems;
}
