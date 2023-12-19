// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$jobDetailResponseHash() => r'0f5a3e3241a285b30166871490183de7f11e597e';

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

abstract class _$JobDetailResponse
    extends BuildlessAutoDisposeAsyncNotifier<JobModel?> {
  late final String id;

  Future<JobModel?> build({
    required String id,
  });
}

/// See also [JobDetailResponse].
@ProviderFor(JobDetailResponse)
const jobDetailResponseProvider = JobDetailResponseFamily();

/// See also [JobDetailResponse].
class JobDetailResponseFamily extends Family<AsyncValue<JobModel?>> {
  /// See also [JobDetailResponse].
  const JobDetailResponseFamily();

  /// See also [JobDetailResponse].
  JobDetailResponseProvider call({
    required String id,
  }) {
    return JobDetailResponseProvider(
      id: id,
    );
  }

  @override
  JobDetailResponseProvider getProviderOverride(
    covariant JobDetailResponseProvider provider,
  ) {
    return call(
      id: provider.id,
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
  String? get name => r'jobDetailResponseProvider';
}

/// See also [JobDetailResponse].
class JobDetailResponseProvider
    extends AutoDisposeAsyncNotifierProviderImpl<JobDetailResponse, JobModel?> {
  /// See also [JobDetailResponse].
  JobDetailResponseProvider({
    required String id,
  }) : this._internal(
          () => JobDetailResponse()..id = id,
          from: jobDetailResponseProvider,
          name: r'jobDetailResponseProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$jobDetailResponseHash,
          dependencies: JobDetailResponseFamily._dependencies,
          allTransitiveDependencies:
              JobDetailResponseFamily._allTransitiveDependencies,
          id: id,
        );

  JobDetailResponseProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Future<JobModel?> runNotifierBuild(
    covariant JobDetailResponse notifier,
  ) {
    return notifier.build(
      id: id,
    );
  }

  @override
  Override overrideWith(JobDetailResponse Function() create) {
    return ProviderOverride(
      origin: this,
      override: JobDetailResponseProvider._internal(
        () => create()..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<JobDetailResponse, JobModel?>
      createElement() {
    return _JobDetailResponseProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JobDetailResponseProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin JobDetailResponseRef on AutoDisposeAsyncNotifierProviderRef<JobModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _JobDetailResponseProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<JobDetailResponse,
        JobModel?> with JobDetailResponseRef {
  _JobDetailResponseProviderElement(super.provider);

  @override
  String get id => (origin as JobDetailResponseProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
