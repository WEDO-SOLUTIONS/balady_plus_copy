import 'request_attachments_response.dart';

class ResultList {
  List<RequestAttachmentsResponse>? result;

  ResultList({this.result});

  factory ResultList.fromJson(Map<String, dynamic> json) {
    return ResultList(
      result: (json['result'] as List<dynamic>?)
          ?.map((e) => RequestAttachmentsResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'result': result?.map((e) => e.toJson()).toList(),
      };
}
