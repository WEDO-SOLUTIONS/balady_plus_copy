part of 'cr_step1_applicant_data_cubit.dart';

class CrStep1ApplicantDataState extends Equatable {
  final RecordInfo? recordInfo;
  final BlocStatus recordStatus;
  final BlocStatus addIsicActivitiesStatus;
  final String errorMessage;

  const CrStep1ApplicantDataState({
    this.recordInfo,
    this.recordStatus = BlocStatus.initial,
    this.addIsicActivitiesStatus = BlocStatus.initial,
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
  List<Object?> get props => [
        recordInfo,
        recordStatus,
        addIsicActivitiesStatus,
        errorMessage,
      ];

  CrStep1ApplicantDataState copyWith({
    RecordInfo? recordInfo,
    BlocStatus? recordStatus,
    BlocStatus? addIsicActivitiesStatus,
    String? errorMessage,
  }) {
    return CrStep1ApplicantDataState(
      recordInfo: recordInfo ?? this.recordInfo,
      recordStatus: recordStatus ?? this.recordStatus,
      addIsicActivitiesStatus:
          addIsicActivitiesStatus ?? this.addIsicActivitiesStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  List<IsicActivity> getIsicActivities() {
    return recordInfo?.crInfo?.activities?.isicActivities
            ?.where((element) => element.existInBalady == true)
            .toList() ??
        [];
  }
}
