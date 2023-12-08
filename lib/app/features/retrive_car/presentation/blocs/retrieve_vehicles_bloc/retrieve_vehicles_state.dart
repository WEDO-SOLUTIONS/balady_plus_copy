part of 'retrieve_vehicles_bloc.dart';

class RetrieveVehiclesState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final int? pageCount;
  final List<VehicleItem>? vehicleItem;
  final String? carOwnerId;
  final String? agentNumber;
  final String? deadId;
  final String? crNumber;
  final String? type;
  final VehicleItem? selectedVehicle;
  RetrieveVehiclesState(
      {this.status = BlocStatus.initial,
      this.errorMessage,
      this.pageCount,
      this.vehicleItem,
      this.carOwnerId,
      this.agentNumber,
      this.deadId,
      this.crNumber,
      this.type,
      this.selectedVehicle});

  RetrieveVehiclesState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      final int? pageCount,
      final List<VehicleItem>? vehicleItem,
      final String? carOwnerId,
      final String? agentNumber,
      final String? deadId,
      final String? crNumber,
      final String? type,
      final VehicleItem? selectedVehicle}) {
    return RetrieveVehiclesState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        pageCount: pageCount ?? this.pageCount,
        vehicleItem: vehicleItem ?? this.vehicleItem,
        carOwnerId: carOwnerId ?? this.carOwnerId,
        agentNumber: agentNumber ?? this.agentNumber,
        deadId: deadId ?? this.deadId,
        crNumber: crNumber ?? this.crNumber,
        type: type ?? this.type,
        selectedVehicle: selectedVehicle ?? this.selectedVehicle);
  }

  @override
  List<Object?> get props => [
        status,
        carOwnerId,
        errorMessage,
        pageCount,
        vehicleItem,
        crNumber,
        deadId,
        agentNumber,
        selectedVehicle
      ];

  bool isFormValid() {
    if (type == "Agent") {
      if (agentNumber != null && carOwnerId != null) return true;
    }
    if (type == "Owner/ManagerOfTheFacility") {
      if (crNumber != null) return true;
    }
    if (type == "OnBehalfOfDeadPerson") {
      if (deadId != null) return true;
    }
    return false;
  }
}
