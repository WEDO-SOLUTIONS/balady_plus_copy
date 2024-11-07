
class MadinahEmirateApprovalStatusResponseModel {
  String? firstName;
  String? secondName;
  String? thirdName;
  String? fourthName;
  bool? hasIdentity;
  bool? baladyClient;
  int? approvalStatusId;
  String? approvalStatusName;
  String? approvalDate;
  bool? valid;
  String? message;
  int? cemeteryId;
  String? cemeteryName;

  MadinahEmirateApprovalStatusResponseModel({this.firstName, this.secondName, this.thirdName, this.fourthName, this.hasIdentity, this.baladyClient, this.approvalStatusId, this.approvalStatusName, this.approvalDate, this.valid, this.message, this.cemeteryId, this.cemeteryName});

  MadinahEmirateApprovalStatusResponseModel.fromJson(Map<String, dynamic> json) {
    if(json["firstName"] is String) {
      firstName = json["firstName"];
    }
    if(json["secondName"] is String) {
      secondName = json["secondName"];
    }
    if(json["thirdName"] is String) {
      thirdName = json["thirdName"];
    }
    if(json["fourthName"] is String) {
      fourthName = json["fourthName"];
    }
    if(json["hasIdentity"] is bool) {
      hasIdentity = json["hasIdentity"];
    }
    if(json["baladyClient"] is bool) {
      baladyClient = json["baladyClient"];
    }
    if(json["approvalStatusId"] is int) {
      approvalStatusId = json["approvalStatusId"];
    }
    if(json["approvalStatusName"] is String) {
      approvalStatusName = json["approvalStatusName"];
    }
    if(json["approvalDate"] is String) {
      approvalDate = json["approvalDate"];
    }
    if(json["valid"] is bool) {
      valid = json["valid"];
    }
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["cemeteryId"] is int) {
      cemeteryId = json["cemeteryId"];
    }
    if(json["cemeteryName"] is String) {
      cemeteryName = json["cemeteryName"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["firstName"] = firstName;
    _data["secondName"] = secondName;
    _data["thirdName"] = thirdName;
    _data["fourthName"] = fourthName;
    _data["hasIdentity"] = hasIdentity;
    _data["baladyClient"] = baladyClient;
    _data["approvalStatusId"] = approvalStatusId;
    _data["approvalStatusName"] = approvalStatusName;
    _data["approvalDate"] = approvalDate;
    _data["valid"] = valid;
    _data["message"] = message;
    _data["cemeteryId"] = cemeteryId;
    _data["cemeteryName"] = cemeteryName;
    return _data;
  }
}