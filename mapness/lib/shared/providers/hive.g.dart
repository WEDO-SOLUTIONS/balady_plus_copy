// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hiveHash() => r'51da5768c4149ea75358539b06061ef8fba84981';

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

abstract class _$Hive extends BuildlessAsyncNotifier<Box<dynamic>> {
  late final String boxName;

  Future<Box<dynamic>> build(
    String boxName,
  );
}

/// See also [_Hive].
@ProviderFor(_Hive)
const _hiveProvider = _HiveFamily();

/// See also [_Hive].
class _HiveFamily extends Family<AsyncValue<Box<dynamic>>> {
  /// See also [_Hive].
  const _HiveFamily();

  /// See also [_Hive].
  _HiveProvider call(
    String boxName,
  ) {
    return _HiveProvider(
      boxName,
    );
  }

  @override
  _HiveProvider getProviderOverride(
    covariant _HiveProvider provider,
  ) {
    return call(
      provider.boxName,
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
  String? get name => r'_hiveProvider';
}

/// See also [_Hive].
class _HiveProvider extends AsyncNotifierProviderImpl<_Hive, Box<dynamic>> {
  /// See also [_Hive].
  _HiveProvider(
    String boxName,
  ) : this._internal(
          () => _Hive()..boxName = boxName,
          from: _hiveProvider,
          name: r'_hiveProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$hiveHash,
          dependencies: _HiveFamily._dependencies,
          allTransitiveDependencies: _HiveFamily._allTransitiveDependencies,
          boxName: boxName,
        );

  _HiveProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.boxName,
  }) : super.internal();

  final String boxName;

  @override
  Future<Box<dynamic>> runNotifierBuild(
    covariant _Hive notifier,
  ) {
    return notifier.build(
      boxName,
    );
  }

  @override
  Override overrideWith(_Hive Function() create) {
    return ProviderOverride(
      origin: this,
      override: _HiveProvider._internal(
        () => create()..boxName = boxName,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        boxName: boxName,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<_Hive, Box<dynamic>> createElement() {
    return _HiveProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _HiveProvider && other.boxName == boxName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, boxName.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin _HiveRef on AsyncNotifierProviderRef<Box<dynamic>> {
  /// The parameter `boxName` of this provider.
  String get boxName;
}

class _HiveProviderElement
    extends AsyncNotifierProviderElement<_Hive, Box<dynamic>> with _HiveRef {
  _HiveProviderElement(super.provider);

  @override
  String get boxName => (origin as _HiveProvider).boxName;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
