class RenewInfoRequest {
  final int requestId;
  final int licensePeriod;

  RenewInfoRequest({required this.requestId, required this.licensePeriod});

  Map<String, dynamic> toMap() {
    return {
      "licensePeriod": licensePeriod,
    };
  }
}
