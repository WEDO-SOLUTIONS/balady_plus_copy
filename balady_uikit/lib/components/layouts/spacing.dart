import 'package:balady_uikit/components/layouts/numeric_base.dart';

class Spacing {
  static const nonAny = 0;

  ///vertical base
  ///от контента до NavigationBar
  static const verticalBaseToTopSafezone = NumericBase.$3x;
  ///от контента до верхней границы шторки
  static const verticalBaseToTopModal = NumericBase.$4x;
  ///от контента до нижней границы экрана, навбара, home indicator
  static const verticalBaseToBottomSafezone = NumericBase.$6x;

  ///vertical gap
  ///между контентом внутри обертки
  static const verticalGapBetweenWrapperContent = NumericBase.$3x;
  ///между контентом внутри ячейки
  static const verticalGapBetweenCellContent = NumericBase.$0_5x;
  ///между карточками
  static const verticalGapBetweenCards = NumericBase.$4x;
  ///между чипсами фильтрами
  static const verticalGapBetweenChips = NumericBase.$2x;
  ///между сторисами
  static const verticalGapBetweenStories = NumericBase.$2x;
  ///между кнопками
  static const verticalGapBetweenButtons = NumericBase.$3x;
  ///между фотографиями в коллаже
  static const verticalGapBetweenCollage = NumericBase.$0_5x;

  ///vertical padding
  ///от контента до границ обертки
  static const verticalPaddingInsideWrapper = NumericBase.$4x;
  ///от контента до границ ячейки
  static const verticalPaddingInsideCell = NumericBase.$3x;

  static const horizontalPaddingInsideCell = NumericBase.$3x;
  static const horizontalPaddingInsideWrapper = NumericBase.$4x;

  ///horizontal base
  ///от контента до границ устройства
  static const horizontalBaseToDeviceViewBox = NumericBase.$4x;

  ///horizontal gap
  ///между контентом внутри обертки
  static const horizontalGapBetweenWrapperContent = NumericBase.$3x;
  ///между контентом внутри ячейки
  static const horizontalGapBetweenCellContent = NumericBase.$3x;
  ///между чипс фильтрами
  static const horizontalGapBetweenChips = NumericBase.$2x;
  ///между контентом внутри чипсины
  static const horizontalGapBetweenChipContent = NumericBase.$1x;
  ///между карточками
  static const horizontalGapBetweenCards = NumericBase.$4x;
  ///между сторизами
  static const horizontalGapBetweenStories = NumericBase.$2x;
  ///между кнопками
  static const horizontalGapBetweenButtons = NumericBase.$3x;
  ///между контентом внутри кнопки
  static const horizontalGapBetweenButtonContent = NumericBase.$1_5x;
  ///между фотографиями в коллаже
  static const horizontalGapBetweenCollage = NumericBase.$0_5x;
}
