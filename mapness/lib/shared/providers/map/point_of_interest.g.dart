// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_of_interest.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pointOfInterestHash() => r'da65329669059430f74039893f1924356d66a823';

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

/// See also [pointOfInterest].
@ProviderFor(pointOfInterest)
const pointOfInterestProvider = PointOfInterestFamily();

/// See also [pointOfInterest].
class PointOfInterestFamily
    extends Family<AsyncValue<DirectoryObjectMessage?>> {
  /// See also [pointOfInterest].
  const PointOfInterestFamily();

  /// See also [pointOfInterest].
  PointOfInterestProvider call(
    DgisObjectIdMessage objectId,
  ) {
    return PointOfInterestProvider(
      objectId,
    );
  }

  @override
  PointOfInterestProvider getProviderOverride(
    covariant PointOfInterestProvider provider,
  ) {
    return call(
      provider.objectId,
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
  String? get name => r'pointOfInterestProvider';
}

/// See also [pointOfInterest].
class PointOfInterestProvider
    extends AutoDisposeFutureProvider<DirectoryObjectMessage?> {
  /// See also [pointOfInterest].
  PointOfInterestProvider(
    DgisObjectIdMessage objectId,
  ) : this._internal(
          (ref) => pointOfInterest(
            ref as PointOfInterestRef,
            objectId,
          ),
          from: pointOfInterestProvider,
          name: r'pointOfInterestProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pointOfInterestHash,
          dependencies: PointOfInterestFamily._dependencies,
          allTransitiveDependencies:
              PointOfInterestFamily._allTransitiveDependencies,
          objectId: objectId,
        );

  PointOfInterestProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.objectId,
  }) : super.internal();

  final DgisObjectIdMessage objectId;

  @override
  Override overrideWith(
    FutureOr<DirectoryObjectMessage?> Function(PointOfInterestRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PointOfInterestProvider._internal(
        (ref) => create(ref as PointOfInterestRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        objectId: objectId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<DirectoryObjectMessage?> createElement() {
    return _PointOfInterestProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PointOfInterestProvider && other.objectId == objectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, objectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PointOfInterestRef
    on AutoDisposeFutureProviderRef<DirectoryObjectMessage?> {
  /// The parameter `objectId` of this provider.
  DgisObjectIdMessage get objectId;
}

class _PointOfInterestProviderElement
    extends AutoDisposeFutureProviderElement<DirectoryObjectMessage?>
    with PointOfInterestRef {
  _PointOfInterestProviderElement(super.provider);

  @override
  DgisObjectIdMessage get objectId =>
      (origin as PointOfInterestProvider).objectId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
