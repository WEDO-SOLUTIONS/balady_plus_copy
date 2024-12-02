part of 'map_export_bloc.dart';

class MapExportState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final GISResponse? gisResponse;
  final GISParams? location;
  final GISParams? userLocation;
  final bool? isLocationAllowed;
  final bool? readOnly;
  final int? requestNo;
  final SaveLocationResponse? locationResponse;
  final String? landNo;
  final String? mapNo;
  final bool? draftLoaded;
  final BlocStatus draftStatus;
  MapExportState(
      {this.status = BlocStatus.initial,
      this.errorMessage,
      this.gisResponse,
      this.location,
      this.userLocation,
      this.isLocationAllowed = true,
      this.readOnly = false,
      this.locationResponse,
      this.requestNo,
      this.landNo,
      this.mapNo,
      this.draftLoaded,
      this.draftStatus = BlocStatus.initial});

  MapExportState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      final GISResponse? gisResponse,
      final GISParams? location,
      final GISParams? userLocation,
      final bool? isLocationAllowed,
      final bool? readOnly,
      final int? requestNo,
      final SaveLocationResponse? locationResponse,
      final String? landNo,
      final String? mapNo,
      final bool? draftLoaded,
      final BlocStatus? draftStatus}) {
    return MapExportState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        gisResponse: gisResponse ?? this.gisResponse,
        location: location ?? this.location,
        userLocation: userLocation ?? this.userLocation,
        isLocationAllowed: isLocationAllowed ?? this.isLocationAllowed,
        readOnly: readOnly ?? this.readOnly,
        requestNo: requestNo ?? this.requestNo,
        locationResponse: locationResponse ?? this.locationResponse,
        landNo: landNo ?? this.landNo,
        mapNo: mapNo ?? this.mapNo,
        draftLoaded: draftLoaded ?? this.draftLoaded,
        draftStatus: draftStatus ?? this.draftStatus);
  }

  bool isFormValid() {
    return gisResponse != null &&
        landNo != null &&
        landNo!.trim().isNotEmpty &&
        mapNo != null &&
        mapNo!.trim().isNotEmpty;
  }

  @override
  List<Object?> get props => [
        status,
        location,
        userLocation,
        gisResponse,
        isLocationAllowed,
        readOnly,
        requestNo,
        locationResponse,
        mapNo,
        landNo,
        draftLoaded,
        draftStatus
      ];
}
