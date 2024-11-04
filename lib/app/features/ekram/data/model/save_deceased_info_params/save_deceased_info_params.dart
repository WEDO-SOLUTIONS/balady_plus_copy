import 'deceased_info.dart';
import 'main_info.dart';

class SaveDeceasedInfoParams {
  DeceasedInfo? deceasedInfo;
  MainInfo? mainInfo;

  SaveDeceasedInfoParams({this.deceasedInfo, this.mainInfo});

  factory SaveDeceasedInfoParams.fromJson(Map<String, dynamic> json) {
    return SaveDeceasedInfoParams(
      deceasedInfo: json['deceasedInfo'] == null
          ? null
          : DeceasedInfo.fromJson(json['deceasedInfo'] as Map<String, dynamic>),
      mainInfo: json['mainInfo'] == null
          ? null
          : MainInfo.fromJson(json['mainInfo'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'deceasedInfo': deceasedInfo?.toJson(),
        'mainInfo': mainInfo?.toJson(),
      };

  SaveDeceasedInfoParams copyWith({
    DeceasedInfo? deceasedInfo,
    MainInfo? mainInfo,
  }) {
    return SaveDeceasedInfoParams(
      deceasedInfo: deceasedInfo ?? this.deceasedInfo,
      mainInfo: mainInfo ?? this.mainInfo,
    );
  }
}
