// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$storyServiceHash() => r'aa5de723cf56d9b31953ffb0daa744d7b3dff56b';

/// See also [StoryService].
@ProviderFor(StoryService)
final storyServiceProvider =
    AutoDisposeAsyncNotifierProvider<StoryService, StoryOverallData>.internal(
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

typedef _$StoryService = AutoDisposeAsyncNotifier<StoryOverallData>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
