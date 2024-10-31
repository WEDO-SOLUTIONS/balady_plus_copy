import 'dart:convert';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/calculator/data/model/IsicActivity.dart';
import 'package:balady_plus/app/features/calculator/data/model/Item.dart';
import 'package:balady_plus/app/features/calculator/data/model/Municipality.dart';
import 'package:balady_plus/app/features/calculator/presentation/pages/repository/ServiceCalculatorRepository.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/remote_services/api_constants.dart';
import '../../../core/remote_services/pega_web_service.dart';
import '../../../core/services/local/helpers.dart';
import '../../../core/utils/constants/remote_config.dart';
import '../../transaction_inquiry/presentation/core/models/gis_location_result.dart';
import '../../transaction_inquiry/presentation/core/models/selected_location.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class CalculatorLocationViewModel extends BaseViewModel {
  final webServices = locator<PegaWebService>();
  GisLocationResult? gisLocation;
  SelectedLocation selectedLocation = SelectedLocation();

  List<Item> serviceTypes = [];
  List<IsicActivity> isicActivites = [];
  List<Item> accomodations = [];
  List<Item> boardList = [];
  List<Municipality> zones = [];
  int cityId = 0;
  Future<bool> getMapGISInfo({required LatLng mapLocaton, bool? select}) async {
    showLoading();
    final GisLocationResult? response = await getGisLocation(mapLocaton);
    hideLoading();
    if (response != null &&
        response.isSuccessfull != null &&
        response.isSuccessfull!) {
      if (response.adminMunicipalityId == null) {
        showError(Helpers.translatingWord("gis_error_1"));
      } else {
        if (response.ErrorCode == 100) {
          showError(Helpers.translatingWord("outside_saudiArabia"));
          return false;
        }

        gisLocation = response;
        selectedLocation.selectedLocation = mapLocaton;
        if (select ?? false) {
          navigation.currentState?.pop();
          notifyListeners();
        } else {
          showLoading();
          List<bool> responses = await Future.wait([
            getServicesListlookup(),
            getIsicActivitieslookup(),
            getAccomodationlookup(),
            getZoneslookup(),
            getBoardList(),
            getCityId(gisLocation?.sub_Municipalityguid ?? "")
          ]);
          hideLoading();
          if (!responses.contains(false)) {
            navigation.currentState!
                .pushNamed(RouteName.calculatorRoute, arguments: gisLocation);
          } else {
            showError(Helpers.translatingWord("server_error_1"));
          }
        }
      }
      notifyListeners();
      return true;
    } else {
      //showError("error3");
      showError(Helpers.translatingWord("server_error_1"));

      return false;
    }
  }

  Future<GisLocationResult?> getGisLocation(LatLng location) async {
    String query =
        "?x=${location.longitude}&y=${location.latitude}&guid=ba2570d8-6778-4048-9916-e234fac1c04b";

    final body = await webServices.getRequest(
        RemoteConfig.gis + ApiConstants.GisGetLocation,
        relativePath: query);
    bool state = body['state'];
    dynamic data = body['data'];
    String error =
        body['error'] ?? Helpers.translatingWord("errors_server_error_2");

    try {
      GisLocationResult response =
          GisLocationResult.fromJson(json.decode(data));
      if (response != null) {
        return response;
      } else {
        showError(error);
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      showError(error.toString());
      Helpers.sendLog(
          url: RemoteConfig.gis + ApiConstants.GisGetLocation,
          qeuryParms: query,
          data: data);
      return null;
    }
  }

  ServiceCalculatorRepository _serviceCalculatorRepository =
      ServiceCalculatorRepository();

  Future<bool> getServicesListlookup() async {
    List<Item>? list =
        await this._serviceCalculatorRepository.getServicesListlookup();
    if (list != null) {
      serviceTypes = list;
      return true;
    }

    return false;
  }

  Future<bool> getIsicActivitieslookup() async {
    List<IsicActivity>? list =
        await this._serviceCalculatorRepository.getIsicActivitieslookup();
    if (list != null) {
      isicActivites = list;
      return true;
    }
    return false;
  }

  Future<bool> getAccomodationlookup() async {
    List<Item>? list =
        await this._serviceCalculatorRepository.getAccommodationTypes();

    if (list != null) {
      accomodations = list;
      return true;
    }
    return false;
  }

  Future<bool> getZoneslookup() async {
    List<Municipality>? list =
        await this._serviceCalculatorRepository.getZoneslookup();

    if (list != null) {
      zones = list;
      return true;
    }

    return false;
  }

  Future<bool> getBoardList() async {
    List<Item>? list = await this._serviceCalculatorRepository.getBoardList();
    if (list != null) {
      boardList = list;
      return true;
    }
    return false;
  }

  Future<bool> getCityId(String subMunicipalityId) async {
    int? id =
        await this._serviceCalculatorRepository.getCityId(subMunicipalityId);
    if (id != null) {
      cityId = id;
      return true;
    }
    return false;
  }
}
