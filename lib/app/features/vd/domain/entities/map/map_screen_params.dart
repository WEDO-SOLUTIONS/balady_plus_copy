import 'package:balady_plus/app/features/vd/vd_exports.dart';

import '../../../../create_compliance/domain/entities/compliance_gis_resopnse.dart';

class MapScreenParams {
  GISParams? gisParams;
  ComplainceGISResponse? complianceGIS;
  GISResponse? gisResponse;
  GISParams? currentUserLocation;
  bool? readOnly;
  int? requestNo;

  MapScreenParams(
      {this.gisResponse,
      this.complianceGIS,
      this.gisParams,
      this.readOnly,
      this.currentUserLocation,
      this.requestNo});
}
