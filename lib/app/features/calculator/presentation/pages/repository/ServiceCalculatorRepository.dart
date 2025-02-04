import 'dart:convert';

import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/features/calculator/WebConnection.dart';
import 'package:balady_plus/app/features/calculator/service_calculator_exports.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_advisor/app/core/dependency_injection/dependency_injection_exports.dart';

import '../../../../../core/utils/constants/remote_config.dart';
import '../../../../transaction_inquiry/presentation/core/models/gis_location_result.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

// class ServiceCalculatorRepository {
//   final String _citiesListUrl = "Calculator.svc/GetCities";
//   final String _activitiesListUrl = "Calculator.svc/GetActivities";
//   final String _subActivityUrl = "Calculator.svc/GetSubactivities?activityId=";
//
//   final String _regionsListUrl = "/api/Lookup/GetRegions";
//   final String _isicActivitiesListUrl = "/api/Lookup/GetIsicActivities";
//   final String _servicesListUrl = "/api/Lookup/GetServicesList";
//
//   final String _municipalitiesListUrl =
//       "/api/Lookup/GetMunicipalities?regionId=";
//
//   final String _subMunicipalitiesListUrl = "/api/Lookup/GetSubMunicipalities/";
//
//   final String _proceduresListUrl = "/api/Lookup/GetProceduresList?serviceId=";
//
//   final String _detialedIsicActivitiesListUrl =
//       "/api/Lookup/GetActivitiesByIsicNumber?isicNumber=";
//
//   final String _detialedActivitiyUrl =
//       "/api/Lookup/GetActivityDetail?activityId=";
//   final String _accommodationTypesListUrl = "/api/Lookup/GetAccommodationTypes";
//   final String _boardListUrl = "/api/Lookup/GetBoardList";
//   final String _zonesListUrl = "/api/Lookup/GetZoneList?segmantId=1";
//
//   final String _cityIdUrl = "/api/Calculator/GetCityId?municipalityId=";
//   final String _subActivitiesUrl =
//       "/api/Calculator/GetSubActivities?activityId=";
//
//   final String _calculateV03Url = "/api/Calculator/CalculateCostV03";
//
//   final String _calculateCostUrl = "/api/Calculator/CalculateCost";
//   final String _calculateDiggingCost = "/api/Calculator/CalculateDiggingCost";
//
//   final String _calculateRenewDiggingCost =
//       "/api/Calculator/CalculateRenewDiggingCost";
//
//   final String _getGIS = "/gisservices/RestfulService.svc/Get_Full_Address?";
//
//   final webServices = WebServiceConnections();
//
//   /*final String _getGIS =
//       "http://192.168.80.156/gisservices/RestfulService.svc/Get_Full_Address?";
// */
//
//   var baladyHeaders = {
//     "X-Balady-Token": RemoteConfig.xBaladyToken,
//     "Content-Type": 'application/json',
//     "Token": RemoteConfig.baladyToken,
//     'AppId': 'balady_mobile',
//   };
//   var calculatorAPI = "CalculatorAPI";
//   var gisBaseUrl = RemoteConfig.gis;
//
//   Future<List<IsicActivity>?> getIsicActivitieslookup() async {
//     return webServices
//         .sendGetRequest(
//             url: webServices.CALCULATOR_API + _isicActivitiesListUrl,
//             headers: baladyHeaders,
//             apiName: calculatorAPI)
//         .then((data) {
//       if (data['state'] == true) {
//         try {
//           final jsonResult = json.decode(data['data']);
//           List<IsicActivity> regions = List<IsicActivity>.from(
//               jsonResult.map((x) => IsicActivity.fromJson(x)));
//           return new Future.value(regions);
//         } catch (error, stackTrace) {
//       LogsViewModel().sendEventFromModel(
//         event: ErrorExceptionModel(
//           nameEvent: EventsName.handledException,
//           message: error.toString(),
//           stackTrace: stackTrace.toString(),
//         ),
//       );
//           // return [];
//           throw error;
//         }
//       }
//       return new Future.value(null);
//     });
//   }
//
//   Future<List<Item>?> getServicesListlookup() {
//     return webServices
//         .sendGetRequest(
//             url: webServices.CALCULATOR_API + _servicesListUrl,
//             headers: baladyHeaders,
//             apiName: calculatorAPI)
//         .then((data) {
//       if (data['state']) {
//         try {
//           final jsonResult = json.decode(data['data']);
//
//           List<Item> regions =
//               List<Item>.from(jsonResult.map((x) => Item.fromJson(x)));
//
//           return new Future.value(regions);
//         } catch (error, stackTrace) {
//       LogsViewModel().sendEventFromModel(
//         event: ErrorExceptionModel(
//           nameEvent: EventsName.handledException,
//           message: error.toString(),
//           stackTrace: stackTrace.toString(),
//         ),
//       );
//           return [];
//         }
//       }
//     });
//   }
//
//   Future<List<Procedure>?> getProceduresListlookup(int serviceId) {
//     return webServices
//         .sendGetRequest(
//             url: webServices.CALCULATOR_API +
//                 _proceduresListUrl +
//                 serviceId.toString(),
//             headers: baladyHeaders,
//             apiName: calculatorAPI)
//         .then((data) {
//       if (data['state']) {
//         try {
//           final jsonResult = json.decode(data['data']);
//           List<Procedure> regions = List<Procedure>.from(
//               jsonResult.map((x) => Procedure.fromJson(x)));
//           return new Future.value(regions);
//         } catch (error, stackTrace) {
//       LogsViewModel().sendEventFromModel(
//         event: ErrorExceptionModel(
//           nameEvent: EventsName.handledException,
//           message: error.toString(),
//           stackTrace: stackTrace.toString(),
//         ),
//       );
//           //return [];
//           throw error;
//         }
//       }
//       return new Future.value(null);
//     });
//   }
//
//   Future<List<Item>?> getDetialedIsicActivitieslookup(isicActivityId) {
//     return webServices
//         .sendGetRequest(
//             url: webServices.CALCULATOR_API +
//                 _detialedIsicActivitiesListUrl +
//                 isicActivityId.toString(),
//             headers: baladyHeaders,
//             apiName: calculatorAPI)
//         .then((data) {
//       if (data['state']) {
//         try {
//           final jsonResult = json.decode(data['data']);
//           List<Item> regions =
//               List<Item>.from(jsonResult.map((x) => Item.fromJson(x)));
//           return new Future.value(regions);
//         } catch (error, stackTrace) {
//       LogsViewModel().sendEventFromModel(
//         event: ErrorExceptionModel(
//           nameEvent: EventsName.handledException,
//           message: error.toString(),
//           stackTrace: stackTrace.toString(),
//         ),
//       );
//           //return [];
//           throw error;
//         }
//       }
//       return new Future.value(null);
//     });
//   }
//
//   Future<DetailedActivity?> getDetialedActivitiylookup(int isicActivityId) {
//     return webServices
//         .sendGetRequest(
//             url: webServices.CALCULATOR_API +
//                 _detialedActivitiyUrl +
//                 isicActivityId.toString(),
//             headers: baladyHeaders,
//             apiName: calculatorAPI)
//         .then((data) {
//       if (data['state']) {
//         try {
//           final jsonResult = json.decode(data['data']);
//           DetailedActivity regions = DetailedActivity.fromJson(jsonResult);
//
//           return new Future.value(regions);
//         } catch (error, stackTrace) {
//       LogsViewModel().sendEventFromModel(
//         event: ErrorExceptionModel(
//           nameEvent: EventsName.handledException,
//           message: error.toString(),
//           stackTrace: stackTrace.toString(),
//         ),
//       );
//           //return new Future.value(null);
//           throw error;
//         }
//       }
//       return Future.value(null);
//     });
//   }
//
//   Future<List<Item>?> getAccommodationTypes() {
//     return webServices
//         .sendGetRequest(
//             url: webServices.CALCULATOR_API + _accommodationTypesListUrl,
//             headers: baladyHeaders,
//             apiName: calculatorAPI)
//         .then((data) {
//       if (data['state']) {
//         try {
//           final jsonResult = json.decode(data['data']);
//           List<Item> regions =
//               List<Item>.from(jsonResult.map((x) => Item.fromJson(x)));
//           return new Future.value(regions);
//         } catch (error, stackTrace) {
//       LogsViewModel().sendEventFromModel(
//         event: ErrorExceptionModel(
//           nameEvent: EventsName.handledException,
//           message: error.toString(),
//           stackTrace: stackTrace.toString(),
//         ),
//       );
//           //return [];
//           throw error;
//         }
//       }
//       return Future.value(null);
//     });
//   }
//
//   Future<List<Item>?> getBoardList() {
//     return webServices
//         .sendGetRequest(
//             url: webServices.CALCULATOR_API + _boardListUrl,
//             headers: baladyHeaders,
//             apiName: calculatorAPI)
//         .then((data) {
//       if (data['state']) {
//         try {
//           final jsonResult = json.decode(data['data']);
//           List<Item> regions =
//               List<Item>.from(jsonResult.map((x) => Item.fromJson(x)));
//           return new Future.value(regions);
//         } catch (error, stackTrace) {
//       LogsViewModel().sendEventFromModel(
//         event: ErrorExceptionModel(
//           nameEvent: EventsName.handledException,
//           message: error.toString(),
//           stackTrace: stackTrace.toString(),
//         ),
//       );
//           //return [];
//           throw error;
//         }
//       }
//       return new Future.value(null);
//     });
//   }
//
//   Future<List<Municipality>?> getZoneslookup() {
//     return webServices
//         .sendGetRequest(
//             url: webServices.CALCULATOR_API + _zonesListUrl,
//             headers: baladyHeaders,
//             apiName: calculatorAPI)
//         .then((data) {
//       if (data['state']) {
//         try {
//           final jsonResult = json.decode(data['data']);
//           List<Municipality> regions = List<Municipality>.from(
//               jsonResult.map((x) => Municipality.fromJson(x)));
//
//           return new Future.value(regions);
//         } catch (error, stackTrace) {
//       LogsViewModel().sendEventFromModel(
//         event: ErrorExceptionModel(
//           nameEvent: EventsName.handledException,
//           message: error.toString(),
//           stackTrace: stackTrace.toString(),
//         ),
//       );
//           // return [];
//           throw error;
//         }
//       }
//       return new Future.value(null);
//     });
//   }
//
//   Future<CalculateCostV03Response> calculateCostV03(CalculateCostV03 request) {
//     return webServices
//         .sendPostRequest(
//             url: webServices.CALCULATOR_API + _calculateV03Url,
//             apiName: calculatorAPI,
//             headers: baladyHeaders,
//             body: request.toJson())
//         .then((data) {
//       CalculateCostV03Response? regions;
//
//       if (data['state'] == true) {
//         try {
//           final jsonResult = json.decode(data['data']);
//           regions = CalculateCostV03Response.fromJson(jsonResult);
//           return new Future.value(regions);
//         } catch (error, stackTrace) {
//       LogsViewModel().sendEventFromModel(
//         event: ErrorExceptionModel(
//           nameEvent: EventsName.handledException,
//           message: error.toString(),
//           stackTrace: stackTrace.toString(),
//         ),
//       );
//           //return null;
//           throw error;
//         }
//       }
//
//       return new Future.value(regions);
//     });
//   }
//
//   Future<List<SubActivity>?> getSubActivitiesList(int procedureId) {
//     return webServices
//         .sendGetRequest(
//             url: webServices.CALCULATOR_API +
//                 _subActivitiesUrl +
//                 procedureId.toString(),
//             headers: baladyHeaders,
//             apiName: calculatorAPI)
//         .then((data) {
//       List<SubActivity>? regions;
//       if (data['state']) {
//         try {
//           final jsonResult = json.decode(data['data']);
//           regions = jsonResult["resultItem"] != null
//               ? List<SubActivity>.from(
//                   jsonResult["resultItem"]?.map((x) => SubActivity.fromJson(x)))
//               : [];
//           return new Future.value(regions);
//         } catch (error, stackTrace) {
//       LogsViewModel().sendEventFromModel(
//         event: ErrorExceptionModel(
//           nameEvent: EventsName.handledException,
//           message: error.toString(),
//           stackTrace: stackTrace.toString(),
//         ),
//       );
//           throw error;
//         }
//       }
//       return Future.value(regions);
//     });
//   }
//
//   Future<CalculateCostResponse> calculteCost(CalculateCost request) {
//     return webServices
//         .sendPostRequest(
//             url: webServices.CALCULATOR_API + _calculateCostUrl,
//             apiName: calculatorAPI,
//             headers: baladyHeaders,
//             body: request.toJson())
//         .then((data) {
//       CalculateCostResponse? regions;
//
//       if (data['state'] == true) {
//         try {
//           final jsonResult = json.decode(data['data']);
//           regions = CalculateCostResponse.fromJson(jsonResult);
//           return new Future.value(regions);
//         } catch (error, stackTrace) {
//       LogsViewModel().sendEventFromModel(
//         event: ErrorExceptionModel(
//           nameEvent: EventsName.handledException,
//           message: error.toString(),
//           stackTrace: stackTrace.toString(),
//         ),
//       );
//           throw error;
//         }
//       }
//
//       return Future.value(regions);
//     });
//   }
//
//   Future<int> getCityId(String subMunicipalityId) {
//     return webServices
//         .sendGetRequest(
//             url: webServices.CALCULATOR_API +
//                 _cityIdUrl +
//                 subMunicipalityId.toString(),
//             headers: baladyHeaders,
//             apiName: calculatorAPI)
//         .then((data) {
//       if (data['state']) {
//         try {
//           final jsonResult = json.decode(data['data']);
//           return jsonResult["resultItem"] != null
//               ? new Future.value(jsonResult["resultItem"])
//               : new Future.value(0);
//         } catch (error, stackTrace) {
//       LogsViewModel().sendEventFromModel(
//         event: ErrorExceptionModel(
//           nameEvent: EventsName.handledException,
//           message: error.toString(),
//           stackTrace: stackTrace.toString(),
//         ),
//       );
//           return 0;
//         }
//       }
//       return 0;
//     });
//   }
//
//   Future<CalculateDiggingResponse> calculteDiggingCost(
//       CalculateDiggingCost request) {
//     return webServices
//         .sendPostRequest(
//             url: webServices.CALCULATOR_API + _calculateDiggingCost,
//             apiName: calculatorAPI,
//             headers: baladyHeaders,
//             body: request.toJson())
//         .then((data) {
//       CalculateDiggingResponse? regions;
//
//       if (data['state'] == true) {
//         try {
//           final jsonResult = json.decode(data['data']);
//           regions = CalculateDiggingResponse.fromJson(jsonResult);
//           return regions;
//         } catch (error, stackTrace) {
//       LogsViewModel().sendEventFromModel(
//         event: ErrorExceptionModel(
//           nameEvent: EventsName.handledException,
//           message: error.toString(),
//           stackTrace: stackTrace.toString(),
//         ),
//       );
//           throw error;
//         }
//       }
//
//       return new Future.value(regions);
//     });
//   }
//
//   Future<CalculateDiggingResponse> calculteRenewDiggingCost(
//       CalculateRenewDiggingCost request) {
//     return webServices
//         .sendPostRequest(
//             url: webServices.CALCULATOR_API + _calculateRenewDiggingCost,
//             apiName: calculatorAPI,
//             headers: baladyHeaders,
//             body: request.toJson())
//         .then((data) {
//       CalculateDiggingResponse? regions;
//       if (data['state'] == true) {
//         try {
//           final jsonResult = json.decode(data['data']);
//           regions = CalculateDiggingResponse.fromJson(jsonResult);
//           return regions;
//         } catch (error, stackTrace) {
//       LogsViewModel().sendEventFromModel(
//         event: ErrorExceptionModel(
//           nameEvent: EventsName.handledException,
//           message: error.toString(),
//           stackTrace: stackTrace.toString(),
//         ),
//       );
//           throw error;
//         }
//       }
//
//       return new Future.value(regions);
//     });
//   }
//
//   Future<GisLocationResult?> getGpsLocation(LatLng latLng) async {
//     /// notes that here I will fetch the real data from API or form local Storage
//
//     final body = await webServices.sendGetRequest(
//         url: gisBaseUrl +
//             _getGIS +
//             "x=${latLng.longitude}&y=${latLng.latitude}&guid=ba2570d8-6778-4048-9916-e234fac1c04b");
//
//     bool state = body['state'];
//     GisLocationResult? item;
//     if (state == true) {
//       try {
//         item = GisLocationResult.fromJson(json.decode(body['data']));
//       } catch (error, stackTrace) {
//       LogsViewModel().sendEventFromModel(
//         event: ErrorExceptionModel(
//           nameEvent: EventsName.handledException,
//           message: error.toString(),
//           stackTrace: stackTrace.toString(),
//         ),
//       );
//         throw error;
//       }
//       if (item != null && (item.sub_Municipalityguid == null)) {}
//       return item;
//     }
//
//     return item;
//   }
// }

