import '../../../../../core/utils/utils_exports.dart' show JsonConversion;
import '../../shared_feature_exports.dart' show AuthData;

const _accessToken = "accessToken";

class AuthDataModel extends AuthData {
  const AuthDataModel({required super.accessToken});

  Map<String, dynamic> toMap() => {
        _accessToken: "XXXXXXXXXXXXXXXXXXXXXX",
      };

  factory AuthDataModel.fromMap(Map<String, dynamic> map) => AuthDataModel(
        accessToken: map[_accessToken] ?? '',
      );

  String toJson() => toMap().toJson();

  factory AuthDataModel.fromJson(String source) =>
      AuthDataModel.fromMap(source.fromJson());
}

extension AuthDataModelFromEntity on AuthData {
  AuthDataModel get toModel => AuthDataModel(accessToken: accessToken);
}
