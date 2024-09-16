part of 'activites_bloc.dart';

abstract class ActivitesEvent extends Equatable {
  const ActivitesEvent();

  @override
  List<Object?> get props => [];
}

class GetActivitesEvent extends ActivitesEvent {
  const GetActivitesEvent();
}
