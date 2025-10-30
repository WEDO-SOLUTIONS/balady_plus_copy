part of 'new_health_certificate_bloc.dart';

abstract class NewHealthCertificateEvent extends Equatable {
  const NewHealthCertificateEvent();

  @override
  List<Object> get props => [];
}

class GoToNextPageEvent extends NewHealthCertificateEvent {
  GoToNextPageEvent();
}

class GoToPreviousPageEvent extends NewHealthCertificateEvent {
  GoToPreviousPageEvent();
}
