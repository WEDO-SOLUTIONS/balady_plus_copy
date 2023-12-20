// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iwish_feedback.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$iwishFeedbackHash() => r'511756c30db914130d3868357ee302e85aa398f8';

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

abstract class _$IwishFeedback
    extends BuildlessAutoDisposeAsyncNotifier<IwishFeedbackEntity> {
  late final String iwishId;

  Future<IwishFeedbackEntity> build(
    String iwishId,
  );
}

/// See also [_IwishFeedback].
@ProviderFor(_IwishFeedback)
const _iwishFeedbackProvider = _IwishFeedbackFamily();

/// See also [_IwishFeedback].
class _IwishFeedbackFamily extends Family<AsyncValue<IwishFeedbackEntity>> {
  /// See also [_IwishFeedback].
  const _IwishFeedbackFamily();

  /// See also [_IwishFeedback].
  _IwishFeedbackProvider call(
    String iwishId,
  ) {
    return _IwishFeedbackProvider(
      iwishId,
    );
  }

  @override
  _IwishFeedbackProvider getProviderOverride(
    covariant _IwishFeedbackProvider provider,
  ) {
    return call(
      provider.iwishId,
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
  String? get name => r'_iwishFeedbackProvider';
}

/// See also [_IwishFeedback].
class _IwishFeedbackProvider extends AutoDisposeAsyncNotifierProviderImpl<
    _IwishFeedback, IwishFeedbackEntity> {
  /// See also [_IwishFeedback].
  _IwishFeedbackProvider(
    String iwishId,
  ) : this._internal(
          () => _IwishFeedback()..iwishId = iwishId,
          from: _iwishFeedbackProvider,
          name: r'_iwishFeedbackProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$iwishFeedbackHash,
          dependencies: _IwishFeedbackFamily._dependencies,
          allTransitiveDependencies:
              _IwishFeedbackFamily._allTransitiveDependencies,
          iwishId: iwishId,
        );

  _IwishFeedbackProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.iwishId,
  }) : super.internal();

  final String iwishId;

  @override
  Future<IwishFeedbackEntity> runNotifierBuild(
    covariant _IwishFeedback notifier,
  ) {
    return notifier.build(
      iwishId,
    );
  }

  @override
  Override overrideWith(_IwishFeedback Function() create) {
    return ProviderOverride(
      origin: this,
      override: _IwishFeedbackProvider._internal(
        () => create()..iwishId = iwishId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        iwishId: iwishId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<_IwishFeedback, IwishFeedbackEntity>
      createElement() {
    return _IwishFeedbackProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _IwishFeedbackProvider && other.iwishId == iwishId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, iwishId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin _IwishFeedbackRef
    on AutoDisposeAsyncNotifierProviderRef<IwishFeedbackEntity> {
  /// The parameter `iwishId` of this provider.
  String get iwishId;
}

class _IwishFeedbackProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<_IwishFeedback,
        IwishFeedbackEntity> with _IwishFeedbackRef {
  _IwishFeedbackProviderElement(super.provider);

  @override
  String get iwishId => (origin as _IwishFeedbackProvider).iwishId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
