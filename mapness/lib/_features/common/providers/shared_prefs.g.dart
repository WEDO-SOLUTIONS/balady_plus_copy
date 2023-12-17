// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_prefs.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPrefsHash() => r'709a41c35b1144b8b74b29989097cb2f23939d38';

/// See also [sharedPrefs].
@ProviderFor(sharedPrefs)
final sharedPrefsProvider = AutoDisposeProvider<SharedPreferences>.internal(
  sharedPrefs,
  name: r'sharedPrefsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sharedPrefsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SharedPrefsRef = AutoDisposeProviderRef<SharedPreferences>;
String _$$asyncPrefsLoaderHash() => r'32c21a3e119ebc929eea38c74af112385caf1c2f';

/// user by [EagerInit]
///
/// Copied from [$asyncPrefsLoader].
@ProviderFor($asyncPrefsLoader)
final $asyncPrefsLoaderProvider =
    AutoDisposeFutureProvider<SharedPreferences>.internal(
  $asyncPrefsLoader,
  name: r'$asyncPrefsLoaderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$$asyncPrefsLoaderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef $AsyncPrefsLoaderRef = AutoDisposeFutureProviderRef<SharedPreferences>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
