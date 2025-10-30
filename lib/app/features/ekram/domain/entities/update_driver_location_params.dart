class UpdateDriverLocationParams {
  //int deadInfoRecordId;
  double x;
  double y;

  UpdateDriverLocationParams(
      { //required this.deadInfoRecordId,

      required this.x,
      required this.y});

  Map<String, dynamic> toMap() => {
        //"deadInfoRecordId": deadInfoRecordId,
        "x": x, "y": y
      };
}
