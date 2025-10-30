import 'dart:ui';

import 'package:balady_uikit/core/colorsV2/app_theme.dart';
import 'package:mapness/widgets/search/ui/working_hours.dart';

extension WorkingHoursColorsExt on WorkingHours {
  // https://www.figma.com/design/QtMRUfAFquj1dQD9bQKiD9/POI-card-3.0?node-id=5178-28623&t=oKFYwNNfRSJi3qyU-4
  ({Color text, Color background})? colors(DateTime dateTime, AppColorsThemeV3 colors) {
    if (isBreak(dateTime)) {
      return (text: colors.extra01Default, background: colors.extra01ContainerDefault);
    }
    if (closesIn(dateTime) <= const Duration(minutes: 30)) {
      return (text: colors.errorOnContainer, background: colors.errorContainerDefault);
    }
    return null;
  }
}
