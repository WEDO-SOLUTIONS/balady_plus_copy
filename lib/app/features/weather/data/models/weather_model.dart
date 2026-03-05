import 'dart:convert';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/weather/weather_exports.dart';

class AllWeatherInfoModel extends AllWeatherInfoEntity {
  AllWeatherInfoModel({super.alerts, super.current, super.forecast, super.location});

  //generate from json
  // factory AllWeatherInfoModel.fromMap(Map<String, dynamic> json) =>
  //     AllWeatherInfoModel(
  //       alerts: json["alerts"],
  //       current: json["current"],
  //       forecast: json["forecast"],
  //       location: json["location"],
  //     );
}

class AlertsModel extends Alerts {
  AlertsModel({super.alert});

  factory AlertsModel.fromRawJson(String str) => AlertsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AlertsModel.fromJson(Map<String, dynamic> json) {
    final jsonData = json["alert"] as List<dynamic>;

    return AlertsModel(
      alert: jsonData.isEmpty
          ? []
          : List<AlertModel>.from(
              jsonData.map(
                (x) {
                  AlertModel model = AlertModel.fromJson(x);
                  return model;
                },
              ),
            ),
    );
  }
  Map<String, dynamic> toJson() => {
        "alert": alert == null ? null : List<dynamic>.from(alert!.map((x) => x.toJson())),
      };
}

class AlertModel extends Alert {
  AlertModel({
    super.headline,
    super.msgtype,
    super.severity,
    super.urgency,
    super.areas,
    super.category,
    super.certainty,
    super.event,
    super.note,
    super.effective,
    super.expires,
    super.desc,
    super.instruction,
  });

  factory AlertModel.fromRawJson(String str) => AlertModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AlertModel.fromJson(Map<String, dynamic> json) => AlertModel(
        headline: json["headline"],
        msgtype: json["msgtype"],
        severity: json["severity"],
        urgency: json["urgency"],
        areas: json["areas"],
        category: json["category"],
        certainty: json["certainty"],
        event: json["event"],
        note: json["note"],
        effective: json["effective"] == null ? null : DateTime.parse(json["effective"]),
        expires: json["expires"] == null ? null : DateTime.parse(json["expires"]),
        desc: json["desc"],
        instruction: json["instruction"],
      );

  Map<String, dynamic> toJson() => {
        "headline": headline,
        "msgtype": msgtype,
        "severity": severity,
        "urgency": urgency,
        "areas": areas,
        "category": category,
        "certainty": certainty,
        "event": event,
        "note": note,
        "effective": effective?.toIso8601String(),
        "expires": expires?.toIso8601String(),
        "desc": desc,
        "instruction": instruction,
      };
}

class CurrentModel extends Current {
  CurrentModel({
    super.cloud,
    super.condition,
    super.feelslikeC,
    super.feelslikeF,
    super.gustKph,
    super.gustMph,
    super.humidity,
    super.isDay,
    super.lastUpdated,
    super.lastUpdatedEpoch,
    super.precipIn,
    super.precipMm,
    super.pressureIn,
    super.pressureMb,
    super.tempC,
    super.tempF,
    super.uv,
    super.visKm,
    super.visMiles,
    super.windDegree,
    super.windDir,
    super.windKph,
    super.windMph,
  });

  //generate from json
  factory CurrentModel.fromMap(Map<String, dynamic> json, ConditionsModel condition) => CurrentModel(
        cloud: json["cloud"],
        feelslikeC: json["feelslike_c"],
        feelslikeF: json["feelslike_f"],
        gustKph: json["gust_kph"],
        gustMph: json["gust_mph"],
        humidity: json["humidity"],
        isDay: json["is_day"],
        lastUpdated: json["last_updated"],
        lastUpdatedEpoch: json["last_updated_epoch"],
        precipIn: json["precip_in"],
        precipMm: json["precip_mm"],
        pressureIn: json["pressure_in"],
        pressureMb: json["pressure_mb"],
        tempC: json["temp_c"],
        tempF: json["temp_f"],
        uv: json["uv"],
        visKm: json["vis_km"],
        visMiles: json["vis_miles"],
        windDegree: json["wind_degree"],
        windDir: json["wind_dir"],
        windKph: json["wind_kph"],
        windMph: json["wind_mph"],
        condition: condition,
      );
}

class ConditionsModel extends Condition {
  ConditionsModel({
    super.code,
    super.icon,
    super.text,
  });

  //generate from json
  factory ConditionsModel.fromMap(Map<String, dynamic> json) => ConditionsModel(
        code: json["code"],
        icon: json["icon"],
        text: json["text"],
      );
}

class ForecastModel extends Forecast {
  ForecastModel({super.forecastday});
}

class ForecastDayModel extends ForecastDay {
  ForecastDayModel({
    super.astro,
    super.date,
    super.dateEpoch,
    super.day,
    super.hour,
  });

  //generate from json
  factory ForecastDayModel.fromMap(Map<String, dynamic> json, Astro astro, Day day, List<Hour> hour) =>
      ForecastDayModel(
        date: json["date"],
        dateEpoch: json["date_epoch"],
        astro: astro,
        day: day,
        hour: hour,
      );
}