class ServiceCalculatorRepository {
  static const String baseServicePath = "/v1/calculator-services/";
  final String _servicesListUrl = "${baseServicePath}services-list";
  final String _isicActivitiesListUrl = "${baseServicePath}isic-activities";
  final String _proceduresListUrl =
      "${baseServicePath}procedures-list?serviceId=";
  final String _detialedActivitiyUrl =
      "${baseServicePath}activity-detail?activityId=";
  final String _accommodationTypesListUrl =
      "${baseServicePath}accommodation-types";
  final String _boardListUrl = "${baseServicePath}board-list";
  final String _zonesListUrl =
      "${baseServicePath}zone-list?segmantId=1"; // NOT USED THIS segmantId=1
  final String _cityIdUrl =
      "${baseServicePath}city-id?subMunicipalityId="; // USED THIS  subMunicipalityId
  final String _subActivitiesUrl =
      "${baseServicePath}sub-activities?activityId=";
  final String _calculateCostUrl = "${baseServicePath}calculate-cost";

//   final String _getGIS = "/gisservices/RestfulService.svc/Get_Full_Address?";

  final String _detialedIsicActivitiesListUrl =
      "/api/Lookup/GetActivitiesByIsicNumber?isicNumber=";
  final String _calculateV03Url = "${baseServicePath}calculate-cost-v03";
  final String _calculateDiggingCost =
      "${baseServicePath}calculate-digging-cost";
  final String _calculateRenewDiggingCost =
      "${baseServicePath}calculate-renew-digging-cost";

