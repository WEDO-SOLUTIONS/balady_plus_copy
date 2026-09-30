class AllWeatherInfoEntity {
  final Location? location;
  final Current? current;
  final Forecast? forecast;

  const AllWeatherInfoEntity({
    this.location,
    this.current,
    this.forecast,
  });
}

class Current {
  final double? tempC;
  final double? tempF;
  final int? isDay;
  final Condition? condition;
  final double? windMph;
  final double? windKph;
  final double? pressureMb;
  final double? pressureIn;
  final int? humidity;
  final double? visKm;
  final double? visMiles;

  const Current({
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

  bool defineIsDay() => isDay == 1;
}

class Condition {
  final String? text;
  final String? icon;
  final int? code;

  const Condition({
    this.text,
    this.icon,
    this.code,
  });

  bool get isNight => icon?.contains('night') ?? false;

  /// Bundled SVG for the condition, derived from the provider's PNG icon URL; empty if there is none.
  String get iconPath {
    final icon = this.icon;
    if (code == null || icon == null || icon.isEmpty) {
      return '';
    }
    return isNight
        ? "assets/icons/svg/weather/night/${icon.split("night/").last.replaceAll(".png", ".svg")}"
        : "assets/icons/svg/weather/day/${icon.split("day/").last.replaceAll(".png", ".svg")}";
  }
}

class Forecast {
  final List<ForecastDay>? forecastday;

  const Forecast({
    this.forecastday,
  });
}

class ForecastDay {
  final String? date;
  final int? dateEpoch;
  final Day? day;
  final Astro? astro;
  final List<Hour>? hour;

  const ForecastDay({
    this.date,
    this.dateEpoch,
    this.day,
    this.astro,
    this.hour,
  });
}

class Astro {
  final String? sunrise;
  final String? sunset;

  Astro({
    this.sunrise,
    this.sunset,
  });
}

class Day {
  final double? maxTempC;
  final double? maxTempF;
  final double? minTempC;
  final double? minTempF;
  final double? avgTempC;
  final double? avgTempF;
  final Condition? condition;

  const Day({
    this.maxTempC,
    this.maxTempF,
    this.minTempC,
    this.minTempF,
    this.avgTempC,
    this.avgTempF,
    this.condition,
  });
}

class Hour {
  final int? timeEpoch;
  final String? time;
  final double? tempC;
  final double? tempF;
  final int? isDay;
  final Condition? condition;

  const Hour({
    this.timeEpoch,
    this.time,
    this.tempC,
    this.tempF,
    this.isDay,
    this.condition,
  });
}

class Location {
  final String? name;
  final String? region;
  final String? country;
  final double? lat;
  final double? lon;
  final String? tzId;
  final int? localTimeEpoch;
  final String? localTime;

  const Location({
    this.name,
    this.region,
    this.country,
    this.lat,
    this.lon,
    this.tzId,
    this.localTimeEpoch,
    this.localTime,
  });
}
