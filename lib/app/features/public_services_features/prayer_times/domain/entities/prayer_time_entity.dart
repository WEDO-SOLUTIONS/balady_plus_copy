import 'package:equatable/equatable.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart' show Prayers;

class PrayerTimeEntity extends Equatable {
  final Prayers prayer;
  final String time;
  final int hour;
  final int minute;

  const PrayerTimeEntity({
    required this.prayer,
    required this.time,
    required this.hour,
    required this.minute,
  });

  String formattedTime() {
    final hour = this.hour > 12 ? this.hour - 12 : this.hour;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} ${this.hour < 12 ? 'am'.tr() : 'pm'.tr()}';
  }

  DateTime get dateTime {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  @override
  List<Object?> get props => [prayer, time, hour, minute];
}
