// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iwish_address.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$iwishAddressHash() => r'641e68df541ebc85de6925ba6645bdb3cb370801';

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

abstract class _$IwishAddress extends BuildlessAutoDisposeNotifier<String> {
  late final IwishEntity iwish;

  String build(
    IwishEntity iwish,
  );
}

/// See also [_IwishAddress].
@ProviderFor(_IwishAddress)
const _iwishAddressProvider = _IwishAddressFamily();

/// See also [_IwishAddress].
class _IwishAddressFamily extends Family<String> {
  /// See also [_IwishAddress].
  const _IwishAddressFamily();

  /// See also [_IwishAddress].
  _IwishAddressProvider call(
    IwishEntity iwish,
  ) {
    return _IwishAddressProvider(
      iwish,
    );
  }

  @override
  _IwishAddressProvider getProviderOverride(
    covariant _IwishAddressProvider provider,
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
  String? get name => r'_iwishAddressProvider';
}

/// See also [_IwishAddress].
class _IwishAddressProvider
    extends AutoDisposeNotifierProviderImpl<_IwishAddress, String> {
  /// See also [_IwishAddress].
  _IwishAddressProvider(
    IwishEntity iwish,
  ) : this._internal(
          () => _IwishAddress()..iwish = iwish,
          from: _iwishAddressProvider,
          name: r'_iwishAddressProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$iwishAddressHash,
          dependencies: _IwishAddressFamily._dependencies,
          allTransitiveDependencies:
              _IwishAddressFamily._allTransitiveDependencies,
          iwish: iwish,
        );

  _IwishAddressProvider._internal(
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
    covariant _IwishAddress notifier,
  ) {
    return notifier.build(
      iwish,
    );
  }

  @override
  Override overrideWith(_IwishAddress Function() create) {
    return ProviderOverride(
      origin: this,
      override: _IwishAddressProvider._internal(
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
  AutoDisposeNotifierProviderElement<_IwishAddress, String> createElement() {
    return _IwishAddressProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _IwishAddressProvider && other.iwish == iwish;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, iwish.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin _IwishAddressRef on AutoDisposeNotifierProviderRef<String> {
  /// The parameter `iwish` of this provider.
  IwishEntity get iwish;
}

class _IwishAddressProviderElement
    extends AutoDisposeNotifierProviderElement<_IwishAddress, String>
    with _IwishAddressRef {
  _IwishAddressProviderElement(super.provider);

  @override
  IwishEntity get iwish => (origin as _IwishAddressProvider).iwish;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
