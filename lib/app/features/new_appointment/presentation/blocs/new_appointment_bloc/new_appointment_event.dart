part of 'new_appointment_bloc.dart';

abstract class NewAppointmentEvent extends Equatable {
  const NewAppointmentEvent();

  @override
  List<Object> get props => [];
}

class GoToNextPageEvent extends NewAppointmentEvent {
  GoToNextPageEvent();
}

class GoToPreviousPageEvent extends NewAppointmentEvent {
  GoToPreviousPageEvent();
}
