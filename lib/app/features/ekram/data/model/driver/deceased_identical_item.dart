class DeceasedIdenticalItem {
  DeceasedIdenticalItem({
      this.requestId, 
      this.subMunicipalityName, 
      this.municipalityName, 
      this.charityName, 
      this.deceasedIdentityTypeName, 
      this.deceasedIdentityId, 
      this.deceasedNationalityName, 
      this.deceasedName, 
      this.deathCityName, 
      this.burialCityName, 
      this.cemeteryName, 
      this.hospitalName, 
      this.gender, 
      this.isMuslim, 
      this.requestDate, 
      this.assignDriverDate, 
      this.deathDate, 
      this.burialDate, 
      this.vehicleName, 
      this.vehicleBrand, 
      this.driverName, 
      this.driverMobile, 
      this.transportCaseName, 
      this.requestStatusId, 
      this.requestStatusName, 
      this.currentTrip, 
      this.nextTrip, 
      this.bodyRecipientName, 
      this.bodyRecipientMobile, 
      this.needSpecialTransport, 
      this.specialTransportReasonId, 
      this.specialTransportReasonName, 
      this.specialTransportReasonOther, 
      this.cancelable, 
      this.editable, 
      this.assignable, 
      this.tripable, 
      this.draft, 
      this.transferring, 
      this.done,
    this.ghuslEmployeeRequired,
    this.ghuslEmployeeIdentityNo,
    this.ghuslEmployeeName,
    this.ghuslable,

  });

  DeceasedIdenticalItem.fromJson(dynamic json) {
    requestId = json['requestId'];
    subMunicipalityName = json['subMunicipalityName'];
    municipalityName = json['municipalityName'];
    charityName = json['charityName'];
    deceasedIdentityTypeName = json['deceasedIdentityTypeName'];
    deceasedIdentityId = json['deceasedIdentityId'];
    deceasedNationalityName = json['deceasedNationalityName'];
    deceasedName = json['deceasedName'];
    deathCityName = json['deathCityName'];
    burialCityName = json['burialCityName'];
    cemeteryName = json['cemeteryName'];
    hospitalName = json['hospitalName'];
    gender = json['gender'];
    isMuslim = json['isMuslim'];
    requestDate = json['requestDate'];
    assignDriverDate = json['assignDriverDate'];
    deathDate = json['deathDate'];
    burialDate = json['burialDate'];
    vehicleName = json['vehicleName'];
    vehicleBrand = json['vehicleBrand'];
    driverName = json['driverName'];
    driverMobile = json['driverMobile'];
    transportCaseName = json['transportCaseName'];
    requestStatusId = json['requestStatusId'];
    requestStatusName = json['requestStatusName'];
    currentTrip = json['currentTrip'];
    nextTrip = json['nextTrip'];
    bodyRecipientName = json['bodyRecipientName'];
    bodyRecipientMobile = json['bodyRecipientMobile'];
    needSpecialTransport = json['needSpecialTransport'];
    specialTransportReasonId = json['specialTransportReasonId'];
    specialTransportReasonName = json['specialTransportReasonName'];
    specialTransportReasonOther = json['specialTransportReasonOther'];
    cancelable = json['cancelable'];
    editable = json['editable'];
    assignable = json['assignable'];
    tripable = json['tripable'];
    draft = json['draft'];
    transferring = json['transferring'];
    done = json['done'];
    ghuslEmployeeRequired = json['ghuslEmployeeRequired'];
    ghuslEmployeeIdentityNo = json['ghuslEmployeeIdentityNo'];
    ghuslEmployeeName = json['ghuslEmployeeName'];
    ghuslable = json['ghuslable'];



  }
  int? requestId;
  dynamic subMunicipalityName;
  String? municipalityName;
  String? charityName;
  String? deceasedIdentityTypeName;
  String? deceasedIdentityId;
  String? deceasedNationalityName;
  String? deceasedName;
  String? deathCityName;
  String? burialCityName;
  String? cemeteryName;
  String? hospitalName;
  String? gender;
  bool? isMuslim;
  String? requestDate;
  String? assignDriverDate;
  String? deathDate;
  String? burialDate;
  dynamic vehicleName;
  String? vehicleBrand;
  String? driverName;
  String? driverMobile;
  String? transportCaseName;
  int? requestStatusId;
  String? requestStatusName;
  dynamic currentTrip;
  dynamic nextTrip;
  dynamic bodyRecipientName;
  dynamic bodyRecipientMobile;
  bool? needSpecialTransport;
  dynamic specialTransportReasonId;
  dynamic specialTransportReasonName;
  dynamic specialTransportReasonOther;
  bool? cancelable;
  bool? editable;
  bool? assignable;
  bool? tripable;
  bool? draft;
  bool? transferring;
  bool? done;
  bool? ghuslEmployeeRequired;
  String? ghuslEmployeeIdentityNo;
  String? ghuslEmployeeName;
  bool? ghuslable;



  String getSpecialTransferReason() {
    if (needSpecialTransport == true) {
      if (specialTransportReasonOther?.isNotEmpty ?? false) {
        return specialTransportReasonOther ?? "";
      }
      return specialTransportReasonName ?? "";
    }
    return "";
  }

}