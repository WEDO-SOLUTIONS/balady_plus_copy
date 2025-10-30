part of 'trip_details_bloc_bloc.dart';

class TripDetailsState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final DeceasedInfoResponseDtoList deathInfo;
  final int requestId;
  final TripDetailsParmas? params;
  final List<TransportAttachResponseDto>? transportAttachResponseDtoList;

  final List<TripDetails>? tripDetails;
  final List<LookUpItem>? stationTypes;
  final bool? isCompleted;
  TripDetailsState(
      {this.status = BlocStatus.initial,
      this.errorMessage,
      required this.deathInfo,
      this.transportAttachResponseDtoList,
      this.tripDetails,
      required this.requestId,
      this.stationTypes,
      this.isCompleted,
      this.params});

  TripDetailsState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      final DeceasedInfoResponseDtoList? deathInfo,
      final List<LookUpItem>? stationTypes,
      final List<TransportAttachResponseDto>? transportAttachResponseDtoList,
      final List<TripDetails>? tripDetails,
      final bool? isCompleted}) {
    return TripDetailsState(
        status: status ?? this.status,
        deathInfo: deathInfo ?? this.deathInfo,
        errorMessage: errorMessage ?? this.errorMessage,
        tripDetails: tripDetails ?? this.tripDetails,
        transportAttachResponseDtoList: transportAttachResponseDtoList ??
            this.transportAttachResponseDtoList,
        requestId: requestId,
        stationTypes: stationTypes ?? this.stationTypes,
        isCompleted: isCompleted ?? this.isCompleted,
        params: params);
  }

  String? getStationTypeName(int id) {
    return stationTypes?.firstWhereOrNull((element) => element.id == id)?.name;
  }

  bool isLetterExists() {
    return ((transportAttachResponseDtoList != null &&
        transportAttachResponseDtoList!.firstWhereOrNull(
                (element) => element.attachmentType == 8507) !=
            null));
  }

  bool isHdSharieExists() {
    return ((transportAttachResponseDtoList != null &&
        transportAttachResponseDtoList!.firstWhereOrNull(
                (element) => element.attachmentType == 8508) !=
            null));
  }

  int? letterID() {
    return transportAttachResponseDtoList
            ?.firstWhereOrNull((element) => element.attachmentType == 8507)
            ?.id ??
        null;
  }

  int? hdSharieID() {
    return transportAttachResponseDtoList
            ?.firstWhereOrNull((element) => element.attachmentType == 8508)
            ?.id ??
        null;
  }

  @override
  List<Object?> get props => [status, tripDetails, isCompleted];
}
