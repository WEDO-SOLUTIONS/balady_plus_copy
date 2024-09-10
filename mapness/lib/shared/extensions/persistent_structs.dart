import 'dart:collection';

class PSet<T> extends UnmodifiableSetView<T> {
  PSet(Set<T> source) : super(source);

  static PSet<T> empty<T>() => PSet({});

  PSet<T> toPersistent() => PSet(this);
}

class PMap<K, V> extends UnmodifiableMapView<K, V> {
  PMap(Map<K, V> source) : super(source);

  static PMap<K, V> empty<K, V>() => PMap({});

  PMap<K, V> toPersistent() => PMap(this);
}

extension PMapExt<K, V> on Map<K, V> {
  PMap<K, V> toPersistent() => PMap(this);
}

class PList<T> extends UnmodifiableListView<T> {
  PList(List<T> source) : super(source);

  static PList<T> empty<T>() => PList([]);

  PList<T> toPersistent() => PList(this);
}

extension PListExt<T> on List<T> {
  PList<T> toPersistent() => PList(this);
}
