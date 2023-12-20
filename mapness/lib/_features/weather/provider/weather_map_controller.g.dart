// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_map_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$weatherMapControllerHash() =>
    r'c16ff0bc579e84f97bd98b6ded1f57c590d22c0f';

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

abstract class _$WeatherMapController
    extends BuildlessAutoDisposeNotifier<WeatherMapState> {
  late final dynamic Function(DgisObjectIdMessage?)? onTap;

  WeatherMapState build({
    dynamic Function(DgisObjectIdMessage?)? onTap,
  });
}

/// See also [WeatherMapController].
@ProviderFor(WeatherMapController)
const weatherMapControllerProvider = WeatherMapControllerFamily();

/// See also [WeatherMapController].
class WeatherMapControllerFamily extends Family<WeatherMapState> {
  /// See also [WeatherMapController].
  const WeatherMapControllerFamily();

  /// See also [WeatherMapController].
  WeatherMapControllerProvider call({
    dynamic Function(DgisObjectIdMessage?)? onTap,
  }) {
    return WeatherMapControllerProvider(
      onTap: onTap,
    );
  }

  @override
  WeatherMapControllerProvider getProviderOverride(
    covariant WeatherMapControllerProvider provider,
  ) {
    return call(
      onTap: provider.onTap,
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
  String? get name => r'weatherMapControllerProvider';
}

/// See also [WeatherMapController].
class WeatherMapControllerProvider extends AutoDisposeNotifierProviderImpl<
    WeatherMapController, WeatherMapState> {
  /// See also [WeatherMapController].
  WeatherMapControllerProvider({
    dynamic Function(DgisObjectIdMessage?)? onTap,
  }) : this._internal(
          () => WeatherMapController()..onTap = onTap,
          from: weatherMapControllerProvider,
          name: r'weatherMapControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$weatherMapControllerHash,
          dependencies: WeatherMapControllerFamily._dependencies,
          allTransitiveDependencies:
              WeatherMapControllerFamily._allTransitiveDependencies,
          onTap: onTap,
        );

  WeatherMapControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.onTap,
  }) : super.internal();

  final dynamic Function(DgisObjectIdMessage?)? onTap;

  @override
  WeatherMapState runNotifierBuild(
    covariant WeatherMapController notifier,
  ) {
    return notifier.build(
      onTap: onTap,
    );
  }

  @override
  Override overrideWith(WeatherMapController Function() create) {
    return ProviderOverride(
      origin: this,
      override: WeatherMapControllerProvider._internal(
        () => create()..onTap = onTap,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        onTap: onTap,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<WeatherMapController, WeatherMapState>
      createElement() {
    return _WeatherMapControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WeatherMapControllerProvider && other.onTap == onTap;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, onTap.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WeatherMapControllerRef
    on AutoDisposeNotifierProviderRef<WeatherMapState> {
  /// The parameter `onTap` of this provider.
  dynamic Function(DgisObjectIdMessage?)? get onTap;
}

class _WeatherMapControllerProviderElement
    extends AutoDisposeNotifierProviderElement<WeatherMapController,
        WeatherMapState> with WeatherMapControllerRef {
  _WeatherMapControllerProviderElement(super.provider);

  @override
  dynamic Function(DgisObjectIdMessage?)? get onTap =>
      (origin as WeatherMapControllerProvider).onTap;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
