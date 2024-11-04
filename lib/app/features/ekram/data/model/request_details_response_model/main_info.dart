import 'body_recipient_info.dart';
import 'submitter_info.dart';

class MainInfo {
  int? submitterTypeId;
  bool? individualSubmitter;
  String? submitterTypeName;
  BodyRecipientInfo? bodyRecipientInfo;
  bool? needSpecialTransport;
  int? transportCaseId;
  String? transportCaseKey;
  String? transportCaseName;
  SubmitterInfo? submitterInfo;

  MainInfo({
    this.submitterTypeId,
    this.individualSubmitter,
    this.submitterTypeName,
    this.bodyRecipientInfo,
    this.needSpecialTransport,
    this.transportCaseId,
    this.transportCaseKey,
    this.transportCaseName,
    this.submitterInfo,
  });

  factory MainInfo.fromJson(Map<String, dynamic> json) => MainInfo(
        submitterTypeId: json['submitterTypeId'] as int?,
        individualSubmitter: json['individualSubmitter'] as bool?,
        submitterTypeName: json['submitterTypeName'] as String?,
        bodyRecipientInfo: json['bodyRecipientInfo'] == null
            ? null
            : BodyRecipientInfo.fromJson(
                json['bodyRecipientInfo'] as Map<String, dynamic>),
        needSpecialTransport: json['needSpecialTransport'] as bool?,
        transportCaseId: json['transportCaseId'] as int?,
        transportCaseKey: json['transportCaseKey'] as String?,
        transportCaseName: json['transportCaseName'] as String?,
        submitterInfo: json['submitterInfo'] == null
            ? null
            : SubmitterInfo.fromJson(
                json['submitterInfo'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'submitterTypeId': submitterTypeId,
        'individualSubmitter': individualSubmitter,
        'submitterTypeName': submitterTypeName,
        'bodyRecipientInfo': bodyRecipientInfo?.toJson(),
        'needSpecialTransport': needSpecialTransport,
        'transportCaseId': transportCaseId,
        'transportCaseKey': transportCaseKey,
        'transportCaseName': transportCaseName,
        'submitterInfo': submitterInfo?.toJson(),
      };
}
