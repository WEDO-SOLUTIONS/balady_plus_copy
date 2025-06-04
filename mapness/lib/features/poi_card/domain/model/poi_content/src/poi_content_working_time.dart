class PoiContentWorkTimeModel {
  final String workHours;
  final String? breakHours;
  final List<PoiContentWorkTimeDay>? days;
  final String? additionalInfo;

  const PoiContentWorkTimeModel({
    required this.workHours,
    this.breakHours,
    this.days,
    this.additionalInfo,
  });
}

class PoiContentWorkTimeDay {
  final String dayTitle;
  final String workHours;
  final String? breakHours;

  const PoiContentWorkTimeDay({
    required this.dayTitle,
    required this.workHours,
    this.breakHours,
  });
}
