import '../../domain/entities/apigee_token_response.dart';

class ApigeeTokenResponseModel extends ApigeeTokenResponse {
  const ApigeeTokenResponseModel({
    required super.refreshTokenExpiresIn,
    required super.accessToken,
    required super.expiresIn,
  });

  factory ApigeeTokenResponseModel.fromMap(Map<String, dynamic> json) => ApigeeTokenResponseModel(
    refreshTokenExpiresIn: json['refresh_token_expires_in'],
    accessToken: json['access_token'],
    expiresIn: json['expires_in'],
  );
}
