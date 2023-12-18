// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggest.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$suggestQueryHash() => r'528f695ceaf84bb978e6677b8f749e92fc151fff';

/// See also [SuggestQuery].
@ProviderFor(SuggestQuery)
final suggestQueryProvider =
    AutoDisposeNotifierProvider<SuggestQuery, String>.internal(
  SuggestQuery.new,
  name: r'suggestQueryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$suggestQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SuggestQuery = AutoDisposeNotifier<String>;
String _$suggestResultsHash() => r'9e6d474e1367b9df157142697e58cea22104c017';

/// See also [SuggestResults].
@ProviderFor(SuggestResults)
final suggestResultsProvider = AutoDisposeAsyncNotifierProvider<SuggestResults,
    List<SuggestMessage>>.internal(
  SuggestResults.new,
  name: r'suggestResultsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$suggestResultsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SuggestResults = AutoDisposeAsyncNotifier<List<SuggestMessage>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
