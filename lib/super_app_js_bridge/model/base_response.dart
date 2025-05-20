import 'dart:convert';

class BaseResponse {
  int code;
  String message;
  String? eventName;
  BaseData? data;

  BaseResponse({required this.code, this.eventName, required this.message, required this.data});

  factory BaseResponse.fromJson(Map<String, dynamic> json, BaseData data) {
    return BaseResponse(
      code: json['code'] as int,
      message: json['message'] as String,
      eventName: json['eventName'] as String,
      data: data,
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
