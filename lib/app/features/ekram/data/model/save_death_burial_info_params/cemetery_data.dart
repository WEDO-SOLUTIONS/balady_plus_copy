class CemeteryData {
  int? cemeteryId;
  int? graveTypeId;
  bool? ghuslInCemetry;

  CemeteryData({this.cemeteryId, this.graveTypeId, this.ghuslInCemetry});

  Map<String, dynamic> toJson() => {
        'cemeteryId': cemeteryId,
        'graveTypeId': graveTypeId,
        'ghuslInCemetry': ghuslInCemetry,
      };
}
