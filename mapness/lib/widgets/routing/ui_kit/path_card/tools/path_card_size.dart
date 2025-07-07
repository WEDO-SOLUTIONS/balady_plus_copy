import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';

/// This class is used to calculate the size of the path card
/// The height and width is predefined by the design team
/// So we can use it as source of truth for the card size and all its components
///
/// See also:
/// * [Figma] https://www.figma.com/design/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?m=dev&node-id=7165-36707
extension PathCardSizeExt on RouteSearchOptionsMessage {
  double get cardHeight => switch (this) {
        RouteSearchOptionsMessage.pedestrian => 96,
        RouteSearchOptionsMessage.publicTransport => 160,
        RouteSearchOptionsMessage.car ||
        RouteSearchOptionsMessage.bicycle ||
        RouteSearchOptionsMessage.scooter ||
        RouteSearchOptionsMessage.truck ||
        RouteSearchOptionsMessage.taxi =>
          64
      };

  static const fixedCardWidth = 264.0;
  double get cardWidthWithPadding => fixedCardWidth + 2 * Spacing.$2x;
}
