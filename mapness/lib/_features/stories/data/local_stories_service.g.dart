// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_stories_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$localStoriesServiceHash() =>
    r'74d9dcb07ee3c658e5544f646866e178d1278abc';

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

abstract class _$LocalStoriesService
    extends BuildlessAutoDisposeAsyncNotifier<List<StoryData>> {
  late final String file;

  Future<List<StoryData>> build(
    String file,
  );
}

/// See also [LocalStoriesService].
@ProviderFor(LocalStoriesService)
const localStoriesServiceProvider = LocalStoriesServiceFamily();

/// See also [LocalStoriesService].
class LocalStoriesServiceFamily extends Family<AsyncValue<List<StoryData>>> {
  /// See also [LocalStoriesService].
  const LocalStoriesServiceFamily();

  /// See also [LocalStoriesService].
  LocalStoriesServiceProvider call(
    String file,
  ) {
    return LocalStoriesServiceProvider(
      file,
    );
  }

  @override
  LocalStoriesServiceProvider getProviderOverride(
    covariant LocalStoriesServiceProvider provider,
  ) {
    return call(
      provider.file,
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
  String? get name => r'localStoriesServiceProvider';
}

/// See also [LocalStoriesService].
class LocalStoriesServiceProvider extends AutoDisposeAsyncNotifierProviderImpl<
    LocalStoriesService, List<StoryData>> {
  /// See also [LocalStoriesService].
  LocalStoriesServiceProvider(
    String file,
  ) : this._internal(
          () => LocalStoriesService()..file = file,
          from: localStoriesServiceProvider,
          name: r'localStoriesServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$localStoriesServiceHash,
          dependencies: LocalStoriesServiceFamily._dependencies,
          allTransitiveDependencies:
              LocalStoriesServiceFamily._allTransitiveDependencies,
          file: file,
        );

  LocalStoriesServiceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.file,
  }) : super.internal();

  final String file;

  @override
  Future<List<StoryData>> runNotifierBuild(
    covariant LocalStoriesService notifier,
  ) {
    return notifier.build(
      file,
    );
  }

  @override
  Override overrideWith(LocalStoriesService Function() create) {
    return ProviderOverride(
      origin: this,
      override: LocalStoriesServiceProvider._internal(
        () => create()..file = file,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        file: file,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<LocalStoriesService, List<StoryData>>
      createElement() {
    return _LocalStoriesServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LocalStoriesServiceProvider && other.file == file;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, file.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LocalStoriesServiceRef
    on AutoDisposeAsyncNotifierProviderRef<List<StoryData>> {
  /// The parameter `file` of this provider.
  String get file;
}

class _LocalStoriesServiceProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<LocalStoriesService,
        List<StoryData>> with LocalStoriesServiceRef {
  _LocalStoriesServiceProviderElement(super.provider);

  @override
  String get file => (origin as LocalStoriesServiceProvider).file;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
