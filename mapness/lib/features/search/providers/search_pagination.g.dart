// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_pagination.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchPaginationHash() => r'04dd81679282161a6467a0fee36c6e308aad19ae';

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

abstract class _$SearchPagination
    extends BuildlessAutoDisposeNotifier<List<DirectoryObjectMessage>> {
  late final SearchResultMessage results;

  List<DirectoryObjectMessage> build(
    SearchResultMessage results,
  );
}

/// See also [SearchPagination].
@ProviderFor(SearchPagination)
const searchPaginationProvider = SearchPaginationFamily();

/// See also [SearchPagination].
class SearchPaginationFamily extends Family<List<DirectoryObjectMessage>> {
  /// See also [SearchPagination].
  const SearchPaginationFamily();

  /// See also [SearchPagination].
  SearchPaginationProvider call(
    SearchResultMessage results,
  ) {
    return SearchPaginationProvider(
      results,
    );
  }

  @override
  SearchPaginationProvider getProviderOverride(
    covariant SearchPaginationProvider provider,
  ) {
    return call(
      provider.results,
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
  String? get name => r'searchPaginationProvider';
}

/// See also [SearchPagination].
class SearchPaginationProvider extends AutoDisposeNotifierProviderImpl<
    SearchPagination, List<DirectoryObjectMessage>> {
  /// See also [SearchPagination].
  SearchPaginationProvider(
    SearchResultMessage results,
  ) : this._internal(
          () => SearchPagination()..results = results,
          from: searchPaginationProvider,
          name: r'searchPaginationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchPaginationHash,
          dependencies: SearchPaginationFamily._dependencies,
          allTransitiveDependencies:
              SearchPaginationFamily._allTransitiveDependencies,
          results: results,
        );

  SearchPaginationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.results,
  }) : super.internal();

  final SearchResultMessage results;

  @override
  List<DirectoryObjectMessage> runNotifierBuild(
    covariant SearchPagination notifier,
  ) {
    return notifier.build(
      results,
    );
  }

  @override
  Override overrideWith(SearchPagination Function() create) {
    return ProviderOverride(
      origin: this,
      override: SearchPaginationProvider._internal(
        () => create()..results = results,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        results: results,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SearchPagination,
      List<DirectoryObjectMessage>> createElement() {
    return _SearchPaginationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchPaginationProvider && other.results == results;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, results.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchPaginationRef
    on AutoDisposeNotifierProviderRef<List<DirectoryObjectMessage>> {
  /// The parameter `results` of this provider.
  SearchResultMessage get results;
}

class _SearchPaginationProviderElement
    extends AutoDisposeNotifierProviderElement<SearchPagination,
        List<DirectoryObjectMessage>> with SearchPaginationRef {
  _SearchPaginationProviderElement(super.provider);

  @override
  SearchResultMessage get results =>
      (origin as SearchPaginationProvider).results;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
