class RatingRequest {
  // he is benificiary or engineering office send duflte value is BENIFICIARY
  String origin;
  int? value; // rating number from 0 : 5
  String? remarks; // Comment on rating
  int requestId; //
  int? servicesTypeId; // use with need add rating to spcifc services
  Object? engOfficeId;

  RatingRequest({
    required this.requestId,
    this.servicesTypeId,
    this.engOfficeId,
    this.origin = "BENIFICIARY",
    this.remarks = "",
    this.value = 0,
  });

  factory RatingRequest.fromJson(Map<dynamic, dynamic> json) => RatingRequest(
    origin: json['origin'],
    value: json['value'],
    remarks: json['remarks'],
    servicesTypeId: json['servicesTypeId'],
    requestId: json['requestId'],
    engOfficeId: json['engOfficeId'],
  );

  Map<String, dynamic> toJson() => {
    "origin": origin,
    "value": value,
    "remarks": remarks,
    "requestId": requestId,
    "engOfficeId": engOfficeId,
  };
}
