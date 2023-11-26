// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$storyServiceHash() => r'296c58c70e5fe9165bd636bc567fd1ca93575903';

/// See also [StoryService].
@ProviderFor(StoryService)
final storyServiceProvider =
    AutoDisposeAsyncNotifierProvider<StoryService, List<StoryData>>.internal(
  StoryService.new,
  name: r'storyServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$storyServiceHash,
  dependencies: <ProviderOrFamily>[storiesRepoProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    storiesRepoProvider,
    ...?storiesRepoProvider.allTransitiveDependencies
  },
);

typedef _$StoryService = AutoDisposeAsyncNotifier<List<StoryData>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
