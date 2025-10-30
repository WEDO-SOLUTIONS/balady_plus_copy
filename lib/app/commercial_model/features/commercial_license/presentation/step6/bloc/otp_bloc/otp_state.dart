part of 'otp_bloc.dart';

class CommercialOTPState extends Equatable {
  BlocStatus status;
  String? errorMessage;
  // bool? showCounter;
  String? code;
  String mobileNumber;
  // int? start;

  CommercialOTPState({
    this.status = BlocStatus.initial,
    this.errorMessage,
    required this.mobileNumber,
    this.code,
    // this.showCounter,
    // this.start
  });

  CommercialOTPState copyWith({
    final BlocStatus? status,
    final String? errorMessage,
    final String? mobileNumber,
    // final bool? showCounter,
    final String? code,
    //  int? start
  }) {
    return CommercialOTPState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      code: code ?? this.code,
      // showCounter: showCounter ?? this.showCounter,
      // start: start ?? this.start
    );
  }

  @override
  List<Object?> get props => [
        status,
        mobileNumber,
        code,
        // showCounter ?? false,
        // start ?? false
      ];
}