  final WebService webServices = sl<WebService>();

  var baladyHeaders = {
    // "X-Balady-Token": coreSl<LoadConfigTypes>().environment.xBaladyToken,
    "Content-Type": 'application/json',
    // "Token": coreSl<LoadConfigTypes>().environment.baladyToken,
    'AppId': 'balady_mobile',
  };
  var calculatorAPI = "CalculatorAPI";

  // var gisBaseUrl = coreSl<LoadConfigTypes>().environment.gis;

  Future<List<IsicActivity>?> getIsicActivitieslookup() async {
    return webServices.dio
        .get(
      _isicActivitiesListUrl,
      // headers: baladyHeaders,
      // apiName: calculatorAPI,
    )
        .then((respons) {
      if (respons.statusCode == 200) {
        try {
          var data = respons.data;
          final jsonResult = data['data']['result'];
          List<IsicActivity> regions = List<IsicActivity>.from(
            jsonResult.map(
              (x) => IsicActivity.fromJson(x),
            ),
          );
          return new Future.value(regions);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
          // return [];
          throw error;
        }
      }
      return new Future.value(null);
    });
  }

  Future<List<Item>?> getServicesListlookup() {
    return webServices.dio
        .get(
      _servicesListUrl,
      // headers: baladyHeaders,
      // apiName: calculatorAPI,
    )
        .then((respons) {
      if (respons.statusCode == 200) {
        try {
          var data = respons.data;
          final jsonResult = data['data']['result'];

          List<Item> regions =
              List<Item>.from(jsonResult.map((x) => Item.fromJson(x)));

          return new Future.value(regions);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
          return [];
        }
      }
    });
  }

