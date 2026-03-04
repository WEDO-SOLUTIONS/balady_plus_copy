import 'package:balady_uikit/src/components/map_controls/map_controls.dart';
import 'package:flutter/widgets.dart';

class WeatherStateIcon extends StatelessWidget {
  final Function()? onTap;
  final Widget icon;

  const WeatherStateIcon({
    required this.icon,
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MapButton(
      onTap: onTap,
      child: icon,
    );
  }
}
