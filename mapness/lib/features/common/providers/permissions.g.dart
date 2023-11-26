// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permissions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$permissionsHash() => r'1fea30c27fef86be230dfc7a62a6d7f5dc308533';

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

abstract class _$Permissions
    extends BuildlessAutoDisposeAsyncNotifier<PermissionStatus> {
  late final Permission permission;

  Future<PermissionStatus> build(
    Permission permission,
  );
}

/// See also [Permissions].
@ProviderFor(Permissions)
const permissionsProvider = PermissionsFamily();

/// See also [Permissions].
class PermissionsFamily extends Family<AsyncValue<PermissionStatus>> {
  /// See also [Permissions].
  const PermissionsFamily();

  /// See also [Permissions].
  PermissionsProvider call(
    Permission permission,
  ) {
    return PermissionsProvider(
      permission,
    );
  }

  @override
  PermissionsProvider getProviderOverride(
    covariant PermissionsProvider provider,
  ) {
    return call(
      provider.permission,
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
  String? get name => r'permissionsProvider';
}

/// See also [Permissions].
class PermissionsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    Permissions, PermissionStatus> {
  /// See also [Permissions].
  PermissionsProvider(
    Permission permission,
  ) : this._internal(
          () => Permissions()..permission = permission,
          from: permissionsProvider,
          name: r'permissionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$permissionsHash,
          dependencies: PermissionsFamily._dependencies,
          allTransitiveDependencies:
              PermissionsFamily._allTransitiveDependencies,
          permission: permission,
        );

  PermissionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.permission,
  }) : super.internal();

  final Permission permission;

  @override
  Future<PermissionStatus> runNotifierBuild(
    covariant Permissions notifier,
  ) {
    return notifier.build(
      permission,
    );
  }

  @override
  Override overrideWith(Permissions Function() create) {
    return ProviderOverride(
      origin: this,
      override: PermissionsProvider._internal(
        () => create()..permission = permission,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        permission: permission,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<Permissions, PermissionStatus>
      createElement() {
    return _PermissionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PermissionsProvider && other.permission == permission;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, permission.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PermissionsRef on AutoDisposeAsyncNotifierProviderRef<PermissionStatus> {
  /// The parameter `permission` of this provider.
  Permission get permission;
}

class _PermissionsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<Permissions,
        PermissionStatus> with PermissionsRef {
  _PermissionsProviderElement(super.provider);

  @override
  Permission get permission => (origin as PermissionsProvider).permission;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
