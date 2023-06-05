import 'package:equatable/equatable.dart' show Equatable;

import '../../../_shared_feature_/shared_feature_exports.dart' show AuthData;

class EntryPointParams extends Equatable {
  final String key;
  final AuthData? authData;

  const EntryPointParams({this.key = '', this.authData});

  @override
  List<Object?> get props => [key, authData];

  EntryPointParams copyWith({
    String? key,
    AuthData? authData,
  }) {
    return EntryPointParams(
      key: key ?? this.key,
      authData: authData ?? this.authData,
    );
  }

  @override
  String toString() => 'EntryPointParams(key: $key, authData: $authData)';
}
