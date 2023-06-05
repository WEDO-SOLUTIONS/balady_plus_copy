part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object?> get props => [];
}

class SignInOnChangeInfo extends SignInEvent {
  final String? phone;
  final String? username;
  final String? password;

  const SignInOnChangeInfo({this.phone, this.username, this.password});

  @override
  List<Object?> get props => [phone, username, password];
}

class SignInOnShowHidePassword extends SignInEvent {
  const SignInOnShowHidePassword();
}

class OnSignIn extends SignInEvent {
  const OnSignIn();
}
