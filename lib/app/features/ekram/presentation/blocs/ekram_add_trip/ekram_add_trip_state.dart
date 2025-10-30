part of 'ekram_add_trip_bloc.dart';

class EkramAddTripState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;

  final String? currentTripStationArrivalTime;
  final int? currentTripStationId;
  final double? currentTripStationLocationX;
  final double? currentTripStationLocationY;
  final String? currentTripStationName;
  final int? currentTripStationTypeId;

  final String? nextTripStationArrivalTime;
  final int? nextTripStationId;
  final double? nextTripStationLocationX;
  final double? nextTripStationLocationY;
  final String? nextTripStationName;
  final LookUpItem? nextTripStationTypeId;
  final int? requestProcessId;

  final AddTripDialogParams data;
  final List<LookUpItem>? nextStationType;

  final LookUpItem? nextHospitalStation;
  final LookUpItem? nextMosqueStation;
  final LookUpItem? nextLaundryStation;

  final List<LookUpItemLocation>? mosques;
  final List<LookUpItemLocation>? launduries;

  final List<LookUpItem>? hospitals;
  final List<LookUpItem>? mosquesList;
  final List<LookUpItem>? launduriesList;
  const EkramAddTripState(
      {this.status = BlocStatus.initial,
      this.errorMessage,
      required this.data,
      this.nextHospitalStation,
      this.nextMosqueStation,
      this.nextLaundryStation,
      this.currentTripStationArrivalTime,
      this.currentTripStationId,
      this.currentTripStationLocationX,
      this.currentTripStationLocationY,
      this.currentTripStationName,
      this.currentTripStationTypeId,
      this.nextTripStationArrivalTime,
      this.nextTripStationId,
      this.nextTripStationLocationX,
      this.nextTripStationLocationY,
      this.nextTripStationName,
      this.nextTripStationTypeId,
      this.requestProcessId,
      this.nextStationType,
      this.mosques,
      this.launduries,
      this.hospitals,
      this.mosquesList,
      this.launduriesList});
  EkramAddTripState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      final String? currentTripStationArrivalTime,
      final int? currentTripStationId,
      final double? currentTripStationLocationX,
      final double? currentTripStationLocationY,
      final String? currentTripStationName,
      final int? currentTripStationTypeId,
      final String? nextTripStationArrivalTime,
      final int? nextTripStationId,
      final double? nextTripStationLocationX,
      final double? nextTripStationLocationY,
      final String? nextTripStationName,
      final LookUpItem? nextTripStationTypeId,
      final int? requestProcessId,
      final AddTripDialogParams? data,
      final LookUpItem? nextHospitalStation,
      final LookUpItem? nextMosqueStation,
      final LookUpItem? nextLaundryStation,
      final List<LookUpItem>? nextStationType,
      final List<LookUpItemLocation>? mosques,
      final List<LookUpItemLocation>? launduries,
      final List<LookUpItem>? hospitals,
      final List<LookUpItem>? mosquesList,
      final List<LookUpItem>? launduriesList,
      final bool clearNextStation = false}) {
    return EkramAddTripState(
        data: data ?? this.data,
        errorMessage: errorMessage ?? this.errorMessage,
        status: status ?? this.status,
        currentTripStationArrivalTime:
            currentTripStationArrivalTime ?? this.currentTripStationArrivalTime,
        currentTripStationId: currentTripStationId ?? this.currentTripStationId,
        currentTripStationLocationX:
            currentTripStationLocationX ?? this.currentTripStationLocationX,
        currentTripStationLocationY:
            currentTripStationLocationY ?? this.currentTripStationLocationY,
        currentTripStationName:
            currentTripStationName ?? this.currentTripStationName,
        currentTripStationTypeId:
            currentTripStationTypeId ?? this.currentTripStationTypeId,
        nextHospitalStation: clearNextStation
            ? null
            : nextHospitalStation ?? this.nextHospitalStation,
        nextMosqueStation: clearNextStation
            ? null
            : nextMosqueStation ?? this.nextMosqueStation,
        nextLaundryStation: clearNextStation
            ? null
            : nextLaundryStation ?? this.nextLaundryStation,
        nextTripStationArrivalTime:
            nextTripStationArrivalTime ?? this.nextTripStationArrivalTime,
        nextTripStationId: nextTripStationId ?? this.nextTripStationId,
        nextTripStationLocationX:
            nextTripStationLocationX ?? this.nextTripStationLocationX,
        nextTripStationLocationY:
            nextTripStationLocationY ?? this.nextTripStationLocationY,
        nextTripStationName: clearNextStation
            ? null
            : nextTripStationName ?? this.nextTripStationName,
        nextTripStationTypeId:
            nextTripStationTypeId ?? this.nextTripStationTypeId,
        requestProcessId: requestProcessId ?? this.requestProcessId,
        nextStationType: nextStationType ?? this.nextStationType,
        hospitals: hospitals ?? this.hospitals,
        launduries: launduries ?? this.launduries,
        mosques: mosques ?? this.mosques,
        mosquesList: mosquesList ?? this.mosquesList,
        launduriesList: launduriesList ?? this.launduriesList);
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        nextTripStationId,
        nextHospitalStation,
        nextLaundryStation,
        nextMosqueStation,
        currentTripStationArrivalTime,
        currentTripStationId,
        currentTripStationLocationX,
        currentTripStationLocationY,
        currentTripStationName,
        currentTripStationTypeId,
        nextTripStationArrivalTime,
        nextTripStationLocationX,
        nextTripStationLocationY,
        nextTripStationName,
        data,
        requestProcessId,
        nextTripStationTypeId,
        nextStationType,
        hospitals,
        launduries,
        mosques,
        mosquesList,
        launduriesList
      ];

  String? getCurrentStationTypeName() {
    return nextStationType
        ?.firstWhereOrNull((element) => element.id == currentTripStationTypeId)
        ?.name;
  }

  bool showHospitalList() {
    if (nextTripStationTypeId?.id == 30503) {
      return true;
    }
    return false;
  }

  bool showMosqueList() {
    if (nextTripStationTypeId?.id == 30505) {
      return true;
    }
    return false;
  }

  bool showLaundryList() {
    if (nextTripStationTypeId?.id == 30504) {
      return true;
    }
    return false;
  }

  bool isCemetry() {
    if (nextTripStationTypeId?.id == 30508) {
      return true;
    }
    return false;
  }

  bool showNextStationName() {
    return !showHospitalList() && !showMosqueList() && !showLaundryList();
  }

  bool isFormValid() {
    if (nextTripStationArrivalTime != null && nextTripStationTypeId != null) {
      if (showHospitalList() && nextHospitalStation != null) {
        return true;
      }
      if (showMosqueList() && nextMosqueStation != null) {
        return true;
      }
      if (showLaundryList() && nextLaundryStation != null) {
        return true;
      }

      return true;
    }

    return false;
  }
}
