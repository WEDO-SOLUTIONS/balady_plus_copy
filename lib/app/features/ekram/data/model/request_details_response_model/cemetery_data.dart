class CemeteryData {
  int? cemeteryId;
  String? cemeteryName;
  int? graveTypeId;
  String? graveTypeName;
  int? graveSizeId;
  String? graveSizeName;
  bool? ghuslInCemetry;

  CemeteryData({
    this.cemeteryId,
    this.cemeteryName,
    this.graveTypeId,
    this.graveTypeName,
    this.graveSizeId,
    this.graveSizeName,
    this.ghuslInCemetry,
  });

  factory CemeteryData.fromJson(Map<String, dynamic> json) => CemeteryData(
        cemeteryId: json['cemeteryId'] as int?,
        cemeteryName: json['cemeteryName'] as String?,
        graveTypeId: json['graveTypeId'] as int?,
        graveTypeName: json['graveTypeName'] as String?,
        graveSizeId: json['graveSizeId'] as int?,
        graveSizeName: json['graveSizeName'] as String?,
        ghuslInCemetry: json['ghuslInCemetry'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'cemeteryId': cemeteryId,
        'cemeteryName': cemeteryName,
        'graveTypeId': graveTypeId,
        'graveTypeName': graveTypeName,
        'graveSizeId': graveSizeId,
        'graveSizeName': graveSizeName,
        'ghuslInCemetry': ghuslInCemetry,
      };


  CemeteryData copyWith({
    int? cemeteryId,
    String? cemeteryName,
    int? graveTypeId,
    String? graveTypeName,
    int? graveSizeId,
    String? graveSizeName,
    bool? ghuslInCemetry,
  }) {
    return CemeteryData(
      cemeteryId:cemeteryId?? this.cemeteryId,
      cemeteryName:cemeteryName??this.cemeteryName,
      graveTypeId:graveTypeId?? this.graveTypeId,
      graveTypeName:graveTypeName?? this.graveTypeName,
      graveSizeId:graveSizeId??this.graveSizeId,
      graveSizeName:graveSizeName??this.graveSizeName,
      ghuslInCemetry:ghuslInCemetry??this.ghuslInCemetry,
    );
  }


  bool isGraveTypeChanged(int? newGraveTypeId) {
    if (newGraveTypeId != null) {
      if (graveTypeId != newGraveTypeId) {
        return true;
      }
    }
    return false;
  }
  bool isCemtryChanged(int? newId) {
    if (newId != null) {
      if (cemeteryId != newId) {
        return true;
      }
    }
    return false;
  }


}