class AstroModel extends Astro {
  AstroModel({
    super.isMoonUp,
    super.isSunUp,
    super.moonIllumination,
    super.moonPhase,
    super.moonrise,
    super.moonset,
    super.sunrise,
    super.sunset,
  });

  //generate from json
  factory AstroModel.fromMap(Map<String, dynamic> json) => AstroModel(
        isMoonUp: json["is_moon_up"],
        isSunUp: json["is_sun_up"],
        moonIllumination: json["moon_illumination"],
        moonPhase: json["moon_phase"],
        moonrise: json["moonrise"],
        moonset: json["moonset"],
        sunrise: json["sunrise"],
        sunset: json["sunset"],
      );
}

class DayModel extends Day {
  DayModel({
    super.maxtempC,
    super.maxtempF,
    super.mintempC,
    super.mintempF,
    super.avgtempC,
    super.avgtempF,
    super.maxwindMph,
    super.maxwindKph,
    super.totalprecipMm,
    super.totalprecipIn,
    super.totalsnowCm,
    super.avgvisKm,
    super.avgvisMiles,
    super.avghumidity,
    super.dailyWillItRain,
    super.dailyChanceOfRain,
    super.dailyWillItSnow,
    super.dailyChanceOfSnow,
    super.condition,
    super.uv,
  });

  //generate from json

  factory DayModel.fromMap(Map<String, dynamic> json, ConditionsModel condition) => DayModel(
        maxtempC: json["maxtemp_c"],
        maxtempF: json["maxtemp_f"],
        mintempC: json["mintemp_c"],
        mintempF: json["mintemp_f"],
        avgtempC: json["avgtemp_c"],
        avgtempF: json["avgtemp_f"],
        maxwindMph: json["max_wind_mph"],
        maxwindKph: json["max_wind_kph"],
        totalprecipMm: json["total_precip_mm"],
        totalprecipIn: json["total_precip_in"],
        totalsnowCm: json["total_snow_cm"],
        avgvisKm: json["avg_vis_km"],
        avgvisMiles: json["avg_vis_miles"],
        avghumidity: json["avg_humidity"],
        dailyWillItRain: json["daily_will_it_rain"],
        dailyChanceOfRain: json["daily_chance_of_rain"],
        dailyWillItSnow: json["daily_will_it_snow"],
        dailyChanceOfSnow: json["daily_chance_of_snow"],
        uv: json["uv"],
        condition: condition,
      );
}

class HourModel extends Hour {
  HourModel({
    super.timeEpoch,
    super.time,
    super.tempC,
    super.tempF,
    super.isDay,
    super.condition,
    super.windMph,
    super.windKph,
    super.windDegree,
    super.windDir,
    super.pressureMb,
    super.pressureIn,
    super.precipMm,
    super.precipIn,
    super.humidity,
    super.cloud,
    super.feelslikeC,
    super.feelslikeF,
    super.windchillC,
    super.windchillF,
    super.heatindexC,
    super.heatindexF,
    super.dewpointC,
    super.dewpointF,
    super.willItRain,
    super.chanceOfRain,
    super.willItSnow,
    super.chanceOfSnow,
    super.visKm,
    super.visMiles,
    super.gustMph,
    super.gustKph,
    super.uv,
  });

  //generate from json
  factory HourModel.fromMap(Map<String, dynamic> json, ConditionsModel condition) => HourModel(
        timeEpoch: json["time_epoch"],
        time: json["time"],
        tempC: json["temp_c"],
        tempF: json["temp_f"],
        isDay: json["is_day"],
        windMph: json["wind_mph"],
        windKph: json["wind_kph"],
        windDegree: json["wind_degree"],
        windDir: json["wind_dir"],
        pressureMb: json["pressure_mb"],
        pressureIn: json["pressure_in"],
        precipMm: json["precip_mm"],
        precipIn: json["precip_in"],
        humidity: json["humidity"],
        cloud: json["cloud"],
        feelslikeC: json["feelslike_c"],
        feelslikeF: json["feelslike_f"],
        windchillC: json["windchill_c"],
        windchillF: json["windchill_f"],
        heatindexC: json["heatindex_c"],
        heatindexF: json["heatindex_f"],
        dewpointC: json["dewpoint_c"],
        dewpointF: json["dewpoint_f"],
        willItRain: json["will_it_rain"],
        chanceOfRain: json["chance_of_rain"],
        willItSnow: json["will_it_snow"],
        chanceOfSnow: json["chance_of_snow"],
        visKm: json["vis_km"],
        visMiles: json["vis_miles"],
        gustMph: json["gust_mph"],
        gustKph: json["gust_kph"],
        uv: json["uv"],
        condition: condition,
      );
}

class LocationModel extends Location {
  LocationModel({
    super.name,
    super.region,
    super.country,
    super.lat,
    super.lon,
    super.tzId,
    super.localtimeEpoch,
    super.localtime,
  });

  //generate from json
  factory LocationModel.fromMap(Map<String, dynamic> json) => LocationModel(
        name: json["name"],
        region: json["region"],
        country: json["country"],
        lat: json["lat"],
        lon: json["lon"],
        tzId: json["tzId"],
        localtimeEpoch: json["local_time_epoch"],
        localtime: json["local_time"],
      );
}
