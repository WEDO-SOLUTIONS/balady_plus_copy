part of 'step1_applicant_data_export_cubit.dart';

class Step1ApplicantDataExportState extends Equatable {
  final RecordInfo? recordInfo;
  final BlocStatus recordStatus;
  final BlocStatus addIsicActivitiesStatus;
  final BlocStatus status;

  final String errorMessage;

  const Step1ApplicantDataExportState({
    this.recordInfo,
    this.recordStatus = BlocStatus.initial,
    this.addIsicActivitiesStatus = BlocStatus.initial,
    this.status = BlocStatus.initial,
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
      [recordInfo, recordStatus, addIsicActivitiesStatus, errorMessage, status];

  Step1ApplicantDataExportState copyWith({
    RecordInfo? recordInfo,
    BlocStatus? recordStatus,
    BlocStatus? status,
    BlocStatus? addIsicActivitiesStatus,
    String? errorMessage,
  }) {
    return Step1ApplicantDataExportState(
        recordInfo: recordInfo ?? this.recordInfo,
        recordStatus: recordStatus ?? this.recordStatus,
        addIsicActivitiesStatus:
            addIsicActivitiesStatus ?? this.addIsicActivitiesStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        status: status ?? this.status);
  }

  List<IsicActivity> getIsicActivities() {
    return recordInfo?.crInfo?.activities?.isicActivities
            ?.where((element) => element.existInBalady == true)
            .toList() ??
        [];
  }
}
