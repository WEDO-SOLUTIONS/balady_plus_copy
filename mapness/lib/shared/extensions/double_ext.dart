extension DoubleEx on double {
  double toMeters() => this / 1000;
  double toKilometers() => (this / 1000) / 1000;

  double toMinutes() => this / 60;
}
