import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/src/components/maneuver_and_limits/models/path_nav_speed_info.dart';
import 'package:flutter/material.dart';

/// [SpeedLimit] is a widget that shows the speed limit.
/// It is a part of the [LimitAlert] widget.
///
/// Example:
/// ```dart
/// SpeedLimit(info: LimitsModel(
///     direction: NaviCameraDirection.front,
///     speed: 60,
///     speedLimit: 50,
///     speedExceed: true,
/// ))
/// ```
///
/// See also:
/// * [Figma]
/// https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?type=design&node-id=3574%3A43095&mode=design&t=RLpSekxOdSEpOaqf-1
class SpeedLimit extends StatelessWidget {
  const SpeedLimit({
    required this.info,
    super.key,
  });

  /// The information about the speed limits and the speed of the vehicle.
  final LimitsModel info;

  static const double size = 48;

  @override
  Widget build(BuildContext context) {
    final bgColor = context.colors.errorOnError;
    final errorColor = context.colors.errorDefault;

    // Didn't added to constants because it's not used in other places
    const shadow = [
      BoxShadow(
        blurRadius: 4,
        color: Color(0xFFE91C21),
        spreadRadius: 1,
      )
    ];

    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: errorColor, width: 4),
          boxShadow: info.speedExceed ? shadow : null,
          color: info.speedExceed ? errorColor : bgColor,
        ),
        child: Center(
          child: Text(
            "${info.speedLimit ?? '--'}",
            style: context.textStyles.h3SemiBold.copyWith(
              color: info.speedExceed ? context.colors.errorOnError : context.colors.staticBlack,
            ),
          ),
        ),
      ),
    );
  }
}