  Future<List<Procedure>?> getProceduresListlookup(int serviceId) {
    return webServices.dio
        .get(
      _proceduresListUrl + serviceId.toString(),
      // headers: baladyHeaders,
// apiName: calculatorAPI,
    )
        .then((respons) {
      if (respons.statusCode == 200) {
        try {
          var data = respons.data;
          final jsonResult = data['data']['result'];
          List<Procedure> regions = List<Procedure>.from(
              jsonResult.map((x) => Procedure.fromJson(x)));
          return new Future.value(regions);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
          //return [];
          throw error;
        }
      }
      return new Future.value(null);
    });
  }

  Future<List<Item>?> getDetialedIsicActivitieslookup(isicActivityId) {
    return webServices.dio
        .get(
      _detialedIsicActivitiesListUrl + isicActivityId.toString(),
      // headers: baladyHeaders,
// apiName: calculatorAPI,
    )
        .then((respons) {
      if (respons.statusCode == 200) {
        try {
          var data = respons.data;
          final jsonResult = data['data']['result'];
          List<Item> regions =
              List<Item>.from(jsonResult.map((x) => Item.fromJson(x)));
          return new Future.value(regions);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
          //return [];
          throw error;
        }
      }
      return new Future.value(null);
    });
  }

  Future<DetailedActivity?> getDetialedActivitiylookup(int isicActivityId) {
    return webServices.dio
        .get(
      _detialedActivitiyUrl + isicActivityId.toString(),
      // headers: baladyHeaders,
      // apiName: calculatorAPI,
    )
        .then((respons) {
      if (respons.statusCode == 200) {
        try {
          var data = respons.data;
          final jsonResult = data['data']['result'];
          DetailedActivity regions = DetailedActivity.fromJson(jsonResult);

          return new Future.value(regions);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
          //return new Future.value(null);
          throw error;
        }
      }
      return Future.value(null);
    });
  }

