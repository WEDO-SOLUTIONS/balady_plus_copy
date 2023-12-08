class SubmitRatingResponse {
  String? data;
  String? httpRequestId;
  int? itemsCount;
  int? statusCode;
  String? statusName;
  List<String>? errorList;
  int? responseCode;
  String? responseMessage;

  SubmitRatingResponse(
      {this.responseCode,
      this.responseMessage,
      this.data,
      this.errorList,
      this.httpRequestId,
      this.itemsCount,
      this.statusCode,
      this.statusName});

  factory SubmitRatingResponse.fromJson(Map<String, dynamic> map) {
    if (map["data"] != null) {
      return SubmitRatingResponse(
          /*  errorList: map["data"]["result"]["errorList"]!=null ? List<String>.from(map["result"]["errorList"]
          .map((x) =>x)):null,
          httpRequestId:map["data"]["result"]["httpRequestId"], 
          itemsCount:map["data"]["result"]["itemsCount"],
          statusCode:map["data"]["result"]["statusCode"], 
          statusName:map["data"]["result"]["statusName"],*/
          // data:map["data"]["result"]["data"],
          responseCode: map["data"]["responseCode"],
          responseMessage: map["data"]["responseMessage"]);
    } else {
      return SubmitRatingResponse(responseCode: 2, responseMessage: null);
    }
  }
}
