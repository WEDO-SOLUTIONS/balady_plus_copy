// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stories_repo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$storiesRepoHash() => r'5f0d061229c1d76dd8db091ade134314bd800d2e';

/// See also [StoriesRepo].
@ProviderFor(StoriesRepo)
final storiesRepoProvider =
    AutoDisposeAsyncNotifierProvider<StoriesRepo, StoriesResponse>.internal(
  StoriesRepo.new,
  name: r'storiesRepoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$storiesRepoHash,
  dependencies: <ProviderOrFamily>[dGisNetworkProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    dGisNetworkProvider,
    ...?dGisNetworkProvider.allTransitiveDependencies
  },
);

typedef _$StoriesRepo = AutoDisposeAsyncNotifier<StoriesResponse>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
