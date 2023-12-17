// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iwish_car_eta.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$iwishCarEtaHash() => r'f3cf71b4ba91328493a541b8844e7e32914ccef8';

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

abstract class _$IwishCarEta extends BuildlessAutoDisposeNotifier<String> {
  late final IwishEntity iwish;

  String build(
    IwishEntity iwish,
  );
}

/// See also [_IwishCarEta].
@ProviderFor(_IwishCarEta)
const _iwishCarEtaProvider = _IwishCarEtaFamily();

/// See also [_IwishCarEta].
class _IwishCarEtaFamily extends Family<String> {
  /// See also [_IwishCarEta].
  const _IwishCarEtaFamily();

  /// See also [_IwishCarEta].
  _IwishCarEtaProvider call(
    IwishEntity iwish,
  ) {
    return _IwishCarEtaProvider(
      iwish,
    );
  }

  @override
  _IwishCarEtaProvider getProviderOverride(
    covariant _IwishCarEtaProvider provider,
  ) {
    return call(
      provider.iwish,
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
  String? get name => r'_iwishCarEtaProvider';
}

/// See also [_IwishCarEta].
class _IwishCarEtaProvider
    extends AutoDisposeNotifierProviderImpl<_IwishCarEta, String> {
  /// See also [_IwishCarEta].
  _IwishCarEtaProvider(
    IwishEntity iwish,
  ) : this._internal(
          () => _IwishCarEta()..iwish = iwish,
          from: _iwishCarEtaProvider,
          name: r'_iwishCarEtaProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$iwishCarEtaHash,
          dependencies: _IwishCarEtaFamily._dependencies,
          allTransitiveDependencies:
              _IwishCarEtaFamily._allTransitiveDependencies,
          iwish: iwish,
        );

  _IwishCarEtaProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.iwish,
  }) : super.internal();

  final IwishEntity iwish;

  @override
  String runNotifierBuild(
    covariant _IwishCarEta notifier,
  ) {
    return notifier.build(
      iwish,
    );
  }

  @override
  Override overrideWith(_IwishCarEta Function() create) {
    return ProviderOverride(
      origin: this,
      override: _IwishCarEtaProvider._internal(
        () => create()..iwish = iwish,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        iwish: iwish,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<_IwishCarEta, String> createElement() {
    return _IwishCarEtaProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _IwishCarEtaProvider && other.iwish == iwish;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, iwish.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin _IwishCarEtaRef on AutoDisposeNotifierProviderRef<String> {
  /// The parameter `iwish` of this provider.
  IwishEntity get iwish;
}

class _IwishCarEtaProviderElement
    extends AutoDisposeNotifierProviderElement<_IwishCarEta, String>
    with _IwishCarEtaRef {
  _IwishCarEtaProviderElement(super.provider);

  @override
  IwishEntity get iwish => (origin as _IwishCarEtaProvider).iwish;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
