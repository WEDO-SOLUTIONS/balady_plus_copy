class VerifySalamaRequest {
  int requestId;
  String number;
  VerifySalamaRequest({
    required this.requestId,
    required this.number,
  });

  VerifySalamaRequest copyWith({
    int? requestId,
    String? number,
  }) {
    return VerifySalamaRequest(
      requestId: requestId ?? this.requestId,
      number: number ?? this.number,
    );
  }
}
