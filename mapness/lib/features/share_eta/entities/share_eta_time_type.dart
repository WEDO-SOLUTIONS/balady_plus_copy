enum ShareEtaTimeType { fiveteenMinutes, oneHour, eightHours }

extension ShareEtaTimeTypeExtension on ShareEtaTimeType {
  int get durationInMinutes {
    switch (this) {
      case ShareEtaTimeType.fiveteenMinutes:
        return 15;
      case ShareEtaTimeType.oneHour:
        return 60;
      case ShareEtaTimeType.eightHours:
        return 480;
    }
  }
}
