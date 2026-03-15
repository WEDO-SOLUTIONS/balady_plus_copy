import 'package:balady_plus/super_app_js_bridge/model/base_response.dart';

class JsPreferencesModel implements BaseData {
  String language;
  String themeType;
  Map<String, dynamic> colors;

  JsPreferencesModel({
    required this.language,
    required this.themeType,
    required this.colors,
  });

  factory JsPreferencesModel.fromJson(Map<String, dynamic> json) {
    return JsPreferencesModel(
      language: json['language'],
      themeType: json['themeType'],
      colors: json['colors'] != null ? Map<String, dynamic>.from(json['colors']) : <String, dynamic>{},
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['language'] = language;
    data['themeType'] = themeType;
    data['colors'] = colors;
    return data;
  }
}
