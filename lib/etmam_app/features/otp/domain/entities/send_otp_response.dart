import 'package:equatable/equatable.dart';

class SendOTPResponse extends Equatable {
  String? otpId;
  int? expireSeconds;

  SendOTPResponse({this.expireSeconds, this.otpId});

  @override
  List<Object?> get props => [otpId];
}
