part of 'permits_bloc.dart';

abstract class PermitsEvent extends Equatable {
  const PermitsEvent();

  @override
  List<Object?> get props => [];
}

class GetPermitsEvent extends PermitsEvent {
  const GetPermitsEvent();
}

class TogglePermitEvent extends PermitsEvent {
  final int index;
  const TogglePermitEvent({required this.index});
}
