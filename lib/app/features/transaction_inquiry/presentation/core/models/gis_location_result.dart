class GisLocationResult {
  String? adminMunicipalityId;
  String? adminMunicipalityName;
  String? cleanInfo;
  String? districtId;
  String? districtName;
  String? following;
  String? lightInfo;
  String? municipalityId;
  String? municipalityName;
  String? region;
  String? streetName;
  String? subDistrictId;
  String? subDistrictName;
  String? subMunicipalityId;
  String? subMunicipalityName;
  String? sub_Municipalityguid;
  String? MUNICIPALITYUNIQUECODE;
  bool? isSuccessfull;
  dynamic ErrorCode;
  bool? vdExcepted;
  bool? vdPriority;
  String? Balady_DistrictID;
  String? Balady_DistrictName;

  GisLocationResult(
      {this.adminMunicipalityId,
      this.adminMunicipalityName,
      this.cleanInfo,
      this.districtId,
      this.districtName,
      this.following,
      this.lightInfo,
      this.municipalityId,
      this.municipalityName,
      this.region,
      this.streetName,
      this.subDistrictId,
      this.subDistrictName,
      this.subMunicipalityId,
      this.subMunicipalityName,
      this.sub_Municipalityguid,
      this.isSuccessfull,
      this.MUNICIPALITYUNIQUECODE,
      this.ErrorCode,
      this.vdExcepted,
      this.vdPriority,
      this.Balady_DistrictID,
      this.Balady_DistrictName});

  factory GisLocationResult.fromJson(Map<String, dynamic> json) {
    bool isSucessful = json['IsSuccessfull'] ?? true;

    if (isSucessful) {
      return GisLocationResult(
          Balady_DistrictName: json['Contents']["Balady_DistrictName"],
          adminMunicipalityId: json['Contents']["Admin_MunicipalityID"],
          adminMunicipalityName: json['Contents']["Admin_MunicipalityName"],
          // cleanInfo: json['Contents']["CleanInfo"],
          districtId: json['Contents']["DistrictID"],
          districtName: json['Contents']["DistrictName"],
          following: json['Contents']["Following"],
          //lightInfo: json['Contents']["LightInfo"],
          municipalityId: json['Contents']["MunicipalityID"],
          municipalityName: json['Contents']["MunicipalityName"],
          region: json['Contents']["Region"],
          streetName: json['Contents']["StreetName"],
          subDistrictId: json['Contents']["SubDistrictID"],
          subDistrictName: json['Contents']["SubDistrictName"],
          subMunicipalityId: json['Contents']["Sub_MunicipalityID"],
          subMunicipalityName: json['Contents']["Sub_MunicipalityName"],
          sub_Municipalityguid: json['Contents']["Sub_Municipalityguid"],
          MUNICIPALITYUNIQUECODE: json['Contents']["MUNICIPALITYUNIQUECODE"],
          vdExcepted: json['Contents']["vdExcepted"],
          vdPriority: json['Contents']["vdPriority"],
          Balady_DistrictID: json['Contents']["Balady_DistrictID"],
          isSuccessfull: json["IsSuccessfull"] ?? true);
    } else {
      return GisLocationResult(
          isSuccessfull: json["IsSuccessfull"], ErrorCode: json["ErrorCode"]);
    }
  }

  Map<String, dynamic> toJson() => {
        "Admin_MunicipalityID": adminMunicipalityId,
        "Admin_MunicipalityName": adminMunicipalityName,
        "CleanInfo": cleanInfo,
        "DistrictID": districtId,
        "DistrictName": districtName,
        "Following": following,
        "LightInfo": lightInfo,
        "MunicipalityID": municipalityId,
        "MunicipalityName": municipalityName,
        "Region": region,
        "StreetName": streetName,
        "SubDistrictID": subDistrictId,
        "SubDistrictName": subDistrictName,
        "Sub_MunicipalityID": subMunicipalityId,
        "Sub_MunicipalityName": subMunicipalityName,
        "vdExcepted": vdExcepted,
        "vdPriority": vdPriority,
      };

  String getFullAddress() {
    String address = "";
    var streetName = this.streetName;
    var districtName = this.districtName;
    var subMunicipalityName = this.subMunicipalityName;
    var adminMunicipalityName = this.adminMunicipalityName;

    if (streetName != null &&
        streetName.toLowerCase() != "null" &&
        streetName.isNotEmpty) address += streetName + ", ";

    if (districtName != null &&
        districtName.toLowerCase() != "null" &&
        districtName.isNotEmpty) address += districtName + ", ";

    if (subMunicipalityName != null &&
        subMunicipalityName.toLowerCase() != "null" &&
        subMunicipalityName.isNotEmpty) address += subMunicipalityName + ", ";

    if (adminMunicipalityName != null && adminMunicipalityName.isNotEmpty) {
      address += adminMunicipalityName;
    }

    return address;
  }

  bool isVDExcepted() {
    return vdExcepted ?? false;
  }
}
