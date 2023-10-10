part of 'order_details_bloc.dart';

class OrderDetailsState extends Equatable {
  BlocStatus status;
  OrderDetailsResponse? response;
  String? errorMessage;
  OrderDetailsState(
      {this.status = BlocStatus.initial, this.response, this.errorMessage});

  OrderDetailsState copyWith(
      {BlocStatus? status,
      OrderDetailsResponse? response,
      String? errorMessage}) {
    return OrderDetailsState(
        response: response ?? this.response,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object> get props => [status];
}
