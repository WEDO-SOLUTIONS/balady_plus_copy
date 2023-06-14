import 'package:equatable/equatable.dart';

class ApigeeTokenResponse extends Equatable {
  ApigeeTokenResponse({
    required this.refreshTokenExpiresIn,
    //required this.apiProductList,
    // required this.apiProductListJson,
    // required this.organizationName,
    // required this.tokenType,
    // required this.issuedAt,
    // required this.clientId,
    required this.accessToken,
    // required this.applicationName,
    // required this.scope,
    required this.expiresIn,
    this.expirationTime,
    // required this.refreshCount,
    // required this.status,
  });
  late final String refreshTokenExpiresIn;
  String? expirationTime;

  //late final String apiProductList;
  //late final List<String> apiProductListJson;
  // late final String organizationName;
  // late final String tokenType;
  //late final String issuedAt;
  // late final String clientId;
  late final String accessToken;
  // late final String applicationName;
  // late final String scope;
  late final String expiresIn;
  // late final String refreshCount;
  // late final String status;

  DateTime getExpireTime() {
    try {
      int durationInSeconds = int.parse(expiresIn);
      DateTime expiresInDate =
          DateTime.now().add(Duration(seconds: durationInSeconds));

      return expiresInDate;
    } catch (ex) {
      print(ex);
      DateTime expiresInDate = DateTime.now().add(Duration(hours: 1));
      return expiresInDate;
    }
  }

  @override
  // TODO: implement props
  List<Object?> get props => [accessToken];
}
