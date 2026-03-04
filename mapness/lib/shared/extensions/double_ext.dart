import 'dart:math';

extension DoubleEx on double {
  double toMeters() => this / 1000;

  double toKilometers() => (this / 1000) / 1000;

  double toMinutes() => this / 60;

  double roundDecimal(int decimal) => double.parse(toStringAsFixed(decimal));

  /// Returns true if [this] is equal to [other] with specified precision
  bool isRoughlyEqual(double other, {int decimalPlaces = 4}) => (this - other).abs() < pow(0.1, decimalPlaces);
}
