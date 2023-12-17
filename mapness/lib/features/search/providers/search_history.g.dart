// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_history.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchHistoryHash() => r'64403d65fe54a501f117179edb644aceb51a91ec';

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

abstract class _$SearchHistory
    extends BuildlessAutoDisposeNotifier<List<SearchHistoryItem>> {
  late final String scope;

  List<SearchHistoryItem> build(
    String scope,
  );
}

/// See also [SearchHistory].
@ProviderFor(SearchHistory)
const searchHistoryProvider = SearchHistoryFamily();

/// See also [SearchHistory].
class SearchHistoryFamily extends Family<List<SearchHistoryItem>> {
  /// See also [SearchHistory].
  const SearchHistoryFamily();

  /// See also [SearchHistory].
  SearchHistoryProvider call(
    String scope,
  ) {
    return SearchHistoryProvider(
      scope,
    );
  }

  @override
  SearchHistoryProvider getProviderOverride(
    covariant SearchHistoryProvider provider,
  ) {
    return call(
      provider.scope,
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
  String? get name => r'searchHistoryProvider';
}

/// See also [SearchHistory].
class SearchHistoryProvider extends AutoDisposeNotifierProviderImpl<
    SearchHistory, List<SearchHistoryItem>> {
  /// See also [SearchHistory].
  SearchHistoryProvider(
    String scope,
  ) : this._internal(
          () => SearchHistory()..scope = scope,
          from: searchHistoryProvider,
          name: r'searchHistoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchHistoryHash,
          dependencies: SearchHistoryFamily._dependencies,
          allTransitiveDependencies:
              SearchHistoryFamily._allTransitiveDependencies,
          scope: scope,
        );

  SearchHistoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.scope,
  }) : super.internal();

  final String scope;

  @override
  List<SearchHistoryItem> runNotifierBuild(
    covariant SearchHistory notifier,
  ) {
    return notifier.build(
      scope,
    );
  }

  @override
  Override overrideWith(SearchHistory Function() create) {
    return ProviderOverride(
      origin: this,
      override: SearchHistoryProvider._internal(
        () => create()..scope = scope,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        scope: scope,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SearchHistory, List<SearchHistoryItem>>
      createElement() {
    return _SearchHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchHistoryProvider && other.scope == scope;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, scope.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchHistoryRef
    on AutoDisposeNotifierProviderRef<List<SearchHistoryItem>> {
  /// The parameter `scope` of this provider.
  String get scope;
}

class _SearchHistoryProviderElement extends AutoDisposeNotifierProviderElement<
    SearchHistory, List<SearchHistoryItem>> with SearchHistoryRef {
  _SearchHistoryProviderElement(super.provider);

  @override
  String get scope => (origin as SearchHistoryProvider).scope;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
