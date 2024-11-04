import 'result.dart';

class Data {
  String? responseCode;
  String? responseMessage;
  String? responseId;
  Result? result;

  Data({
    this.responseCode,
    this.responseMessage,
    this.responseId,
    this.result,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        responseCode: json['responseCode'] as String?,
        responseMessage: json['responseMessage'] as String?,
        responseId: json['responseId'] as String?,
        result: json['result'] == null
            ? null
            : Result.fromJson(json['result'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'responseCode': responseCode,
        'responseMessage': responseMessage,
        'responseId': responseId,
        'result': result?.toJson(),
      };
}
