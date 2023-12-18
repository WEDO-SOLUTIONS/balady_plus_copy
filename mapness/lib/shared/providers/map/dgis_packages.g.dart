// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dgis_packages.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dgisPackagesHash() => r'b4e35c9c7c29e4f427f30cc5e6b5256c8e14d119';

/// See also [DgisPackages].
@ProviderFor(DgisPackages)
final dgisPackagesProvider =
    AutoDisposeNotifierProvider<DgisPackages, List<PackageMessage>>.internal(
  DgisPackages.new,
  name: r'dgisPackagesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dgisPackagesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DgisPackages = AutoDisposeNotifier<List<PackageMessage>>;
String _$voicePackagesHash() => r'36537569ac661a199c74c5240ea902919cb54d7a';

/// See also [VoicePackages].
@ProviderFor(VoicePackages)
final voicePackagesProvider =
    AutoDisposeNotifierProvider<VoicePackages, List<PackageMessage>>.internal(
  VoicePackages.new,
  name: r'voicePackagesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$voicePackagesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VoicePackages = AutoDisposeNotifier<List<PackageMessage>>;
String _$packageProgressHash() => r'3e84b0cfa9cb33f57e3ffc59a77113153642f101';

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

abstract class _$PackageProgress extends BuildlessAutoDisposeNotifier<int> {
  late final PackageMessage package;

  int build(
    PackageMessage package,
  );
}

/// See also [PackageProgress].
@ProviderFor(PackageProgress)
const packageProgressProvider = PackageProgressFamily();

/// See also [PackageProgress].
class PackageProgressFamily extends Family<int> {
  /// See also [PackageProgress].
  const PackageProgressFamily();

  /// See also [PackageProgress].
  PackageProgressProvider call(
    PackageMessage package,
  ) {
    return PackageProgressProvider(
      package,
    );
  }

  @override
  PackageProgressProvider getProviderOverride(
    covariant PackageProgressProvider provider,
  ) {
    return call(
      provider.package,
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
  String? get name => r'packageProgressProvider';
}

/// See also [PackageProgress].
class PackageProgressProvider
    extends AutoDisposeNotifierProviderImpl<PackageProgress, int> {
  /// See also [PackageProgress].
  PackageProgressProvider(
    PackageMessage package,
  ) : this._internal(
          () => PackageProgress()..package = package,
          from: packageProgressProvider,
          name: r'packageProgressProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$packageProgressHash,
          dependencies: PackageProgressFamily._dependencies,
          allTransitiveDependencies:
              PackageProgressFamily._allTransitiveDependencies,
          package: package,
        );

  PackageProgressProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.package,
  }) : super.internal();

  final PackageMessage package;

  @override
  int runNotifierBuild(
    covariant PackageProgress notifier,
  ) {
    return notifier.build(
      package,
    );
  }

  @override
  Override overrideWith(PackageProgress Function() create) {
    return ProviderOverride(
      origin: this,
      override: PackageProgressProvider._internal(
        () => create()..package = package,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        package: package,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<PackageProgress, int> createElement() {
    return _PackageProgressProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PackageProgressProvider && other.package == package;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, package.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PackageProgressRef on AutoDisposeNotifierProviderRef<int> {
  /// The parameter `package` of this provider.
  PackageMessage get package;
}

class _PackageProgressProviderElement
    extends AutoDisposeNotifierProviderElement<PackageProgress, int>
    with PackageProgressRef {
  _PackageProgressProviderElement(super.provider);

  @override
  PackageMessage get package => (origin as PackageProgressProvider).package;
}

String _$packageInfoHash() => r'e95210d58444085dd078d5c5e487e9740b72c0ef';

abstract class _$PackageInfo
    extends BuildlessAutoDisposeNotifier<PackageInfoMessage> {
  late final PackageMessage package;

  PackageInfoMessage build(
    PackageMessage package,
  );
}

/// See also [PackageInfo].
@ProviderFor(PackageInfo)
const packageInfoProvider = PackageInfoFamily();

/// See also [PackageInfo].
class PackageInfoFamily extends Family<PackageInfoMessage> {
  /// See also [PackageInfo].
  const PackageInfoFamily();

  /// See also [PackageInfo].
  PackageInfoProvider call(
    PackageMessage package,
  ) {
    return PackageInfoProvider(
      package,
    );
  }

  @override
  PackageInfoProvider getProviderOverride(
    covariant PackageInfoProvider provider,
  ) {
    return call(
      provider.package,
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
  String? get name => r'packageInfoProvider';
}

/// See also [PackageInfo].
class PackageInfoProvider
    extends AutoDisposeNotifierProviderImpl<PackageInfo, PackageInfoMessage> {
  /// See also [PackageInfo].
  PackageInfoProvider(
    PackageMessage package,
  ) : this._internal(
          () => PackageInfo()..package = package,
          from: packageInfoProvider,
          name: r'packageInfoProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$packageInfoHash,
          dependencies: PackageInfoFamily._dependencies,
          allTransitiveDependencies:
              PackageInfoFamily._allTransitiveDependencies,
          package: package,
        );

  PackageInfoProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.package,
  }) : super.internal();

  final PackageMessage package;

  @override
  PackageInfoMessage runNotifierBuild(
    covariant PackageInfo notifier,
  ) {
    return notifier.build(
      package,
    );
  }

  @override
  Override overrideWith(PackageInfo Function() create) {
    return ProviderOverride(
      origin: this,
      override: PackageInfoProvider._internal(
        () => create()..package = package,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        package: package,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<PackageInfo, PackageInfoMessage>
      createElement() {
    return _PackageInfoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PackageInfoProvider && other.package == package;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, package.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PackageInfoRef on AutoDisposeNotifierProviderRef<PackageInfoMessage> {
  /// The parameter `package` of this provider.
  PackageMessage get package;
}

class _PackageInfoProviderElement
    extends AutoDisposeNotifierProviderElement<PackageInfo, PackageInfoMessage>
    with PackageInfoRef {
  _PackageInfoProviderElement(super.provider);

  @override
  PackageMessage get package => (origin as PackageInfoProvider).package;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