  Future<List<Item>?> getAccommodationTypes() {
    return webServices.dio
        .get(
      _accommodationTypesListUrl,
      // headers: baladyHeaders,
// apiName: calculatorAPI,
    )
        .then((respons) {
      if (respons.statusCode == 200) {
        try {
          var data = respons.data;
          final jsonResult = data['data']['result'];
          List<Item> regions =
              List<Item>.from(jsonResult.map((x) => Item.fromJson(x)));
          return new Future.value(regions);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
          //return [];
          throw error;
        }
      }
      return Future.value(null);
    });
  }

  Future<List<Item>?> getBoardList() {
    return webServices.dio
        .get(
      _boardListUrl,
      // headers: baladyHeaders,
// apiName: calculatorAPI,
    )
        .then((respons) {
      if (respons.statusCode == 200) {
        try {
          var data = respons.data;
          final jsonResult = data['data']['result'];
          List<Item> regions =
              List<Item>.from(jsonResult.map((x) => Item.fromJson(x)));
          return new Future.value(regions);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
          //return [];
          throw error;
        }
      }
      return new Future.value(null);
    });
  }

  Future<List<Municipality>?> getZoneslookup() {
    return webServices.dio
        .get(
      _zonesListUrl,
      // headers: baladyHeaders,
// apiName: calculatorAPI,
    )
        .then((respons) {
      if (respons.statusCode == 200) {
        try {
          var data = respons.data;
          final jsonResult = data['data']['result'];
          List<Municipality> regions = List<Municipality>.from(
              jsonResult.map((x) => Municipality.fromJson(x)));

          return new Future.value(regions);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
          // return [];
          throw error;
        }
      }
      return new Future.value(null);
    });
  }

