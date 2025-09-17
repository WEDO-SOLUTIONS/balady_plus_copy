extension DateTimeExt on DateTime {
  (int, int) differentNowHoursAndMinutes() {
    final date = this;
    final now = DateTime.now();

    final difference = now.difference(date);

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    return (hours, minutes);
  }

  String formattedHourMinute() {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
