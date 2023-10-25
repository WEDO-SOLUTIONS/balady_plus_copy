/// @nodoc
extension FormattedDistance on double {
  /// @nodoc
  String formatDistance() {
    if (this >= 1000) {
      final kilometers = this / 1000.0;
      return '${kilometers.toStringAsFixed(1)} km';
    } else {
      return '$this m';
    }
  }
}

/// @nodoc
extension FormattedDuration on int {
  /// @nodoc
  String formatDuration() {
    final minutes = (this / 60.0).floor();
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours > 0) {
      return '$hours h $remainingMinutes min';
    } else {
      return '$remainingMinutes min';
    }
  }
}
