import '../../../../../core/utils/utils_exports.dart' show Prayers;
import '../../prayer_times_exports.dart' show PrayerTimeEntity;

class PrayerTimeModel extends PrayerTimeEntity {
  const PrayerTimeModel({
    required super.prayer,
    required super.time,
    required super.hour,
    required super.minute,
  });

  factory PrayerTimeModel.fromMap(
    Map<String, dynamic> map, {
    required Prayers prayer,
  }) {
    return PrayerTimeModel(
      prayer: prayer,
      time: map['time'] as String,
      hour: map['hour'] as int,
      minute: map['minute'] as int,
    );
  }
}
