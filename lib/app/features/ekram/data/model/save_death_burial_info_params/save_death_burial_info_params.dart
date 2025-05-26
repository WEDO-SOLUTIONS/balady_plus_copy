import 'package:balady_plus/app/features/ekram/data/model/request_details_response_model/cemetery_data.dart';
import 'package:balady_plus/app/features/ekram/data/model/request_details_response_model/death_info.dart';
import 'package:balady_plus/app/features/ekram/data/model/request_details_response_model/burial_info.dart';
import 'package:balady_plus/app/features/ekram/data/model/request_details_response_model/transport_info.dart';

class SaveDeathBurialInfoParams {
  SaveDeathBurialInfoParams({
    this.deathInfo,
    this.burialInfo,
    this.cemeteryData,
    this.transportInfo,});


  DeathInfo? deathInfo;
  BurialInfo? burialInfo;
  CemeteryData? cemeteryData;
  TransportInfo? transportInfo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (deathInfo != null) {
      map['deathInfo'] = deathInfo?.toJson();
    }
    if (burialInfo != null) {
      map['burialInfo'] = burialInfo?.toJson();
    }
    if (cemeteryData != null) {
      map['cemeteryData'] = cemeteryData?.toJson();
    }
    if (transportInfo != null) {
      map['transportInfo'] = transportInfo?.toJson();
    }
    return map;
  }
}
