import 'package:balady_plus/app/features/vd/vd_exports.dart';

class MapScreenParams {
  GISParams? gisParams;
  GISResponse? gisResponse;
  GISParams? currentUserLocation;
  MapScreenParams({this.gisResponse, this.gisParams, this.currentUserLocation});
}
