import 'package:smart_advisor/app/features/manage_license_flow/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';

import '../../../select_activity/domain/entities/addetional_activites_response.dart';

class CommercialLicenseModel {
  Activities? activities;
  int? crNumber;
  int? crType;
  Site? site;
  List<int>? permits;

  CommercialLicenseModel(
      {this.activities, this.crNumber, this.crType, this.site, this.permits});

  CommercialLicenseModel copyWith(
          {Activities? activities,
          int? crNumber,
          int? crType,
          Site? site,
          List<int>? permits}) =>
      CommercialLicenseModel(
          activities: activities ?? this.activities,
          crNumber: crNumber ?? this.crNumber,
          crType: crType ?? this.crType,
          site: site ?? this.site,
          permits: permits ?? this.permits);
}

class Activities {
  dynamic accommodationTypeId;
  List<AddetionalActivityItem>? addedActivities;
  bool? isAtmFeesPaid;
  MainActivity? mainActivity;
  dynamic? shopArea;
  dynamic unitCount;
  int? workerTypeId;

  Activities({
    this.accommodationTypeId,
    this.addedActivities,
    this.isAtmFeesPaid,
    this.mainActivity,
    this.shopArea,
    this.unitCount,
    this.workerTypeId,
  });

  Activities copyWith({
    dynamic accommodationTypeId,
    List<AddetionalActivityItem>? addedActivities,
    bool? isAtmFeesPaid,
    MainActivity? mainActivity,
    dynamic? shopArea,
    dynamic unitCount,
    int? workerTypeId,
  }) =>
      Activities(
        accommodationTypeId: accommodationTypeId ?? this.accommodationTypeId,
        addedActivities: addedActivities ?? this.addedActivities,
        isAtmFeesPaid: isAtmFeesPaid ?? this.isAtmFeesPaid,
        mainActivity: mainActivity ?? this.mainActivity,
        shopArea: shopArea ?? this.shopArea,
        unitCount: unitCount ?? this.unitCount,
        workerTypeId: workerTypeId ?? this.workerTypeId,
      );
}

class MainActivity {
  double? area;
  int? detailedActivityId;

  MainActivity({
    this.area,
    this.detailedActivityId,
  });

  MainActivity copyWith({
    double? area,
    int? detailedActivityId,
  }) =>
      MainActivity(
        area: area ?? this.area,
        detailedActivityId: detailedActivityId ?? this.detailedActivityId,
      );
}

class Site {
  String? krokiUrl;
  String? landNumber;
  String? latitude;
  String? longitude;
  String? mapNumber;

  Site({
    this.krokiUrl,
    this.landNumber,
    this.latitude,
    this.longitude,
    this.mapNumber,
  });

  Site copyWith({
    String? krokiUrl,
    String? landNumber,
    String? latitude,
    String? longitude,
    String? mapNumber,
  }) =>
      Site(
        krokiUrl: krokiUrl ?? this.krokiUrl,
        landNumber: landNumber ?? this.landNumber,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        mapNumber: mapNumber ?? this.mapNumber,
      );
}
