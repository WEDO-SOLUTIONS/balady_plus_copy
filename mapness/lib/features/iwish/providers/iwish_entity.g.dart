// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iwish_entity.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$iwishEntityHash() => r'd7b57c1e97dbc1e257dbd6dda71f5c9fa5608bbc';

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

abstract class _$IwishEntity
    extends BuildlessAutoDisposeAsyncNotifier<IwishEntity> {
  late final String iwishId;

  Future<IwishEntity> build(
    String iwishId,
  );
}

/// See also [_IwishEntity].
@ProviderFor(_IwishEntity)
const _iwishEntityProvider = _IwishEntityFamily();

/// See also [_IwishEntity].
class _IwishEntityFamily extends Family<AsyncValue<IwishEntity>> {
  /// See also [_IwishEntity].
  const _IwishEntityFamily();

  /// See also [_IwishEntity].
  _IwishEntityProvider call(
    String iwishId,
  ) {
    return _IwishEntityProvider(
      iwishId,
    );
  }

  @override
  _IwishEntityProvider getProviderOverride(
    covariant _IwishEntityProvider provider,
  ) {
    return call(
      provider.iwishId,
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
  String? get name => r'_iwishEntityProvider';
}

/// See also [_IwishEntity].
class _IwishEntityProvider
    extends AutoDisposeAsyncNotifierProviderImpl<_IwishEntity, IwishEntity> {
  /// See also [_IwishEntity].
  _IwishEntityProvider(
    String iwishId,
  ) : this._internal(
          () => _IwishEntity()..iwishId = iwishId,
          from: _iwishEntityProvider,
          name: r'_iwishEntityProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$iwishEntityHash,
          dependencies: _IwishEntityFamily._dependencies,
          allTransitiveDependencies:
              _IwishEntityFamily._allTransitiveDependencies,
          iwishId: iwishId,
        );

  _IwishEntityProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.iwishId,
  }) : super.internal();

  final String iwishId;

  @override
  Future<IwishEntity> runNotifierBuild(
    covariant _IwishEntity notifier,
  ) {
    return notifier.build(
      iwishId,
    );
  }

  @override
  Override overrideWith(_IwishEntity Function() create) {
    return ProviderOverride(
      origin: this,
      override: _IwishEntityProvider._internal(
        () => create()..iwishId = iwishId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        iwishId: iwishId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<_IwishEntity, IwishEntity>
      createElement() {
    return _IwishEntityProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _IwishEntityProvider && other.iwishId == iwishId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, iwishId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin _IwishEntityRef on AutoDisposeAsyncNotifierProviderRef<IwishEntity> {
  /// The parameter `iwishId` of this provider.
  String get iwishId;
}

class _IwishEntityProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<_IwishEntity, IwishEntity>
    with _IwishEntityRef {
  _IwishEntityProviderElement(super.provider);

  @override
  String get iwishId => (origin as _IwishEntityProvider).iwishId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
