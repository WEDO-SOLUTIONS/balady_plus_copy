part of 'violation_details_bloc.dart';

abstract class ViolationDetailsEvent extends Equatable {
  const ViolationDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetViolationDetailsEvent extends ViolationDetailsEvent {
  final String id;
  final String applicationId;
  const GetViolationDetailsEvent(
      {required this.id, required this.applicationId,});
}

class GetObjectionDetailsEvent extends ViolationDetailsEvent {
  final String params;
  GetObjectionDetailsEvent({required this.params});
}

class GetGisLocationInfoEvent extends ViolationDetailsEvent {
  final double? lat;
  final double? lon;
  const GetGisLocationInfoEvent({this.lat, this.lon});
}

class ValidateObjectionDetailsTransactions extends ViolationDetailsEvent {
  const ValidateObjectionDetailsTransactions();
}
