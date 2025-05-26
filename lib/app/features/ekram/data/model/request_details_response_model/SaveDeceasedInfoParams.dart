import 'package:balady_plus/app/features/ekram/data/model/request_details_response_model/deceased_info.dart';
import 'package:balady_plus/app/features/ekram/data/model/request_details_response_model/main_info.dart';

class SaveDeceasedInfoParams {
  SaveDeceasedInfoParams({
      this.deceasedInfo, 
      this.mainInfo,});

  SaveDeceasedInfoParams.fromJson(dynamic json) {
    deceasedInfo = json['deceasedInfo'] != null ? DeceasedInfo.fromJson(json['deceasedInfo']) : null;
    mainInfo = json['mainInfo'] != null ? MainInfo.fromJson(json['mainInfo']) : null;
  }
  DeceasedInfo? deceasedInfo;
  MainInfo? mainInfo;
SaveDeceasedInfoParams copyWith({  DeceasedInfo? deceasedInfo,
  MainInfo? mainInfo,
}) => SaveDeceasedInfoParams(  deceasedInfo: deceasedInfo ?? this.deceasedInfo,
  mainInfo: mainInfo ?? this.mainInfo,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (deceasedInfo != null) {
      map['deceasedInfo'] = deceasedInfo?.toJson();
    }
    if (mainInfo != null) {
      map['mainInfo'] = mainInfo?.toJson();
    }
    return map;
  }

}

