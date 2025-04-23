extension DateTimeExt on DateTime {
  (int, int) hoursAndMinutes() {
    final date = this;
    final now = DateTime.now();

    final difference = now.difference(date);

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    return (hours, minutes);
  }
}
