// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'addetional_activity_request.dart';


class SubmitActivityDetailRequest {

  RequestActivity? activities;
  RequestSite? site;
  int? requestId;

  SubmitActivityDetailRequest({

    this.activities,
    this.site,
    this.requestId,});

  SubmitActivityDetailRequest.fromJson(dynamic json) {
    activities = json['activities'] != null ? RequestActivity.fromJson(json['activities']) : null;
    site = json['site'] != null ? RequestSite.fromJson(json['site']) : null;
  }


  SubmitActivityDetailRequest copyWith({  RequestActivity? activities,
    RequestSite? site,
  }) => SubmitActivityDetailRequest(  activities: activities ?? this.activities,
    site: site ?? this.site,
  );


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (activities != null) {
      map['activities'] = activities?.toJson();
    }
    if (site != null) {
      map['site'] = site?.toJson();
    }
    return map;
  }

}

class RequestSite {
  RequestSite({
    this.krokiUrl,
    this.landNumber,
    this.latitude,
    this.longitude,
    this.mapNumber,
    this.urbiBuildingNumber,});

  RequestSite.fromJson(dynamic json) {
    krokiUrl = json['krokiUrl'];
    landNumber = json['landNumber'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    mapNumber = json['mapNumber'];
    urbiBuildingNumber = json['urbiBuildingNumber'];
  }
  String? krokiUrl;
  String? landNumber;
  String? latitude;
  String? longitude;
  String? mapNumber;
  String? urbiBuildingNumber;
  RequestSite copyWith({  String? krokiUrl,
    String? landNumber,
    String? latitude,
    String? longitude,
    String? mapNumber,
    String? urbiBuildingNumber,
  }) => RequestSite(  krokiUrl: krokiUrl ?? this.krokiUrl,
    landNumber: landNumber ?? this.landNumber,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    mapNumber: mapNumber ?? this.mapNumber,
    urbiBuildingNumber: urbiBuildingNumber ?? this.urbiBuildingNumber,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['krokiUrl'] = krokiUrl;
    map['landNumber'] = landNumber;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['mapNumber'] = mapNumber;
    map['urbiBuildingNumber'] = urbiBuildingNumber;
    return map;
  }

}

class RequestActivity {
  RequestActivity({
    this.accommodationTypeId,
    this.addedActivities,
    this.isAtmFeesPaid,
    this.mainActivityId,
    this.shopArea,
    this.unitCount,
    this.workerTypeId,});

  RequestActivity.fromJson(dynamic json) {
    accommodationTypeId = json['accommodationTypeId'];
    if (json['addedActivities'] != null) {
      addedActivities = [];
      json['addedActivities'].forEach((v) {
        addedActivities?.add(RequestExtraActivities.fromJson(v));
      });
    }
    isAtmFeesPaid = json['isAtmFeesPaid'];
    mainActivityId = json['mainActivityId'];
    shopArea = json['shopArea'];
    unitCount = json['unitCount'];
    workerTypeId = json['workerTypeId'];
  }


  int? accommodationTypeId;
  List<RequestExtraActivities>? addedActivities;
  bool? isAtmFeesPaid;
  int? mainActivityId;
  double? shopArea;
  int? unitCount;
  int? workerTypeId;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['accommodationTypeId'] = accommodationTypeId;
    if (addedActivities != null) {
      map['addedActivities'] = addedActivities?.map((v) => v.toJson()).toList();
    }
    map['isAtmFeesPaid'] = isAtmFeesPaid;
    map['mainActivityId'] = mainActivityId;
    map['shopArea'] = shopArea;
    map['unitCount'] = unitCount;
    map['workerTypeId'] = workerTypeId;
    return map;
  }

}

class RequestExtraActivities {
  RequestExtraActivities({
    this.area,
    this.detailedActivityId,});

  RequestExtraActivities.fromJson(dynamic json) {
    area = json['area'];
    detailedActivityId = json['detailedActivityId'];
  }
  double? area;
  int? detailedActivityId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['area'] = area;
    map['detailedActivityId'] = detailedActivityId;
    return map;
  }

}


// class SubmitActivityDetailRequest {
//   int? requestId;
//   int workerTypeId;
//   double area;
//   int detailedActivityId;
//   int? accommodationTypeId;
//   int? unitCount;
//   List<AddetionalActivityRequest>? additionalActivities;
//   bool? atmFeesPaid;
//
//   SubmitActivityDetailRequest(
//       {this.requestId,
//       required this.workerTypeId,
//       required this.area,
//       required this.detailedActivityId,
//       this.additionalActivities,
//       this.accommodationTypeId,
//       this.unitCount,
//       this.atmFeesPaid});
//
//   SubmitActivityDetailRequest copyWith(
//       {int? requestId,
//       int? workerTypeId,
//       double? area,
//       int? detailedActivityId,
//       List<AddetionalActivityRequest>? additionalActivities,
//       int? accommodationTypeId,
//       int? unitCount,
//       bool? atmFeesPaid}) {
//     return SubmitActivityDetailRequest(
//         requestId: requestId ?? this.requestId,
//         workerTypeId: workerTypeId ?? this.workerTypeId,
//         area: area ?? this.area,
//         detailedActivityId: detailedActivityId ?? this.detailedActivityId,
//         additionalActivities: additionalActivities ?? this.additionalActivities,
//         accommodationTypeId: accommodationTypeId ?? this.accommodationTypeId,
//         unitCount: unitCount ?? this.unitCount,
//         atmFeesPaid: atmFeesPaid ?? this.atmFeesPaid);
//   }
//
//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'workerTypeId': workerTypeId,
//       if (atmFeesPaid != null) 'atmFeesPaid': atmFeesPaid,
//       "mainActivity": {
//         'area': area,
//         'detailedActivityId': detailedActivityId,
//         if (accommodationTypeId != null)
//           "accommodationTypeId": accommodationTypeId,
//         if (unitCount != null) "unitCount": unitCount
//       },
//       'additionalActivities': additionalActivities != null
//           ? additionalActivities
//               ?.map((e) => {
//                     "detailedActivityId": e.detailsItem?.activityId,
//                     "area": e.area
//                   })
//               .toList()
//           : [],
//     };
//   }
//
//   @override
//   int get hashCode {
//     return workerTypeId.hashCode ^
//         area.hashCode ^
//         detailedActivityId.hashCode ^
//         additionalActivities.hashCode;
//   }
// }
