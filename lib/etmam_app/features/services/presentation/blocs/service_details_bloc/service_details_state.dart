part of 'service_details_bloc.dart';

class ServiceDetailsState extends Equatable {
  ServiceDetailsResponse response;
  BlocStatus status;
  String? subServiceId;
  String? subServiceName;
  String? errorMessage;
  ServiceDetailsState(
      {required this.response,
      this.status = BlocStatus.initial,
      this.subServiceId,
      this.subServiceName,
      this.errorMessage});

  ServiceDetailsState copyWith(
      {ServiceDetailsResponse? response,
      BlocStatus? status,
      String? subServiceId,
      String? subServiceName,
      String? errorMessage}) {
    return ServiceDetailsState(
        status: status ?? this.status,
        response: response ?? this.response,
        subServiceId: subServiceId ?? this.subServiceId,
        subServiceName: subServiceName ?? this.subServiceName,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object> get props => [status];
}
