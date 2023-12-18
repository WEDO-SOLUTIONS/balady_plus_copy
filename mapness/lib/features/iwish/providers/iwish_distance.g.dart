// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iwish_distance.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$iwishDistanceHash() => r'06b34a850a2dcce419569576c41315f29c65b72d';

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

abstract class _$IwishDistance extends BuildlessAutoDisposeNotifier<String> {
  late final IwishEntity entity;

  String build(
    IwishEntity entity,
  );
}

/// See also [_IwishDistance].
@ProviderFor(_IwishDistance)
const _iwishDistanceProvider = _IwishDistanceFamily();

/// See also [_IwishDistance].
class _IwishDistanceFamily extends Family<String> {
  /// See also [_IwishDistance].
  const _IwishDistanceFamily();

  /// See also [_IwishDistance].
  _IwishDistanceProvider call(
    IwishEntity entity,
  ) {
    return _IwishDistanceProvider(
      entity,
    );
  }

  @override
  _IwishDistanceProvider getProviderOverride(
    covariant _IwishDistanceProvider provider,
  ) {
    return call(
      provider.entity,
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
  String? get name => r'_iwishDistanceProvider';
}

/// See also [_IwishDistance].
class _IwishDistanceProvider
    extends AutoDisposeNotifierProviderImpl<_IwishDistance, String> {
  /// See also [_IwishDistance].
  _IwishDistanceProvider(
    IwishEntity entity,
  ) : this._internal(
          () => _IwishDistance()..entity = entity,
          from: _iwishDistanceProvider,
          name: r'_iwishDistanceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$iwishDistanceHash,
          dependencies: _IwishDistanceFamily._dependencies,
          allTransitiveDependencies:
              _IwishDistanceFamily._allTransitiveDependencies,
          entity: entity,
        );

  _IwishDistanceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.entity,
  }) : super.internal();

  final IwishEntity entity;

  @override
  String runNotifierBuild(
    covariant _IwishDistance notifier,
  ) {
    return notifier.build(
      entity,
    );
  }

  @override
  Override overrideWith(_IwishDistance Function() create) {
    return ProviderOverride(
      origin: this,
      override: _IwishDistanceProvider._internal(
        () => create()..entity = entity,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        entity: entity,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<_IwishDistance, String> createElement() {
    return _IwishDistanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _IwishDistanceProvider && other.entity == entity;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, entity.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin _IwishDistanceRef on AutoDisposeNotifierProviderRef<String> {
  /// The parameter `entity` of this provider.
  IwishEntity get entity;
}

class _IwishDistanceProviderElement
    extends AutoDisposeNotifierProviderElement<_IwishDistance, String>
    with _IwishDistanceRef {
  _IwishDistanceProviderElement(super.provider);

  @override
  IwishEntity get entity => (origin as _IwishDistanceProvider).entity;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
