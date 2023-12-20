// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_brief_route_info.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$briefRouteInfoHash() => r'098bbf0888dc04f90db48e11dba263c5b3b78a13';

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

abstract class _$BriefRouteInfo
    extends BuildlessAutoDisposeNotifier<List<BriefRouteInfoMessage>?> {
  late final RouteSearchPointMessage? finishPoint;
  late final RouteSearchPointMessage? startPoint;
  late final RouteSearchOptionsMessage navType;

  List<BriefRouteInfoMessage>? build({
    required RouteSearchPointMessage? finishPoint,
    RouteSearchPointMessage? startPoint,
    required RouteSearchOptionsMessage navType,
  });
}

/// See also [_BriefRouteInfo].
@ProviderFor(_BriefRouteInfo)
const _briefRouteInfoProvider = _BriefRouteInfoFamily();

/// See also [_BriefRouteInfo].
class _BriefRouteInfoFamily extends Family<List<BriefRouteInfoMessage>?> {
  /// See also [_BriefRouteInfo].
  const _BriefRouteInfoFamily();

  /// See also [_BriefRouteInfo].
  _BriefRouteInfoProvider call({
    required RouteSearchPointMessage? finishPoint,
    RouteSearchPointMessage? startPoint,
    required RouteSearchOptionsMessage navType,
  }) {
    return _BriefRouteInfoProvider(
      finishPoint: finishPoint,
      startPoint: startPoint,
      navType: navType,
    );
  }

  @override
  _BriefRouteInfoProvider getProviderOverride(
    covariant _BriefRouteInfoProvider provider,
  ) {
    return call(
      finishPoint: provider.finishPoint,
      startPoint: provider.startPoint,
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
  String? get name => r'_briefRouteInfoProvider';
}

/// See also [_BriefRouteInfo].
class _BriefRouteInfoProvider extends AutoDisposeNotifierProviderImpl<
    _BriefRouteInfo, List<BriefRouteInfoMessage>?> {
  /// See also [_BriefRouteInfo].
  _BriefRouteInfoProvider({
    required RouteSearchPointMessage? finishPoint,
    RouteSearchPointMessage? startPoint,
    required RouteSearchOptionsMessage navType,
  }) : this._internal(
          () => _BriefRouteInfo()
            ..finishPoint = finishPoint
            ..startPoint = startPoint
            ..navType = navType,
          from: _briefRouteInfoProvider,
          name: r'_briefRouteInfoProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$briefRouteInfoHash,
          dependencies: _BriefRouteInfoFamily._dependencies,
          allTransitiveDependencies:
              _BriefRouteInfoFamily._allTransitiveDependencies,
          finishPoint: finishPoint,
          startPoint: startPoint,
          navType: navType,
        );

  _BriefRouteInfoProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.finishPoint,
    required this.startPoint,
    required this.navType,
  }) : super.internal();

  final RouteSearchPointMessage? finishPoint;
  final RouteSearchPointMessage? startPoint;
  final RouteSearchOptionsMessage navType;

  @override
  List<BriefRouteInfoMessage>? runNotifierBuild(
    covariant _BriefRouteInfo notifier,
  ) {
    return notifier.build(
      finishPoint: finishPoint,
      startPoint: startPoint,
      navType: navType,
    );
  }

  @override
  Override overrideWith(_BriefRouteInfo Function() create) {
    return ProviderOverride(
      origin: this,
      override: _BriefRouteInfoProvider._internal(
        () => create()
          ..finishPoint = finishPoint
          ..startPoint = startPoint
          ..navType = navType,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        finishPoint: finishPoint,
        startPoint: startPoint,
        navType: navType,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<_BriefRouteInfo,
      List<BriefRouteInfoMessage>?> createElement() {
    return _BriefRouteInfoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _BriefRouteInfoProvider &&
        other.finishPoint == finishPoint &&
        other.startPoint == startPoint &&
        other.navType == navType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, finishPoint.hashCode);
    hash = _SystemHash.combine(hash, startPoint.hashCode);
    hash = _SystemHash.combine(hash, navType.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin _BriefRouteInfoRef
    on AutoDisposeNotifierProviderRef<List<BriefRouteInfoMessage>?> {
  /// The parameter `finishPoint` of this provider.
  RouteSearchPointMessage? get finishPoint;

  /// The parameter `startPoint` of this provider.
  RouteSearchPointMessage? get startPoint;

  /// The parameter `navType` of this provider.
  RouteSearchOptionsMessage get navType;
}

class _BriefRouteInfoProviderElement extends AutoDisposeNotifierProviderElement<
    _BriefRouteInfo, List<BriefRouteInfoMessage>?> with _BriefRouteInfoRef {
  _BriefRouteInfoProviderElement(super.provider);

  @override
  RouteSearchPointMessage? get finishPoint =>
      (origin as _BriefRouteInfoProvider).finishPoint;
  @override
  RouteSearchPointMessage? get startPoint =>
      (origin as _BriefRouteInfoProvider).startPoint;
  @override
  RouteSearchOptionsMessage get navType =>
      (origin as _BriefRouteInfoProvider).navType;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
