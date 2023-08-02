part of 'violation_details_bloc.dart';

abstract class ViolationDetailsEvent extends Equatable {
  const ViolationDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetViolationDetailsEvent extends ViolationDetailsEvent {
  final String params;
  const GetViolationDetailsEvent({required this.params});
}
