// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$jobListResponseHash() => r'453698ff5caf40bd2c82c26dfda615d3d6cc65b3';

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

abstract class _$JobListResponse
    extends BuildlessAutoDisposeAsyncNotifier<JobListModel?> {
  late final int page;
  late final int size;
  late final String sort;

  Future<JobListModel?> build({
    required int page,
    required int size,
    String sort = 'desc',
  });
}

/// See also [JobListResponse].
@ProviderFor(JobListResponse)
const jobListResponseProvider = JobListResponseFamily();

/// See also [JobListResponse].
class JobListResponseFamily extends Family<AsyncValue<JobListModel?>> {
  /// See also [JobListResponse].
  const JobListResponseFamily();

  /// See also [JobListResponse].
  JobListResponseProvider call({
    required int page,
    required int size,
    String sort = 'desc',
  }) {
    return JobListResponseProvider(
      page: page,
      size: size,
      sort: sort,
    );
  }

  @override
  JobListResponseProvider getProviderOverride(
    covariant JobListResponseProvider provider,
  ) {
    return call(
      page: provider.page,
      size: provider.size,
      sort: provider.sort,
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
  String? get name => r'jobListResponseProvider';
}

/// See also [JobListResponse].
class JobListResponseProvider extends AutoDisposeAsyncNotifierProviderImpl<
    JobListResponse, JobListModel?> {
  /// See also [JobListResponse].
  JobListResponseProvider({
    required int page,
    required int size,
    String sort = 'desc',
  }) : this._internal(
          () => JobListResponse()
            ..page = page
            ..size = size
            ..sort = sort,
          from: jobListResponseProvider,
          name: r'jobListResponseProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$jobListResponseHash,
          dependencies: JobListResponseFamily._dependencies,
          allTransitiveDependencies:
              JobListResponseFamily._allTransitiveDependencies,
          page: page,
          size: size,
          sort: sort,
        );

  JobListResponseProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.size,
    required this.sort,
  }) : super.internal();

  final int page;
  final int size;
  final String sort;

  @override
  Future<JobListModel?> runNotifierBuild(
    covariant JobListResponse notifier,
  ) {
    return notifier.build(
      page: page,
      size: size,
      sort: sort,
    );
  }

  @override
  Override overrideWith(JobListResponse Function() create) {
    return ProviderOverride(
      origin: this,
      override: JobListResponseProvider._internal(
        () => create()
          ..page = page
          ..size = size
          ..sort = sort,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        size: size,
        sort: sort,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<JobListResponse, JobListModel?>
      createElement() {
    return _JobListResponseProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JobListResponseProvider &&
        other.page == page &&
        other.size == size &&
        other.sort == sort;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, size.hashCode);
    hash = _SystemHash.combine(hash, sort.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin JobListResponseRef on AutoDisposeAsyncNotifierProviderRef<JobListModel?> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `size` of this provider.
  int get size;

  /// The parameter `sort` of this provider.
  String get sort;
}

class _JobListResponseProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<JobListResponse,
        JobListModel?> with JobListResponseRef {
  _JobListResponseProviderElement(super.provider);

  @override
  int get page => (origin as JobListResponseProvider).page;
  @override
  int get size => (origin as JobListResponseProvider).size;
  @override
  String get sort => (origin as JobListResponseProvider).sort;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