  Future<CalculateCostV03Response> calculateCostV03(CalculateCostV03 request) {
    return webServices.dio
        .post(
      _calculateV03Url,
      // apiName: calculatorAPI,
      // headers: baladyHeaders,
      data: request.toJson(),
    )
        .then((respons) {
      CalculateCostV03Response? regions;

      if (respons.statusCode == 200) {
        try {
          var data = respons.data;
          final jsonResult = data['data']['result'];
          regions = CalculateCostV03Response.fromJson(jsonResult);
          return new Future.value(regions);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
          //return null;
          throw error;
        }
      }

      return new Future.value(regions);
    });
  }

  Future<List<SubActivity>?> getSubActivitiesList(int procedureId) {
    return webServices.dio
        .get(
      _subActivitiesUrl + procedureId.toString(),
      // headers: baladyHeaders,
// apiName: calculatorAPI,
    )
        .then((respons) {
      List<SubActivity>? regions;
      if (respons.statusCode == 200) {
        try {
          var data = respons.data;
          final jsonResult = data['data']['result'];
          regions = jsonResult != null
              ? List<SubActivity>.from(
                  jsonResult?.map(
                    (x) => SubActivity.fromJson(x),
                  ),
                )
              : [];
          return new Future.value(regions);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
          throw error;
        }
      }
      return Future.value(regions);
    });
  }

