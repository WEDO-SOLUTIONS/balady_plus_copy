part of 'provider_details_bloc.dart';

class ProviderDetailsState extends Equatable {
  BlocStatus status;
  ProviderDetailsResponse args;
  String? errorMessage;
  ProviderDetailsState(
      {this.status = BlocStatus.initial,
      required this.args,
      this.errorMessage});

  ProviderDetailsState copyWith(
      {BlocStatus? status,
      ProviderDetailsResponse? args,
      String? errorMessage}) {
    return ProviderDetailsState(
        args: args ?? this.args,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object> get props => [status];
}
