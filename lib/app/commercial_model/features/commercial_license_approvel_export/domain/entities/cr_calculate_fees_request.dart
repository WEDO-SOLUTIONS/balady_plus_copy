class CrCalculateFeesRequest {
  int? requestId;
  int? sadadPeriod;

  CrCalculateFeesRequest({this.requestId, this.sadadPeriod});

  Map<String, dynamic> toMap() {
    return {"sadadPeriod": sadadPeriod};
  }
}
