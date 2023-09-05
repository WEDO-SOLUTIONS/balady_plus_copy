class SendOtpResponse {
  final String? otpId;
  final String? tokenId;
  final int? expireSeconds;
  final int? timeoutInSeconds;

  SendOtpResponse({
    this.otpId,
    this.tokenId,
    this.expireSeconds,
    this.timeoutInSeconds,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) =>
      SendOtpResponse(
        otpId: json["otpId"],
        tokenId: json["tokenId"],
        expireSeconds: json["expireSeconds"],
        timeoutInSeconds: json["timeoutInSeconds"],
      );

  Map<String, dynamic> toJson() => {
        "otpId": otpId,
        "tokenId": tokenId,
        "expireSeconds": expireSeconds,
        "timeoutInSeconds": timeoutInSeconds,
      };
}
