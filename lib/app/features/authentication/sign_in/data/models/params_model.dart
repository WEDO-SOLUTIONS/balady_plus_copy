import 'package:equatable/equatable.dart' show Equatable;

import '../../../../../core/utils/utils_exports.dart' show ApiParam;

class SignInParamsModel extends Equatable {
  final String? phoneNumber;
  final String? username;
  final String? password;

  const SignInParamsModel({
    required this.phoneNumber,
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [phoneNumber, username, password];

  Map<String, dynamic> get toMap => {
        if (phoneNumber != null) ApiParam.phoneNumber.name: phoneNumber,
        if (password != null) ApiParam.password.name: password,
        if (username != null) ApiParam.username.name: username,
      };
}
