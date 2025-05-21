import 'dart:convert';

class BaseResponse {
  int code;
  String message;
  BaseData? data;
  String eventName;

  BaseResponse(
      {required this.code,
      required this.message,
      required this.data,
      required this.eventName});

  factory BaseResponse.fromJson(Map<String, dynamic> json, BaseData data) {
    return BaseResponse(
      code: json['code'] as int,
      message: json['message'] as String,
      data: data,
      eventName: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['eventName'] = eventName;
    data['data'] = this.data?.toJson();
    return data;
  }

  String jsonEncodeModel() {
    return jsonEncode(toJson());
  }
}

abstract class BaseData {
  BaseData();

  Map<String, dynamic> toJson();
// BaseData fromJson(Map<String, dynamic> data);
}
