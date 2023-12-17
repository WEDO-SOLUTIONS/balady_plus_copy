// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layers_details.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$layersDetailsHash() => r'6d504eecf052a081a8a772febff50e4f4113ef8b';

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

abstract class _$LayersDetails
    extends BuildlessAutoDisposeNotifier<LayerDetailsState> {
  late final PointLayersData data;

  LayerDetailsState build(
    PointLayersData data,
  );
}

/// See also [LayersDetails].
@ProviderFor(LayersDetails)
const layersDetailsProvider = LayersDetailsFamily();

/// See also [LayersDetails].
class LayersDetailsFamily extends Family<LayerDetailsState> {
  /// See also [LayersDetails].
  const LayersDetailsFamily();

  /// See also [LayersDetails].
  LayersDetailsProvider call(
    PointLayersData data,
  ) {
    return LayersDetailsProvider(
      data,
    );
  }

  @override
  LayersDetailsProvider getProviderOverride(
    covariant LayersDetailsProvider provider,
  ) {
    return call(
      provider.data,
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
  String? get name => r'layersDetailsProvider';
}

/// See also [LayersDetails].
class LayersDetailsProvider
    extends AutoDisposeNotifierProviderImpl<LayersDetails, LayerDetailsState> {
  /// See also [LayersDetails].
  LayersDetailsProvider(
    PointLayersData data,
  ) : this._internal(
          () => LayersDetails()..data = data,
          from: layersDetailsProvider,
          name: r'layersDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$layersDetailsHash,
          dependencies: LayersDetailsFamily._dependencies,
          allTransitiveDependencies:
              LayersDetailsFamily._allTransitiveDependencies,
          data: data,
        );

  LayersDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.data,
  }) : super.internal();

  final PointLayersData data;

  @override
  LayerDetailsState runNotifierBuild(
    covariant LayersDetails notifier,
  ) {
    return notifier.build(
      data,
    );
  }

  @override
  Override overrideWith(LayersDetails Function() create) {
    return ProviderOverride(
      origin: this,
      override: LayersDetailsProvider._internal(
        () => create()..data = data,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        data: data,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<LayersDetails, LayerDetailsState>
      createElement() {
    return _LayersDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LayersDetailsProvider && other.data == data;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, data.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LayersDetailsRef on AutoDisposeNotifierProviderRef<LayerDetailsState> {
  /// The parameter `data` of this provider.
  PointLayersData get data;
}

class _LayersDetailsProviderElement
    extends AutoDisposeNotifierProviderElement<LayersDetails, LayerDetailsState>
    with LayersDetailsRef {
  _LayersDetailsProviderElement(super.provider);

  @override
  PointLayersData get data => (origin as LayersDetailsProvider).data;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
