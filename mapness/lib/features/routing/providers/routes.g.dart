// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$routesHash() => r'1fb08ce13b1395466c8930aec59d46d822e72af8';

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

abstract class _$Routes extends BuildlessAutoDisposeNotifier<List<RouteInfo>> {
  late final RouteParamsPoint? startPoint;
  late final RouteParamsPoint? finishPoint;
  late final RouteSearchOptionsMessage navType;

  List<RouteInfo> build({
    required RouteParamsPoint? startPoint,
    required RouteParamsPoint? finishPoint,
    required RouteSearchOptionsMessage navType,
  });
}

/// See also [Routes].
@ProviderFor(Routes)
const routesProvider = RoutesFamily();

/// See also [Routes].
class RoutesFamily extends Family<List<RouteInfo>> {
  /// See also [Routes].
  const RoutesFamily();

  /// See also [Routes].
  RoutesProvider call({
    required RouteParamsPoint? startPoint,
    required RouteParamsPoint? finishPoint,
    required RouteSearchOptionsMessage navType,
  }) {
    return RoutesProvider(
      startPoint: startPoint,
      finishPoint: finishPoint,
      navType: navType,
    );
  }

  @override
  RoutesProvider getProviderOverride(
    covariant RoutesProvider provider,
  ) {
    return call(
      startPoint: provider.startPoint,
      finishPoint: provider.finishPoint,
      navType: provider.navType,
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
  String? get name => r'routesProvider';
}

/// See also [Routes].
class RoutesProvider
    extends AutoDisposeNotifierProviderImpl<Routes, List<RouteInfo>> {
  /// See also [Routes].
  RoutesProvider({
    required RouteParamsPoint? startPoint,
    required RouteParamsPoint? finishPoint,
    required RouteSearchOptionsMessage navType,
  }) : this._internal(
          () => Routes()
            ..startPoint = startPoint
            ..finishPoint = finishPoint
            ..navType = navType,
          from: routesProvider,
          name: r'routesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$routesHash,
          dependencies: RoutesFamily._dependencies,
          allTransitiveDependencies: RoutesFamily._allTransitiveDependencies,
          startPoint: startPoint,
          finishPoint: finishPoint,
          navType: navType,
        );

  RoutesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startPoint,
    required this.finishPoint,
    required this.navType,
  }) : super.internal();

  final RouteParamsPoint? startPoint;
  final RouteParamsPoint? finishPoint;
  final RouteSearchOptionsMessage navType;

  @override
  List<RouteInfo> runNotifierBuild(
    covariant Routes notifier,
  ) {
    return notifier.build(
      startPoint: startPoint,
      finishPoint: finishPoint,
      navType: navType,
    );
  }

  @override
  Override overrideWith(Routes Function() create) {
    return ProviderOverride(
      origin: this,
      override: RoutesProvider._internal(
        () => create()
          ..startPoint = startPoint
          ..finishPoint = finishPoint
          ..navType = navType,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startPoint: startPoint,
        finishPoint: finishPoint,
        navType: navType,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<Routes, List<RouteInfo>> createElement() {
    return _RoutesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RoutesProvider &&
        other.startPoint == startPoint &&
        other.finishPoint == finishPoint &&
        other.navType == navType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startPoint.hashCode);
    hash = _SystemHash.combine(hash, finishPoint.hashCode);
    hash = _SystemHash.combine(hash, navType.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RoutesRef on AutoDisposeNotifierProviderRef<List<RouteInfo>> {
  /// The parameter `startPoint` of this provider.
  RouteParamsPoint? get startPoint;

  /// The parameter `finishPoint` of this provider.
  RouteParamsPoint? get finishPoint;

  /// The parameter `navType` of this provider.
  RouteSearchOptionsMessage get navType;
}

class _RoutesProviderElement
    extends AutoDisposeNotifierProviderElement<Routes, List<RouteInfo>>
    with RoutesRef {
  _RoutesProviderElement(super.provider);

  @override
  RouteParamsPoint? get startPoint => (origin as RoutesProvider).startPoint;
  @override
  RouteParamsPoint? get finishPoint => (origin as RoutesProvider).finishPoint;
  @override
  RouteSearchOptionsMessage get navType => (origin as RoutesProvider).navType;
}

String _$activeRouteHash() => r'f90a3e308a73df92e88de39601bdd7716cf36aba';

/// See also [ActiveRoute].
@ProviderFor(ActiveRoute)
final activeRouteProvider =
    AutoDisposeNotifierProvider<ActiveRoute, int>.internal(
  ActiveRoute.new,
  name: r'activeRouteProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$activeRouteHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ActiveRoute = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
