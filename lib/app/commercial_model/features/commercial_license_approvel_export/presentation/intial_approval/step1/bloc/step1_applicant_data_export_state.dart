part of 'step1_applicant_data_export_cubit.dart';

class Step1ApplicantDataExportState extends Equatable {
  final RequestDetailsModel? requestDetails;
  final BlocStatus recordStatus;
  final BlocStatus addIsicActivitiesStatus;
  final BlocStatus status;
  final int? requestId;
  final String errorMessage;
  final List<IsicsMainActivity>? lstMainActivity;

  const Step1ApplicantDataExportState({
    this.requestDetails,
    this.recordStatus = BlocStatus.initial,
    this.addIsicActivitiesStatus = BlocStatus.initial,
    this.status = BlocStatus.initial,
    this.requestId,
    this.lstMainActivity,
    this.errorMessage = '',
  });

  List<IsicsMainActivity> get isicActivitiesNotExistInBalady {
    final List<IsicsMainActivity> activities = [];
    if (lstMainActivity!= null) {
      for (var item in lstMainActivity!) {
        if (item.existInBalady ?? false) {
        } else {
          activities.add(item);
        }
      }
    }
    return activities;
  }

  List<IsicsMainActivity> get isicActivitiesExistInBalady {
    final List<IsicsMainActivity> activities = [];
    if (lstMainActivity != null) {
      for (var item in lstMainActivity!) {
        if (item.existInBalady ?? false) activities.add(item);
      }
    }
    return activities;
  }

  @override
  List<Object?> get props =>
      [requestDetails, recordStatus, addIsicActivitiesStatus, errorMessage, status,lstMainActivity];

  Step1ApplicantDataExportState copyWith({
    RequestDetailsModel? recordInfo,
    BlocStatus? recordStatus,
    BlocStatus? status,
    BlocStatus? addIsicActivitiesStatus,
    List<IsicsMainActivity>? lstMainActivity,
    int? requestId,
    String? errorMessage,
  }) {
    return Step1ApplicantDataExportState(
        requestDetails: recordInfo ?? this.requestDetails,
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
