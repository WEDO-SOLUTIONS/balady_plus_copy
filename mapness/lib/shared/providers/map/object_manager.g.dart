// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mapObjectManagerHash() => r'0f36020daf3dca229c921ad2e306fc90671eaefa';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$MapObjectManager
    extends BuildlessAutoDisposeAsyncNotifier<MapObjectManagerMessage> {
  late final String named;
  late final ClusteringMapObjectManager? clustering;

  Future<MapObjectManagerMessage> build({
    required String named,
    ClusteringMapObjectManager? clustering,
  });
}

/// See also [MapObjectManager].
@ProviderFor(MapObjectManager)
const mapObjectManagerProvider = MapObjectManagerFamily();

/// See also [MapObjectManager].
class MapObjectManagerFamily
    extends Family<AsyncValue<MapObjectManagerMessage>> {
  /// See also [MapObjectManager].
  const MapObjectManagerFamily();

  /// See also [MapObjectManager].
  MapObjectManagerProvider call({
    required String named,
    ClusteringMapObjectManager? clustering,
  }) {
    return MapObjectManagerProvider(
      named: named,
      clustering: clustering,
    );
  }

  @override
  MapObjectManagerProvider getProviderOverride(
    covariant MapObjectManagerProvider provider,
  ) {
    return call(
      named: provider.named,
      clustering: provider.clustering,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'mapObjectManagerProvider';
}

/// See also [MapObjectManager].
class MapObjectManagerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    MapObjectManager, MapObjectManagerMessage> {
  /// See also [MapObjectManager].
  MapObjectManagerProvider({
    required String named,
    ClusteringMapObjectManager? clustering,
  }) : this._internal(
          () => MapObjectManager()
            ..named = named
            ..clustering = clustering,
          from: mapObjectManagerProvider,
          name: r'mapObjectManagerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mapObjectManagerHash,
          dependencies: MapObjectManagerFamily._dependencies,
          allTransitiveDependencies:
              MapObjectManagerFamily._allTransitiveDependencies,
          named: named,
          clustering: clustering,
        );

  MapObjectManagerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.named,
    required this.clustering,
  }) : super.internal();

  final String named;
  final ClusteringMapObjectManager? clustering;

  @override
  Future<MapObjectManagerMessage> runNotifierBuild(
    covariant MapObjectManager notifier,
  ) {
    return notifier.build(
      named: named,
      clustering: clustering,
    );
  }

  @override
  Override overrideWith(MapObjectManager Function() create) {
    return ProviderOverride(
      origin: this,
      override: MapObjectManagerProvider._internal(
        () => create()
          ..named = named
          ..clustering = clustering,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        named: named,
        clustering: clustering,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<MapObjectManager,
      MapObjectManagerMessage> createElement() {
    return _MapObjectManagerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MapObjectManagerProvider &&
        other.named == named &&
        other.clustering == clustering;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, named.hashCode);
    hash = _SystemHash.combine(hash, clustering.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MapObjectManagerRef
    on AutoDisposeAsyncNotifierProviderRef<MapObjectManagerMessage> {
  /// The parameter `named` of this provider.
  String get named;

  /// The parameter `clustering` of this provider.
  ClusteringMapObjectManager? get clustering;
}

class _MapObjectManagerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MapObjectManager,
        MapObjectManagerMessage> with MapObjectManagerRef {
  _MapObjectManagerProviderElement(super.provider);

  @override
  String get named => (origin as MapObjectManagerProvider).named;
  @override
  ClusteringMapObjectManager? get clustering =>
      (origin as MapObjectManagerProvider).clustering;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
