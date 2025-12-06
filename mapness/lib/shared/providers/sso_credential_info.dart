import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sso_credential_info.g.dart';

enum SsoEnvironmentType { dev, staging, production }

@riverpod
class SsoEnvironment extends _$SsoEnvironment {
  @override
  SsoEnvironmentType build() => SsoEnvironmentType.dev;
}

@riverpod
class SsoCredential extends _$SsoCredential {
  @override
  Credential? build() {
    final env = ref.watch(ssoEnvironmentProvider);
    return _ssoCredential[env.name];
  }
}

const _ssoCredential = {
  'dev': Credential(
    '1005830086',
    'P@ssw0rd',
    '0000',
  ),
};

class Credential {
  const Credential(this.username, this.password, this.otp);
  final String username;
  final String password;
  final String otp;
}
