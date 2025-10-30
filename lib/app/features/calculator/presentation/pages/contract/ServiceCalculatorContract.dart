import 'package:balady_plus/app/features/calculator/presentation/base.dart';
import 'package:balady_plus/app/features/calculator/service_calculator_exports.dart';
import 'package:dgis_map/library.dart';

import '../../../../transaction_inquiry/presentation/core/models/gis_location_result.dart';

abstract class IServviceCalculatorPresenter
    extends BasePresenter<IServiceCalculatorView> {
  void getServicesListlookup();
  void getProceduresListlookup(int serviceId);
  void getDetailedIsicActivityListlookup(
      int isicActivityId, ActivityIsicListDetailType type);
  void getDetailedActivitylookup(int activityId, ActivityDetailType type);
  void getZoneslookup();
  void getBoardListlookup();
  void getAccomodationlookup();
  void getIsicActivitieslookup();
  void getSubActivitieslookup(int procedureid);
  void getCityIdlookup(String subMunicipalityId);
  void calculateV03(CalculateCostV03 request);
  void calculateCost(CalculateCost request);
  void calculateDiggingCost(CalculateDiggingCost request);
  void calculatRenewDiggingCost(CalculateRenewDiggingCost request);
  void getGpsLocation(LatLng latLng);
}

abstract class IServiceCalculatorView extends BaseView {
  void getServicesListlookupSuccess(List<Item>? result);
  void getServicesListlookupFailed();

  void getProceduresListlookupSuccess(List<Procedure>? result);
  void getProceduresListlookupFailed();

  void getDetailedIsicActivityListlookupSuccess(
      List<Item>? result, ActivityIsicListDetailType? type);
  void getDetailedIsicActivityListlookupFailed();

  void getDetailedActivitylookupSuccess(
      DetailedActivity? result, ActivityDetailType? type);
  void getDetailedActivitylookupFailed();

  void getZoneslookupSuccess(List<Municipality>? result);
  void getZoneslookupFailed();

  void getBoardListlookupSuccess(List<Item>? result);
  void getBoardListlookupFailed();

  void getAccomodationlookupSuccess(List<Item>? result);
  void getAccomodationlookupFailed();

  void getIsicActivitieslookupSuccess(List<IsicActivity>? result);
  void getIsicActivitieslookupFailed();

  void getSubActivitieslookupSuccess(List<SubActivity>? result);
  void getSubActivitieslookupFailed();

  void getCityIdlookupSuccess(int? result);
  void getCityIdlookupFailed();

  void calculateV03Success(CalculateCostV03Response? result);
  void calculateV03Failed();

  void calculateCostSuccess(CalculateCostResponse? result);
  void calculateCostFailed();

  void calculateDiggingCostSuccess(CalculateDiggingResponse? result);
  void calculateDiggingCostFailed();

  void calculatRenewDiggingCostSuccess(CalculateDiggingResponse? result);
  void calculatRenewDiggingCostFailed();

  void getGpsLocationSuccess(GisLocationResult? result);
  void getGpsLocationFailed();
}
