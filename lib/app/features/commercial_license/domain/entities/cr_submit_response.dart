class CrSubmitResponse {
  int? requestId;
  String? message;
  bool? redirectToPay;
  String? accountNumber;
  String? payUrl;

  CrSubmitResponse(
      {this.message,
      this.redirectToPay,
      this.accountNumber,
      this.payUrl,
      this.requestId});
}
