import 'package:smart_advisor/app/core/utils/extensions/json_conversion.dart';
import 'package:smart_advisor/app/features/details/data/models/entity_activity_details_response_model.dart';
import 'package:smart_advisor/app/features/map/data/models/gis_data_response_model.dart';
import 'package:smart_advisor/app/features/select_activity/data/models/addetional_activites_response_model.dart';
import 'package:smart_advisor/app/features/select_activity/domain/entities/suggested_area_model.dart';
import 'package:smart_advisor/app/features/select_activity/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';

import '../../data/models/work_flow_model.dart';
import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/features/map/domain/entities/gis_data_request.dart';
import '/app/features/map/domain/entities/gis_data_response.dart';
import '/app/features/select_activity/domain/entities/addetional_activites_response.dart';
import '/app/features/select_activity/domain/entities/permits_activites_response.dart';

import '../../../details/domain/entities/entity_activity_details_response.dart';

class ActivityDetailsPageParams {
  double? area;
  GisDataResponse? gisData;
  LookUpItem? activityId;
  LookUpItem? sector;
  GISDataRequest? gisRequest;
  List<AddetionalActivityItem>? addetionalActivites;
  List<PermitItem>? permits;
  EntityActivityDetailsResponse? entityActivityDetailsResponse;
  SuggestedAreaModel? suggestedArea;
  List<WorkFlowModel>? workFlow;
  String? atmOption;
  bool? isFromHome;
  int? licenseNo;
  MainFlowBloc? mainFlowBloc;

  // Constructor
  ActivityDetailsPageParams(
      {this.area,
      this.gisData,
      this.activityId,
      this.addetionalActivites,
      this.gisRequest,
      this.permits,
      this.entityActivityDetailsResponse,
      this.sector,
      this.suggestedArea,
      this.workFlow,
      this.isFromHome,
      this.atmOption,
      this.licenseNo,
      this.mainFlowBloc});

  // copyWith method
  ActivityDetailsPageParams copyWith(
      {String? atmOption,
      double? area,
      GisDataResponse? gisData,
      LookUpItem? activityId,
      List<AddetionalActivityItem>? addetionalActivites,
      GISDataRequest? gisRequest,
      List<PermitItem>? permits,
      EntityActivityDetailsResponse? entityActivityDetailsResponse,
      LookUpItem? sector,
      SuggestedAreaModel? suggestedArea,
      List<WorkFlowModel>? workFlow,
      bool? isFromHome,
      int? licenseNo,
      MainFlowBloc? mainFlowBloc}) {
    return ActivityDetailsPageParams(
        mainFlowBloc: mainFlowBloc ?? this.mainFlowBloc,
        atmOption: atmOption ?? this.atmOption,
        workFlow: workFlow ?? this.workFlow,
        sector: sector ?? this.sector,
        permits: permits ?? this.permits,
        area: area ?? this.area,
        gisRequest: gisRequest ?? this.gisRequest,
        gisData: gisData ?? this.gisData,
        activityId: activityId ?? this.activityId,
        entityActivityDetailsResponse:
            entityActivityDetailsResponse ?? this.entityActivityDetailsResponse,
        suggestedArea: suggestedArea ?? this.suggestedArea,
        addetionalActivites: addetionalActivites ?? this.addetionalActivites,
        isFromHome: isFromHome ?? this.isFromHome,
        licenseNo: licenseNo ?? this.licenseNo);
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'area': area,
      'gisData':
          gisData?.toJson(), // Assuming GisDataResponse has toJson method
      'activityId':
          activityId?.toJson(), // Assuming LookUpItem has toJson method
      'gisRequest':
          gisRequest?.toMap(), // Assuming GISDataRequest has toJson method
      'addetionalActivites': addetionalActivites
          ?.map((e) => e.toJson())
          .toList(), // Assuming AddetionalActivityItem has toJson method
      'permits': permits
          ?.map((e) => e.toJson())
          .toList(), // Assuming PermitItem has toJson method

      'suggestedArea': suggestedArea?.toJson(),

      'workFlow': workFlow?.map((e) => e.toJson()).toList(),
    };
  }

  // fromJson method
  factory ActivityDetailsPageParams.fromJson(Map<String, dynamic> json) {
    return ActivityDetailsPageParams(
      area: json['area'],
      gisData: json['gisData'] != null
          ? GisDataResponseModel.fromJson(json['gisData'])
          : null, // Assuming GisDataResponse has fromJson method
      activityId: json['activityId'] != null
          ? LookUpItem.fromJson(json['activityId'])
          : null, // Assuming LookUpItem has fromJson method
      gisRequest: json['gisRequest'] != null
          ? GISDataRequest.fromMap(json['gisRequest'])
          : null, // Assuming GISDataRequest has fromJson method
      addetionalActivites: json['addetionalActivites'] != null
          ? (json['addetionalActivites'] as List)
              .map((e) => AddetionalActivityItemModel.fromJson(e))
              .toList() // Assuming AddetionalActivityItem has fromJson method
          : null,
      permits: json['permits'] != null
          ? (json['permits'] as List)
              .map((e) => PermitItem.fromJson(e))
              .toList() // Assuming PermitItem has fromJson method
          : null,

      workFlow: json['workFlow'] != null
          ? (json['workFlow'] as List)
              .map((e) => WorkFlowModel.fromJson(e))
              .toList() // Assuming PermitItem has fromJson method
          : null,
      suggestedArea: json['suggestedArea'] != null
          ? SuggestedAreaModel.fromJson(json['suggestedArea'])
          : null,
      entityActivityDetailsResponse: json['entityActivityDetailsResponse'] !=
              null
          ? EntityActivityDetailsResponseModel.fromJson(json[
              'entityActivityDetailsResponse']) // Assuming EntityActivityDetailsResponse has fromJson method
          : null,
    );
  }
}
