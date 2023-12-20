// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poi_card_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$poiCardProviderHash() => r'4a2db7df75082244264e500b7248732e4c13d13c';

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

abstract class _$PoiCardProvider
    extends BuildlessAutoDisposeAsyncNotifier<PoiCardState?> {
  late final DgisObjectIdMessage objectId;

  Future<PoiCardState?> build(
    DgisObjectIdMessage objectId,
  );
}

/// See also [PoiCardProvider].
@ProviderFor(PoiCardProvider)
const poiCardProviderProvider = PoiCardProviderFamily();

/// See also [PoiCardProvider].
class PoiCardProviderFamily extends Family<AsyncValue<PoiCardState?>> {
  /// See also [PoiCardProvider].
  const PoiCardProviderFamily();

  /// See also [PoiCardProvider].
  PoiCardProviderProvider call(
    DgisObjectIdMessage objectId,
  ) {
    return PoiCardProviderProvider(
      objectId,
    );
  }

  @override
  PoiCardProviderProvider getProviderOverride(
    covariant PoiCardProviderProvider provider,
  ) {
    return call(
      provider.objectId,
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
  String? get name => r'poiCardProviderProvider';
}

/// See also [PoiCardProvider].
class PoiCardProviderProvider extends AutoDisposeAsyncNotifierProviderImpl<
    PoiCardProvider, PoiCardState?> {
  /// See also [PoiCardProvider].
  PoiCardProviderProvider(
    DgisObjectIdMessage objectId,
  ) : this._internal(
          () => PoiCardProvider()..objectId = objectId,
          from: poiCardProviderProvider,
          name: r'poiCardProviderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$poiCardProviderHash,
          dependencies: PoiCardProviderFamily._dependencies,
          allTransitiveDependencies:
              PoiCardProviderFamily._allTransitiveDependencies,
          objectId: objectId,
        );

  PoiCardProviderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.objectId,
  }) : super.internal();

  final DgisObjectIdMessage objectId;

  @override
  Future<PoiCardState?> runNotifierBuild(
    covariant PoiCardProvider notifier,
  ) {
    return notifier.build(
      objectId,
    );
  }

  @override
  Override overrideWith(PoiCardProvider Function() create) {
    return ProviderOverride(
      origin: this,
      override: PoiCardProviderProvider._internal(
        () => create()..objectId = objectId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        objectId: objectId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<PoiCardProvider, PoiCardState?>
      createElement() {
    return _PoiCardProviderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PoiCardProviderProvider && other.objectId == objectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, objectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PoiCardProviderRef on AutoDisposeAsyncNotifierProviderRef<PoiCardState?> {
  /// The parameter `objectId` of this provider.
  DgisObjectIdMessage get objectId;
}

class _PoiCardProviderProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<PoiCardProvider,
        PoiCardState?> with PoiCardProviderRef {
  _PoiCardProviderProviderElement(super.provider);

  @override
  DgisObjectIdMessage get objectId =>
      (origin as PoiCardProviderProvider).objectId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
