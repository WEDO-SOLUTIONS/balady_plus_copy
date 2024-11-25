class CrSubmitRequest {
  int? requestId;
  int? sadadPeriod;
  CrSubmitRequest({this.sadadPeriod, this.requestId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{"sadadPeriod": sadadPeriod};
  }
}
