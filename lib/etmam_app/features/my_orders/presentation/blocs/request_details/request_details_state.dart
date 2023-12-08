part of 'request_details_bloc.dart';

class RequestDetailsState extends Equatable {
  BlocStatus status;
  BlocStatus formStatus;
  RequestDetailsResponse? response;
  String? errorMessage;
  FormDataResponse? formData;
  RequestDetailsState(
      {this.status = BlocStatus.initial,
      this.formStatus = BlocStatus.initial,
      this.response,
      this.errorMessage,
      this.formData});

  RequestDetailsState copyWith(
      {BlocStatus? status,
      RequestDetailsResponse? response,
      String? errorMessage,
      BlocStatus? formStatus,
      FormDataResponse? formData}) {
    return RequestDetailsState(
        response: response ?? this.response,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        formData: formData ?? this.formData,
        formStatus: formStatus ?? this.formStatus);
  }

  @override
  List<Object> get props => [status, formStatus];
}
