import 'package:json_annotation/json_annotation.dart';
import 'package:mapness/entities/weather/weather_info.dart';

part 'weather_model.g.dart';

@JsonSerializable()
class AllWeatherInfoModel {
  final LocationModel? location;
  final CurrentModel? current;
  final ForecastModel? forecast;

  AllWeatherInfoModel({
    this.current,
    this.forecast,
    this.location,
  });

  factory AllWeatherInfoModel.fromJson(Map<String, dynamic> json) => _$AllWeatherInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$AllWeatherInfoModelToJson(this);

  AllWeatherInfoEntity toDomain() => AllWeatherInfoEntity(
    current: current?.toDomain(),
    forecast: forecast?.toDomain(),
    location: location?.toDomain(),
  );
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CurrentModel {
  final double? tempC;
  final double? tempF;
  final int? isDay;
  final ConditionModel? condition;
  final double? windMph;
  final double? windKph;
  final double? pressureMb;
  final double? pressureIn;
  final int? humidity;
  final double? visKm;
  final double? visMiles;

  CurrentModel({
    this.tempC,
    this.tempF,
    this.isDay,
    this.condition,
    this.windMph,
    this.windKph,
    this.pressureMb,
    this.pressureIn,
    this.humidity,
    this.visKm,
    this.visMiles,
  });

  factory CurrentModel.fromJson(Map<String, dynamic> json) => _$CurrentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentModelToJson(this);

  Current toDomain() => Current(
    tempC: tempC,
    tempF: tempF,
    isDay: isDay,
    condition: condition?.toDomain(),
    windMph: windMph,
    windKph: windKph,
    pressureMb: pressureMb,
    pressureIn: pressureIn,
    humidity: humidity,
    visKm: visKm,
    visMiles: visMiles,
  );
}

@JsonSerializable()
class ConditionModel {
  final String? text;
  final String icon;
  final int? code;

  const ConditionModel({
    required this.icon,
    this.code,
    this.text,
  });

  factory ConditionModel.fromJson(Map<String, dynamic> json) => _$ConditionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConditionModelToJson(this);

  Condition toDomain() => Condition(
    text: text,
    icon: icon,
    code: code,
  );
}

@JsonSerializable()
class ForecastModel {
  @JsonKey(name: 'forecastday')
  final List<ForecastDayModel> forecastDay;

  ForecastModel({this.forecastDay = const []});

  factory ForecastModel.fromJson(Map<String, dynamic> json) => _$ForecastModelFromJson(json);

  Map<String, dynamic> toJson() => _$ForecastModelToJson(this);

  Forecast toDomain() => Forecast(
    forecastday: forecastDay.map((e) => e.toDomain()).toList(),
  );
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ForecastDayModel {
  final String? date;
  final int? dateEpoch;
  final DayModel? day;
  final AstroModel? astro;
  final List<HourModel>? hour;

  ForecastDayModel({
    this.astro,
    this.date,
    this.dateEpoch,
    this.day,
    this.hour,
  });

  factory ForecastDayModel.fromJson(Map<String, dynamic> json) => _$ForecastDayModelFromJson(json);

  Map<String, dynamic> toJson() => _$ForecastDayModelToJson(this);

  ForecastDay toDomain() => ForecastDay(
    date: date,
    dateEpoch: dateEpoch,
    day: day?.toDomain(),
    astro: astro?.toDomain(),
    hour: hour?.map((e) => e.toDomain()).toList(),
  );
}

@JsonSerializable()
class AstroModel {
  final String? sunrise;
  final String? sunset;

  AstroModel({
    this.sunrise,
    this.sunset,
  });

  factory AstroModel.fromJson(Map<String, dynamic> json) => _$AstroModelFromJson(json);

  Map<String, dynamic> toJson() => _$AstroModelToJson(this);

  Astro toDomain() => Astro(sunrise: sunrise, sunset: sunrise);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class DayModel {
  final double? maxtempC;
  final double? maxtempF;
  final double? mintempC;
  final double? mintempF;
  final double? avgtempC;
  final double? avgtempF;
  final ConditionModel? condition;

  DayModel({
    this.maxtempC,
    this.maxtempF,
    this.mintempC,
    this.mintempF,
    this.avgtempC,
    this.avgtempF,
    this.condition,
  });

  factory DayModel.fromJson(Map<String, dynamic> json) => _$DayModelFromJson(json);

  Map<String, dynamic> toJson() => _$DayModelToJson(this);

  Day toDomain() => Day(
    maxTempC: maxtempC,
    maxTempF: maxtempF,
    minTempC: mintempC,
    minTempF: mintempF,
    avgTempC: avgtempC,
    avgTempF: avgtempF,
    condition: condition?.toDomain(),
  );
}

@JsonSerializable(fieldRename: FieldRename.snake)
class HourModel {
  final int? timeEpoch;
  final String? time;
  final double? tempC;
  final double? tempF;
  final int? isDay;
  final ConditionModel? condition;

  HourModel({
    this.timeEpoch,
    this.time,
    this.tempC,
    this.tempF,
    this.isDay,
    this.condition,
  });

  factory HourModel.fromJson(Map<String, dynamic> json) => _$HourModelFromJson(json);

  Map<String, dynamic> toJson() => _$HourModelToJson(this);

  Hour toDomain() => Hour(
    tempC: tempC,
    tempF: tempF,
    time: time,
    timeEpoch: timeEpoch,
    condition: condition?.toDomain(),
    isDay: isDay,
  );
}

@JsonSerializable()
class LocationModel {
  final String? name;
  final String? region;
  final String? country;
  final double? lat;
  final double? lon;
  final String? tzId;
  @JsonKey(name: 'local_time_epoch')
  final int? localTimeEpoch;
  @JsonKey(name: 'local_time')
  final String? localTime;

  LocationModel({
    this.name,
    this.region,
    this.country,
    this.lat,
    this.lon,
    this.tzId,
    this.localTimeEpoch,
    this.localTime,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);

  Location toDomain() => Location(
    name: name,
    region: region,
    country: country,
    lat: lat,
    lon: lon,
    tzId: tzId,
    localTimeEpoch: localTimeEpoch,
    localTime: localTime,
  );
}

AllWeatherInfoModel mapper(Map<String, dynamic>? json) {
  try {
    final data = json?['data'];

    if (data == null || data is! Map<String, dynamic>) {
      return AllWeatherInfoModel();
    }

    return AllWeatherInfoModel.fromJson(data['result']);
  } catch (e) {
    return AllWeatherInfoModel();
  }
}
