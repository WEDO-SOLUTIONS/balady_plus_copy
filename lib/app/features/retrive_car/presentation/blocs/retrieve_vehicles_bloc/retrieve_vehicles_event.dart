part of 'retrieve_vehicles_bloc.dart';

abstract class RetrieveVehiclesEvent extends Equatable {
  const RetrieveVehiclesEvent();

  @override
  List<Object> get props => [];
}

class GetMyVehiclesEvent extends RetrieveVehiclesEvent {
  GetMyVehiclesEvent();
}

class ChangeFieldsEvent extends RetrieveVehiclesEvent {
  final String? carOwnerId;
  final String? agentNumber;
  final String? deadId;
  final String? crNumber;
  ChangeFieldsEvent(
      {this.carOwnerId, this.agentNumber, this.deadId, this.crNumber});
}

class GetViehclesEvent extends RetrieveVehiclesEvent {
  GetViehclesEvent();
}

class SelectViehclesEvent extends RetrieveVehiclesEvent {
  final String? id;
  SelectViehclesEvent({this.id});
}
