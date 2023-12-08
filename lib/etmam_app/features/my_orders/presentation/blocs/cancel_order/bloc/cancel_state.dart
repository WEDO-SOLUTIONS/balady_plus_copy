part of 'cancel_bloc.dart';

class CancelState extends Equatable {
  BlocStatus status;
  String? errorMessage;
  CancelOrderResponse? response;
  CancelState(
      {this.status = BlocStatus.initial, this.errorMessage, this.response});

  CancelState copyWith(
      {BlocStatus? status,
      String? errorMessage,
      CancelOrderResponse? response}) {
    return CancelState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        response: response ?? this.response);
  }

  @override
  List<Object> get props => [status];
}
