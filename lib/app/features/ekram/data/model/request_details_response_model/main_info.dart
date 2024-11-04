import 'body_recipient_info.dart';
import 'submitter_info.dart';

class MainInfo {
  MainInfo({
    this.individualSubmitter,
    this.requestDate,
    this.requestTime,
    this.bodyRecipientInfo,
    this.needSpecialTransport,
    this.transportCaseId,
    this.transportCaseKey,
    this.transportCaseName,
    this.submitterInfo,});

  MainInfo.fromJson(dynamic json) {
    individualSubmitter = json['individualSubmitter'];
    requestDate = json['requestDate'];
    requestTime = json['requestTime'];
    bodyRecipientInfo = json['bodyRecipientInfo'] != null ? BodyRecipientInfo.fromJson(json['bodyRecipientInfo']) : null;
    needSpecialTransport = json['needSpecialTransport'];
    transportCaseId = json['transportCaseId'];
    transportCaseKey = json['transportCaseKey'];
    transportCaseName = json['transportCaseName'];
    submitterInfo = json['submitterInfo'] != null ? SubmitterInfo.fromJson(json['submitterInfo']) : null;
  }
  bool? individualSubmitter;
  String? requestDate;
  String? requestTime;
  BodyRecipientInfo? bodyRecipientInfo;
  bool? needSpecialTransport;
  int? transportCaseId;
  String? transportCaseKey;
  String? transportCaseName;
  SubmitterInfo? submitterInfo;
  MainInfo copyWith({  bool? individualSubmitter,
    String? requestDate,
    String? requestTime,
    BodyRecipientInfo? bodyRecipientInfo,
    bool? needSpecialTransport,
    int? transportCaseId,
    String? transportCaseKey,
    String? transportCaseName,
    SubmitterInfo? submitterInfo,
  }) => MainInfo(  individualSubmitter: individualSubmitter ?? this.individualSubmitter,
    requestDate: requestDate ?? this.requestDate,
    requestTime: requestTime ?? this.requestTime,
    bodyRecipientInfo: bodyRecipientInfo ?? this.bodyRecipientInfo,
    needSpecialTransport: needSpecialTransport ?? this.needSpecialTransport,
    transportCaseId: transportCaseId ?? this.transportCaseId,
    transportCaseKey: transportCaseKey ?? this.transportCaseKey,
    transportCaseName: transportCaseName ?? this.transportCaseName,
    submitterInfo: submitterInfo ?? this.submitterInfo,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['individualSubmitter'] = individualSubmitter;
    map['requestDate'] = requestDate;
    map['requestTime'] = requestTime;
    if (bodyRecipientInfo != null) {
      map['bodyRecipientInfo'] = bodyRecipientInfo?.toJson();
    }
    map['needSpecialTransport'] = needSpecialTransport;
    map['transportCaseId'] = transportCaseId;
    map['transportCaseKey'] = transportCaseKey;
    map['transportCaseName'] = transportCaseName;
    if (submitterInfo != null) {
      map['submitterInfo'] = submitterInfo?.toJson();
    }
    return map;
  }

}

class SubmitterInfo {
  SubmitterInfo({
    this.fullName,
    this.mobileNumber,
    this.hasIdentity,
    this.baladyClient,
    this.ekramDepartment,
    this.relationship,});

  SubmitterInfo.fromJson(dynamic json) {
    fullName = json['fullName'];
    mobileNumber = json['mobileNumber'];
    hasIdentity = json['hasIdentity'];
    baladyClient = json['baladyClient'];
    ekramDepartment = json['ekramDepartment'];
    relationship = json['relationship'];
  }
  String? fullName;
  String? mobileNumber;
  bool? hasIdentity;
  bool? baladyClient;
  bool? ekramDepartment;
  String? relationship;
  SubmitterInfo copyWith({  String? fullName,
    String? mobileNumber,
    bool? hasIdentity,
    bool? baladyClient,
    bool? ekramDepartment,
    String? relationship,
  }) => SubmitterInfo(  fullName: fullName ?? this.fullName,
    mobileNumber: mobileNumber ?? this.mobileNumber,
    hasIdentity: hasIdentity ?? this.hasIdentity,
    baladyClient: baladyClient ?? this.baladyClient,
    ekramDepartment: ekramDepartment ?? this.ekramDepartment,
    relationship: relationship ?? this.relationship,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fullName'] = fullName;
    map['mobileNumber'] = mobileNumber;
    map['hasIdentity'] = hasIdentity;
    map['baladyClient'] = baladyClient;
    map['ekramDepartment'] = ekramDepartment;
    map['relationship'] = relationship;
    return map;
  }

}

