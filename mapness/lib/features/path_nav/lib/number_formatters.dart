import 'package:mapness/features/path_nav/lib/enums.dart';

/// @nodoc
extension FormattedDistance on double {
  /// @nodoc
  ({String value, DistanceUnits unit}) formatDistance() {
    if (this >= 1000) {
      final kilometers = this / 1000.0;
      return (value: kilometers.toStringAsFixed(1), unit: DistanceUnits.km);
    } else {
      return (value: ((this / 10).round() * 10).toString(), unit: DistanceUnits.m);
    }
  }
}

extension FormatDuration on int {
  /// @nodoc
  String formatDuration() {
    final minutes = (this / 60.0).floor();
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours > 0) {
      return '${_formatInt(hours)}:${_formatInt(remainingMinutes)}';
    } else {
      return '$remainingMinutes';
    }
  }
}

String _formatInt(int value) => value.toString().padLeft(2, '0');
