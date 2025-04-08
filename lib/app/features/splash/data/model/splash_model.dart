class SplashModel {
  final String occasionTitle;
  final String defaultImage;
  final String splashImage;
  final DateTime startDate;
  final DateTime endDate;
  final int defaultSplashDuration;
  final int seasonalSplashDuration;

  SplashModel({
    required this.occasionTitle,
    required this.defaultImage,
    required this.splashImage,
    required this.startDate,
    required this.endDate,
    required this.defaultSplashDuration,
    required this.seasonalSplashDuration,
  });

  factory SplashModel.fromJson(Map<String, dynamic> json) {
    return SplashModel(
      occasionTitle: json['occasion_title'] ?? '',
      defaultImage: json['default_image'] ?? '',
      splashImage: json['splash_image'] ?? '',
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      defaultSplashDuration: int.tryParse(json['default_splash_duration'] ?? '0') ?? 0,
      seasonalSplashDuration: int.tryParse(json['seasonal_splash_duration'] ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'occasion_title': occasionTitle,
      'default_image': defaultImage,
      'splash_image': splashImage,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'default_splash_duration': defaultSplashDuration.toString(),
      'seasonal_splash_duration': seasonalSplashDuration.toString(),
    };
  }
}
class StatusDetails {
  final int code;
  final String message;

  StatusDetails({required this.code, required this.message});

  factory StatusDetails.fromJson(Map<String, dynamic> json) {
    return StatusDetails(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
    };
  }
}

class SplashData {
  final String responseCode;
  final String responseMessage;
  final String responseId;
  final List<SplashModel> result;

  SplashData({
    required this.responseCode,
    required this.responseMessage,
    required this.responseId,
    required this.result,
  });

  factory SplashData.fromJson(Map<String, dynamic> json) {
    return SplashData(
      responseCode: json['responseCode'] ?? '',
      responseMessage: json['responseMessage'] ?? '',
      responseId: json['responseId'] ?? '',
      result: (json['result'] as List?)?.map((e) => SplashModel.fromJson(e)).toList() ?? [],
    );
  }

}

class SplashResponse {
  final StatusDetails statusDetails;
  final SplashData data;

  SplashResponse({required this.statusDetails, required this.data});

  factory SplashResponse.fromJson(Map<String, dynamic> json) {
    return SplashResponse(
      statusDetails: StatusDetails.fromJson(json['statusDetails'] ?? {}),
      data: SplashData.fromJson(json['data'] ?? {}),
    );
  }


}
