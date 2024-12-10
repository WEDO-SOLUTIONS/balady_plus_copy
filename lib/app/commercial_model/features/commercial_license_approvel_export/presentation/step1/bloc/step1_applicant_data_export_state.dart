part of 'step1_applicant_data_export_cubit.dart';

class Step1ApplicantDataExportState extends Equatable {
  final RecordInfo? recordInfo;
  final BlocStatus recordStatus;
  final BlocStatus addIsicActivitiesStatus;
  final BlocStatus status;
  final int? requestId;
  final String errorMessage;
  final List<IsicsMainActivity>? lstMainActivity;

  const Step1ApplicantDataExportState({
    this.recordInfo,
    this.recordStatus = BlocStatus.initial,
    this.addIsicActivitiesStatus = BlocStatus.initial,
    this.status = BlocStatus.initial,
    this.requestId,
    this.lstMainActivity,
    this.errorMessage = '',
  });

  List<IsicActivity> get isicActivitiesNotExistInBalady {
    final List<IsicActivity> activities = [];
    if (recordInfo?.crInfo?.activities!.isicActivities != null) {
      for (var item in recordInfo!.crInfo!.activities!.isicActivities!) {
        if (item.existInBalady ?? false) {
        } else {
          activities.add(item);
        }
      }
    }
    return activities;
  }

  List<IsicActivity> get isicActivitiesExistInBalady {
    final List<IsicActivity> activities = [];
    if (recordInfo?.crInfo?.activities!.isicActivities != null) {
      for (var item in recordInfo!.crInfo!.activities!.isicActivities!) {
        if (item.existInBalady ?? false) activities.add(item);
      }
    }
    return activities;
  }

  @override
  List<Object?> get props =>
      [recordInfo, recordStatus, addIsicActivitiesStatus, errorMessage, status,lstMainActivity];

  Step1ApplicantDataExportState copyWith({
    RecordInfo? recordInfo,
    BlocStatus? recordStatus,
    BlocStatus? status,
    BlocStatus? addIsicActivitiesStatus,
    List<IsicsMainActivity>? lstMainActivity,
    int? requestId,
    String? errorMessage,
  }) {
    return Step1ApplicantDataExportState(
        recordInfo: recordInfo ?? this.recordInfo,
        recordStatus: recordStatus ?? this.recordStatus,
        addIsicActivitiesStatus:
            addIsicActivitiesStatus ?? this.addIsicActivitiesStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        requestId: requestId ?? this.requestId,
        lstMainActivity: lstMainActivity ?? this.lstMainActivity,

        status: status ?? this.status);
  }

  List<IsicsMainActivity> getIsicActivities() {

    return lstMainActivity
            ?.where((element) => element.existInBalady == true)
            .toList() ??
        [];
  }
}
