enum BlocStatus {
  initial,
  loading,
  closeLoading,
  failure,
  success,
  requestChanged,
  ;

  bool get isInitial => this == BlocStatus.initial;

  bool get isLoading => this == BlocStatus.loading;

  bool get isCloseLoading => this == BlocStatus.closeLoading;

  bool get isSuccess => this == BlocStatus.success;

  bool get isFailure => this == BlocStatus.failure;

  bool get isRequestChanged => this == BlocStatus.requestChanged;
}
