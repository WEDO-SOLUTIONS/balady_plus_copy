import 'burial_info.dart';
import 'cemetery_data.dart';
import 'death_info.dart';
import 'transport_info.dart';

class SaveDeathBurialInfoParams {
  DeathInfo? deathInfo;
  BurialInfo? burialInfo;
  CemeteryData? cemeteryData;
  TransportInfo? transportInfo;

  SaveDeathBurialInfoParams({
    this.deathInfo,
    this.burialInfo,
    this.cemeteryData,
    this.transportInfo,
  });

  Map<String, dynamic> toJson() => {
        'deathInfo': deathInfo?.toJson(),
        'burialInfo': burialInfo?.toJson(),
        'cemeteryData': cemeteryData?.toJson(),
        'transportInfo': transportInfo?.toJson(),
      };
}
