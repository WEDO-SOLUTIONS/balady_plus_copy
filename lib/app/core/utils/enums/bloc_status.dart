enum BlocStatus {
  initial,
  loading,
  closeLoading,
  failure,
  success,
  requestChanged,
  performing,
  retry,
  loaded,
  download,
  success1,
  loadMore,
  loadingShimmer,
  locationPermissionSuceess,
  locationPermissionFailed,
  locationServiceSuceess,
  locationServiceFailed;

  bool get isSubmissionInitial => this == BlocStatus.initial;
  bool get isSubmissionLoading => this == BlocStatus.loading;
  bool get isSubmissionCloseLoading => this == BlocStatus.closeLoading;
  bool get isSubmissionSuccess => this == BlocStatus.success;
  bool get isSubmissionFailure => this == BlocStatus.failure;
  bool get isRequestChanged => this == BlocStatus.requestChanged;
}

enum BlocRequestStatus {
  initial,
  requestChanged,

  submissionGetLoading,
  submissionGetCanceled,
  submissionGetFailure,
  submissionGetSuccess,

  submissionPostLoading,
  submissionPostCanceled,
  submissionPostFailure,
  submissionPostSuccess,

  submissionUpdateLoading,
  submissionUpdateCanceled,
  submissionUpdateFailure,
  submissionUpdateSuccess,

  submissionDeleteLoading,
  submissionDeleteCanceled,
  submissionDeleteFailure,
  submissionDeleteSuccess,
  failure;

  bool get isSubmissionInitial => this == BlocRequestStatus.initial;
  bool get isRequestChanged => this == BlocRequestStatus.requestChanged;

  bool get isSubmissionGetLoading => this == BlocRequestStatus.submissionGetLoading;
  bool get isSubmissionGetCanceled => this == BlocRequestStatus.submissionGetCanceled;
  bool get isSubmissionGetSuccess => this == BlocRequestStatus.submissionGetSuccess;
  bool get isSubmissionGetFailure => this == BlocRequestStatus.submissionGetFailure;

  bool get isSubmissionPostLoading => this == BlocRequestStatus.submissionPostLoading;
  bool get isSubmissionPostCanceled => this == BlocRequestStatus.submissionPostCanceled;
  bool get isSubmissionPostSuccess => this == BlocRequestStatus.submissionPostSuccess;
  bool get isSubmissionPostFailure => this == BlocRequestStatus.submissionPostFailure;

  bool get isSubmissionUpdateLoading => this == BlocRequestStatus.submissionUpdateLoading;
  bool get isSubmissionUpdateCanceled => this == BlocRequestStatus.submissionUpdateCanceled;
  bool get isSubmissionUpdateSuccess => this == BlocRequestStatus.submissionUpdateSuccess;
  bool get isSubmissionUpdateFailure => this == BlocRequestStatus.submissionUpdateFailure;

  bool get isSubmissionDeleteLoading => this == BlocRequestStatus.submissionDeleteLoading;
  bool get isSubmissionDeleteCanceled => this == BlocRequestStatus.submissionPostCanceled;
  bool get isSubmissionDeleteSuccess => this == BlocRequestStatus.submissionDeleteSuccess;
  bool get isSubmissionDeleteFailure => this == BlocRequestStatus.submissionDeleteFailure;
}
