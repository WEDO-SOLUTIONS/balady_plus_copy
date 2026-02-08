import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

typedef _State = ManeuverMessageState;

/// [BaladyManeuverMessage] is a widget that shows the message if we don't have an information about the maneuver.
/// For example, if the internet is not available, some error occurred, or the route is recalculated.
/// The message will be shown as a small card with the loader icon and the message itself.
///
/// Example:
/// ```dart
/// BaladyManeuverMessage(
///  message: ManeuverMessageModel(
///   state: ManeuverMessageState.error,
///  comment: 'No internet connection',
/// ),
/// )
/// ```
///
/// See also:
/// * [Figma]
/// https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?type=design&node-id=3574%3A43095&mode=design&t=RLpSekxOdSEpOaqf-1
class BaladyManeuverMessage extends StatelessWidget {
  /// The message and state to be displayed on the map.
  final ManeuverMessageModel message;

  /// Constructor
  const BaladyManeuverMessage({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(
          maxWidth: 180,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RadiusBorder.xl),
          color: switch (message.state) {
            _State.error => context.colors.errorDefault,
            _State.reroute => context.colors.successDefault,
          },
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.$3x,
            vertical: Spacing.$3x,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Loading.small(loaderStyle: LoaderStyle.white),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  message.comment,
                  style: context.textStyles.bodyLargeMedium.copyWith(
                    color: context.colors.errorOnError,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
}
