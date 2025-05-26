import 'body_recipient_info.dart';
import 'submitter_info.dart';





class MainInfo {
  MainInfo({
    this.submitterTypeId,
    this.individualSubmitter,
    this.submitterTypeName,
    this.bodyRecipientInfo,
    this.needSpecialTransport,
    this.submitterInfo,
     this.transportCaseName,
     this.transportCaseId
});

  MainInfo.fromJson(dynamic json) {
    submitterTypeId = json['submitterTypeId'];
    individualSubmitter = json['individualSubmitter'];
    submitterTypeName = json['submitterTypeName'];
    transportCaseName = json['transportCaseName'];
    transportCaseId = json['transportCaseId'];
    bodyRecipientInfo = json['bodyRecipientInfo'] != null ? BodyRecipientInfo.fromJson(json['bodyRecipientInfo']) : null;
    needSpecialTransport = json['needSpecialTransport'];
    submitterInfo = json['submitterInfo'] != null ? SubmitterInfo.fromJson(json['submitterInfo']) : null;
  }
  int? submitterTypeId;
  bool? individualSubmitter;
  String? submitterTypeName;
  String? transportCaseName;
  int? transportCaseId;
  BodyRecipientInfo? bodyRecipientInfo;
  bool? needSpecialTransport;
  SubmitterInfo? submitterInfo;



  MainInfo copyWith({  int? submitterTypeId,
    bool? individualSubmitter,
    String? submitterTypeName,
    String? transportCaseName,
    int? transportCaseId,
    BodyRecipientInfo? bodyRecipientInfo,
    bool? needSpecialTransport,
    SubmitterInfo? submitterInfo,
  }) => MainInfo(  submitterTypeId: submitterTypeId ?? this.submitterTypeId,
    individualSubmitter: individualSubmitter ?? this.individualSubmitter,
    transportCaseName: transportCaseName??this.transportCaseName,
    transportCaseId: transportCaseId??this.transportCaseId,
    submitterTypeName: submitterTypeName ?? this.submitterTypeName,
    bodyRecipientInfo: bodyRecipientInfo ?? this.bodyRecipientInfo,
    needSpecialTransport: needSpecialTransport ?? this.needSpecialTransport,
    submitterInfo: submitterInfo ?? this.submitterInfo,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['submitterTypeId'] = submitterTypeId;
    map['individualSubmitter'] = individualSubmitter;
    map['submitterTypeName'] = submitterTypeName;
    map['transportCaseId'] = transportCaseId;
    if (bodyRecipientInfo != null) {
      map['bodyRecipientInfo'] = bodyRecipientInfo?.toJson();
    }
    map['needSpecialTransport'] = needSpecialTransport;
    if (submitterInfo != null) {
      map['submitterInfo'] = submitterInfo?.toJson();
    }
    return map;
  }

}



