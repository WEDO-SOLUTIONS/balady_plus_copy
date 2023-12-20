// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sso_credential_info.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ssoEnvironmentHash() => r'1a824209fe64220cfc08f53206ffa520003e1419';

/// See also [SsoEnvironment].
@ProviderFor(SsoEnvironment)
final ssoEnvironmentProvider =
    AutoDisposeNotifierProvider<SsoEnvironment, SsoEnvironmentType>.internal(
  SsoEnvironment.new,
  name: r'ssoEnvironmentProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ssoEnvironmentHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SsoEnvironment = AutoDisposeNotifier<SsoEnvironmentType>;
String _$ssoCredentialHash() => r'72dac929e33b3dffa065e5a22bbab13c2b2365a6';

/// See also [SsoCredential].
@ProviderFor(SsoCredential)
final ssoCredentialProvider =
    AutoDisposeNotifierProvider<SsoCredential, Credential?>.internal(
  SsoCredential.new,
  name: r'ssoCredentialProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ssoCredentialHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SsoCredential = AutoDisposeNotifier<Credential?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
