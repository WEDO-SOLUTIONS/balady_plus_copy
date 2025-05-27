import 'package:mapness/shared/extensions/markers_from_search.dart';

extension SizeExtention on num {
  String formatAsFileSize({
    int fractionDigits = 2,
    bool cleanUpFromZeros = true,
  }) {
    const metrics = <String>['B', 'KB', 'MB', 'GB', 'TB', 'PB'];

    final size = this;
    const divider = 1024.0;
    final needToRound = fractionDigits == 0;
    double currentDivider = divider;
    double previousDivider = 0;
    int currentMetric = 0;

    while (size >= currentDivider && currentMetric < metrics.length - 1) {
      previousDivider = currentDivider;
      currentDivider *= divider;
      currentMetric++;
    }

    final resultSize = previousDivider == 0 ? size : size / previousDivider;

    String cropLastSymbol(String str) => str.substring(0, str.length - 1);

    var formattedResult = resultSize.toStringAsFixed(needToRound ? 0 : fractionDigits);
    if (cleanUpFromZeros) {
      while (formattedResult.contains('.') && formattedResult.endsWith('0')) {
        formattedResult = cropLastSymbol(formattedResult);
      }
      if (formattedResult.endsWith('.')) {
        formattedResult = cropLastSymbol(formattedResult);
      }
    }

    return '$formattedResult${metrics[currentMetric]}';
  }

  MapMarkersType? categoryFromId() {
    switch (this) {
      case 1:
        return MapMarkersType.waterPlaces;
      case 2:
        return MapMarkersType.medicalHelp;
      case 3:
        return MapMarkersType.hajjSupport;
      case 4:
        return MapMarkersType.kiosksRetail;
      case 5:
        return MapMarkersType.additional;
      default:
        return MapMarkersType.additional;
    }
  }
}
