class SubmitResponse {
  // String message;
  String crNumber;
  String crType;
  String? payUrl;
  // String ratingUrl;
  // bool redirectToPay;
  int requestId;
  // List<String> warningMessages;

  SubmitResponse({
    // required this.message,
    required this.payUrl,
    required this.crNumber,
    required this.crType,
    // required this.ratingUrl,
    // required this.redirectToPay,
    required this.requestId,
    // required this.warningMessages,
  });

  factory SubmitResponse.fromJson(Map<String, dynamic> json) => SubmitResponse(
        crNumber: '',
        crType: '',
        // message: json["message"] ?? '',
        payUrl: json["payUrl"],
        // ratingUrl: json["ratingUrl"] ?? '',
        // redirectToPay: json["redirectToPay"],
        requestId: json["requestId"],
        // warningMessages: json["warningMessages"] != null ? List<String>.from(json["warningMessages"].map((x) => x)) : null,
      );
}
