import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/providers/vendor_config.dart';
import 'package:mapness/widgets/search/ui/working_hours.dart';

const _thresholdKeys = <String>[
  'balady/poi/working_hours/soon_threshold_minutes',
  'balady/poi/working_hours/near_threshold_minutes',
  'balady/poi/status/near_threshold_minutes',
  'poi/working_hours/soon_threshold_minutes',
  'poi/working_hours/near_threshold_minutes',
];

final workingHoursSoonThresholdProvider = FutureProvider<Duration>((ref) async {
  final vendorConfig = await ref.watch(vendorConfigProvider.future);

  for (final key in _thresholdKeys) {
    final minutes = _parseThresholdMinutes(vendorConfig[key]);
    if (minutes != null) {
      return Duration(minutes: minutes);
    }
  }

  return kDefaultWorkingHoursSoonThreshold;
});

int? _parseThresholdMinutes(value) {
  if (value is int && value > 0) {
    return value;
  }
  if (value is double && value.isFinite && value > 0) {
    return value.round();
  }
  if (value is String) {
    final parsed = int.tryParse(value.trim());
    if (parsed != null && parsed > 0) {
      return parsed;
    }
  }

  return null;
}
