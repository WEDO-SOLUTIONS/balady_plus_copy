import 'submitter_info.dart';

class MainInfo {
  bool? individualSubmitter;
  String? requestDate;
  String? requestTime;
  bool? needSpecialTransport;
  int? transportCaseId;
  SubmitterInfo? submitterInfo;

  MainInfo({
    this.individualSubmitter,
    this.requestDate,
    this.requestTime,
    this.needSpecialTransport,
    this.transportCaseId,
    this.submitterInfo,
  });

  factory MainInfo.fromJson(Map<String, dynamic> json) => MainInfo(
        individualSubmitter: json['individualSubmitter'] as bool?,
        requestDate: json['requestDate'] as String?,
        requestTime: json['requestTime'] as String?,
        needSpecialTransport: json['needSpecialTransport'] as bool?,
        transportCaseId: json['transportCaseId'] as int?,
        submitterInfo: json['submitterInfo'] == null
            ? null
            : SubmitterInfo.fromJson(
                json['submitterInfo'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'individualSubmitter': individualSubmitter,
        'requestDate': requestDate,
        'requestTime': requestTime,
        'needSpecialTransport': needSpecialTransport,
        'transportCaseId': transportCaseId,
        'submitterInfo': submitterInfo?.toJson(),
      };

  MainInfo copyWith({
    bool? individualSubmitter,
    String? requestDate,
    String? requestTime,
    bool? needSpecialTransport,
    int? transportCaseId,
    SubmitterInfo? submitterInfo,
  }) {
    return MainInfo(
      individualSubmitter: individualSubmitter ?? this.individualSubmitter,
      requestDate: requestDate ?? this.requestDate,
      requestTime: requestTime ?? this.requestTime,
      needSpecialTransport: needSpecialTransport ?? this.needSpecialTransport,
      transportCaseId: transportCaseId ?? this.transportCaseId,
      submitterInfo: submitterInfo ?? this.submitterInfo,
    );
  }
}
