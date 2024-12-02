part of 'map_export_bloc.dart';

abstract class MapExportEvent extends Equatable {
  const MapExportEvent();

  @override
  List<Object> get props => [];
}

class GetGISDataExportEvent extends MapExportEvent {
  final GISParams params;
  final bool popPage;
  final bool refreshLocation;
  const GetGISDataExportEvent(
      {required this.params,
      this.popPage = true,
      this.refreshLocation = false});
}

class InitMapEvent extends MapExportEvent {
  const InitMapEvent();
}

class GetCurentUserLocationEvent extends MapExportEvent {
  const GetCurentUserLocationEvent();
}

class SelectLocationEvent extends MapExportEvent {
  final LatLng location;
  const SelectLocationEvent({required this.location});
}

class SaveLocationDataEvent extends MapExportEvent {
  const SaveLocationDataEvent();
}

class UpdateFieldsEvent extends MapExportEvent {
  final String? mapNo;
  final String? landNo;
  const UpdateFieldsEvent({this.mapNo, this.landNo});
}