  Future<CalculateCostResponse> calculteCost(CalculateCost request) {
    return webServices.dio
        .post(
      _calculateCostUrl,
      // apiName: calculatorAPI,
      // headers: baladyHeaders,
      data: request.toJson(),
    )
        .then((respons) {
      CalculateCostResponse? regions;

      if (respons.statusCode == 200) {
        try {
          var data = respons.data;
          final jsonResult = data['data']['result'];
          regions = CalculateCostResponse.fromJson(jsonResult);
          return new Future.value(regions);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
          throw error;
        }
      }

      return Future.value(regions);
    });
  }

  Future<int> getCityId(String subMunicipalityId) {
    return webServices.dio
        .get(
      _cityIdUrl + subMunicipalityId.toString(),
      // headers: baladyHeaders,
// apiName: calculatorAPI,
    )
        .then((respons) {
      if (respons.statusCode == 200) {
        try {
          var data = respons.data;
          final jsonResult = data['data']['result'];
          return jsonResult["resultItem"] != null
              ? new Future.value(jsonResult["resultItem"])
              : new Future.value(0);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
          return 0;
        }
      }
      return 0;
    });
  }

  Future<CalculateDiggingResponse> calculteDiggingCost(
      CalculateDiggingCost request) {
    return webServices.dio
        .post(
      _calculateDiggingCost,
      // apiName: calculatorAPI,
      // headers: baladyHeaders,
      data: request.toJson(),
    )
        .then((respons) {
      CalculateDiggingResponse? regions;

      if (respons.statusCode == 200) {
        try {
          var data = respons.data;
          final jsonResult = data['data']['result'];
          regions = CalculateDiggingResponse.fromJson(jsonResult);
          return regions;
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
          throw error;
        }
      }

      return new Future.value(regions);
    });
  }

  Future<CalculateDiggingResponse> calculteRenewDiggingCost(
      CalculateRenewDiggingCost request) {
    return webServices.dio
        .post(
      _calculateRenewDiggingCost,
      data: request.toJson(),
    )
        .then((respons) {
      CalculateDiggingResponse? regions;
      if (respons.statusCode == 200) {
        try {
          var data = respons.data;
          final jsonResult = data['data']['result'];
          regions = CalculateDiggingResponse.fromJson(jsonResult);
          return regions;
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
          throw error;
        }
      }

      return new Future.value(regions);
    });
  }

// Future<GisLocationResult?> getGpsLocation(LatLng latLng) async {
//   /// notes that here I will fetch the real data from API or form local Storage
//
//   final body = await webServices.dio.get(
//       _getGIS +
//           "x=${latLng.longitude}&y=${latLng.latitude}&guid=ba2570d8-6778-4048-9916-e234fac1c04b");
//
//   bool state = body['state'];
//   GisLocationResult? item;
//   if (state == true) {
//     try {
//           var data = respons.data;
//       item = GisLocationResult.fromJson(json.decode(body['data']));
//     } catch (error, stackTrace) {
//     LogsViewModel().sendEventFromModel(
//       event: ErrorExceptionModel(
//         nameEvent: EventsName.handledException,
//         message: error.toString(),
//         stackTrace: stackTrace.toString(),
//       ),
//     );
//       throw error;
//     }
//     if (item != null && (item.sub_Municipalityguid == null)) {}
//     return item;
//   }
//
//   return item;
// }
}
