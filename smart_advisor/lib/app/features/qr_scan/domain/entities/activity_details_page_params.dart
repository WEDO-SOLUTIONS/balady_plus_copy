import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/features/map/domain/entities/gis_data_request.dart';
import '/app/features/map/domain/entities/gis_data_response.dart';
import '/app/features/select_activity/domain/entities/addetional_activites_response.dart';
import '/app/features/select_activity/domain/entities/permits_activites_response.dart';

class ActivityDetailsPageParams {
  double? area;
  GisDataResponse? gisData;
  LookUpItem? activityId;
  GISDataRequest? gisRequest;
  List<AddetionalActivityItem>? addetionalActivites;
  List<PermitItem>? permits;

  // Constructor
  ActivityDetailsPageParams(
      {this.area,
      this.gisData,
      this.activityId,
      this.addetionalActivites,
      this.gisRequest,
      this.permits});

  // copyWith method
  ActivityDetailsPageParams copyWith(
      {double? area,
      GisDataResponse? gisData,
      LookUpItem? activityId,
      List<AddetionalActivityItem>? addetionalActivites,
      GISDataRequest? gisRequest,
      List<PermitItem>? permits}) {
    return ActivityDetailsPageParams(
        permits: permits ?? this.permits,
        area: area ?? this.area,
        gisRequest: gisRequest ?? this.gisRequest,
        gisData: gisData ?? this.gisData,
        activityId: activityId ?? this.activityId,
        addetionalActivites: addetionalActivites ?? this.addetionalActivites);
  }
}
