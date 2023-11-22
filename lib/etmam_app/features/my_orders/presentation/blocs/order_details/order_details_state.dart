part of 'order_details_bloc.dart';

class OrderDetailsState extends Equatable {
  final BlocStatus status;
  final BlocStatus formStatus;
  final FormDataResponse? formData;
  final OrderDetailsResponse? response;
  final String? errorMessage;

  OrderDetailsState(
      {this.status = BlocStatus.initial,
      this.formStatus = BlocStatus.initial,
      this.response,
      this.formData,
      this.errorMessage});

  OrderDetailsState copyWith(
      {BlocStatus? status,
      OrderDetailsResponse? response,
      BlocStatus? formStatus,
      FormDataResponse? formData,
      String? errorMessage}) {
    return OrderDetailsState(
        response: response ?? this.response,
        status: status ?? this.status,
        formStatus: formStatus ?? this.formStatus,
        formData: formData ?? this.formData,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object> get props => [status, formStatus];
}
