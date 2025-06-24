part of 'step2_activity_data_export_cubit.dart';


abstract class MapExportEvent extends Equatable {
  const MapExportEvent();

  @override
  List<Object> get props => [];
}

class GetGISDataExportEvent extends MapExportEvent {
  final GISParams params;
  final bool popPage;
  final bool refreshLocation;
  GISResponse? gisResponse;
   GetGISDataExportEvent(
      {required this.params,
      this.popPage = true,
        this.gisResponse,
      this.refreshLocation = false});
}

class InitMapEvent extends MapExportEvent {
  const InitMapEvent();
}

class GetCurentLocationEvent extends MapExportEvent {
  const GetCurentLocationEvent();
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
