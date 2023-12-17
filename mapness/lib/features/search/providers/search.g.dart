// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchQueryHash() => r'01fb040aec4f02d9bdb2dfe8e6a962879a3544a4';

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

abstract class _$SearchQuery extends BuildlessAutoDisposeNotifier<String> {
  late final String scope;

  String build(
    String scope,
  );
}

/// See also [SearchQuery].
@ProviderFor(SearchQuery)
const searchQueryProvider = SearchQueryFamily();

/// See also [SearchQuery].
class SearchQueryFamily extends Family<String> {
  /// See also [SearchQuery].
  const SearchQueryFamily();

  /// See also [SearchQuery].
  SearchQueryProvider call(
    String scope,
  ) {
    return SearchQueryProvider(
      scope,
    );
  }

  @override
  SearchQueryProvider getProviderOverride(
    covariant SearchQueryProvider provider,
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
  String? get name => r'searchQueryProvider';
}

/// See also [SearchQuery].
class SearchQueryProvider
    extends AutoDisposeNotifierProviderImpl<SearchQuery, String> {
  /// See also [SearchQuery].
  SearchQueryProvider(
    String scope,
  ) : this._internal(
          () => SearchQuery()..scope = scope,
          from: searchQueryProvider,
          name: r'searchQueryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchQueryHash,
          dependencies: SearchQueryFamily._dependencies,
          allTransitiveDependencies:
              SearchQueryFamily._allTransitiveDependencies,
          scope: scope,
        );

  SearchQueryProvider._internal(
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
  String runNotifierBuild(
    covariant SearchQuery notifier,
  ) {
    return notifier.build(
      scope,
    );
  }

  @override
  Override overrideWith(SearchQuery Function() create) {
    return ProviderOverride(
      origin: this,
      override: SearchQueryProvider._internal(
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
  AutoDisposeNotifierProviderElement<SearchQuery, String> createElement() {
    return _SearchQueryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchQueryProvider && other.scope == scope;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, scope.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchQueryRef on AutoDisposeNotifierProviderRef<String> {
  /// The parameter `scope` of this provider.
  String get scope;
}

class _SearchQueryProviderElement
    extends AutoDisposeNotifierProviderElement<SearchQuery, String>
    with SearchQueryRef {
  _SearchQueryProviderElement(super.provider);

  @override
  String get scope => (origin as SearchQueryProvider).scope;
}

String _$searchHash() => r'ab6f37ad7c8c0faaa7886aea89b5b92cfd138504';

abstract class _$Search extends BuildlessAutoDisposeNotifier<SearchState> {
  late final String scope;

  SearchState build(
    String scope,
  );
}

/// See also [Search].
@ProviderFor(Search)
const searchProvider = SearchFamily();

/// See also [Search].
class SearchFamily extends Family<SearchState> {
  /// See also [Search].
  const SearchFamily();

  /// See also [Search].
  SearchProvider call(
    String scope,
  ) {
    return SearchProvider(
      scope,
    );
  }

  @override
  SearchProvider getProviderOverride(
    covariant SearchProvider provider,
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
  String? get name => r'searchProvider';
}

/// See also [Search].
class SearchProvider
    extends AutoDisposeNotifierProviderImpl<Search, SearchState> {
  /// See also [Search].
  SearchProvider(
    String scope,
  ) : this._internal(
          () => Search()..scope = scope,
          from: searchProvider,
          name: r'searchProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchHash,
          dependencies: SearchFamily._dependencies,
          allTransitiveDependencies: SearchFamily._allTransitiveDependencies,
          scope: scope,
        );

  SearchProvider._internal(
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
  SearchState runNotifierBuild(
    covariant Search notifier,
  ) {
    return notifier.build(
      scope,
    );
  }

  @override
  Override overrideWith(Search Function() create) {
    return ProviderOverride(
      origin: this,
      override: SearchProvider._internal(
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
  AutoDisposeNotifierProviderElement<Search, SearchState> createElement() {
    return _SearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchProvider && other.scope == scope;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, scope.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchRef on AutoDisposeNotifierProviderRef<SearchState> {
  /// The parameter `scope` of this provider.
  String get scope;
}

class _SearchProviderElement
    extends AutoDisposeNotifierProviderElement<Search, SearchState>
    with SearchRef {
  _SearchProviderElement(super.provider);

  @override
  String get scope => (origin as SearchProvider).scope;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
