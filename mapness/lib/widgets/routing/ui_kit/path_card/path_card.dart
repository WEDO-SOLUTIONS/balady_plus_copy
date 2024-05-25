import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:balady_uikit/core/typedef/app_typedef.dart';
import 'package:flutter/material.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/extensions/icon_from_type.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/extensions/priority_color.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/models/path_card_localization.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/models/path_card_status.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/path_card_wrapper.dart';
import 'package:urbi_utils/urbi_utils.dart';

part 'icon_and_block.dart';
part 'path_status.dart';

class PathCard extends StatelessWidget {
  final String duration;
  final String distance;

  final PathCardLocalization localizations;
  final bool isPedestrian;
  final num? calories;
  final num? steps;
  final OnTap? onStartTap;
  final PathCardStatus? additionalInfo;

  const PathCard({
    required this.duration,
    required this.distance,
    required this.localizations,
    required this.isPedestrian,
    this.additionalInfo,
    this.calories,
    this.steps,
    this.onStartTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => PathCardWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(duration, style: context.textStyle.callout),
                      Row(
                        children: <Widget>[
                          Text(
                            distance,
                            style: context.textStyle.caption,
                          ),
                          if (additionalInfo != null) ...[
                            Text(
                              '·',
                              style: context.textStyle.caption,
                            ),
                            _PathBadge(additionalInfo!),
                          ],
                        ]
                            .insertBetween(
                              Spacing.horizontalGapBetweenChipContent.widthBox,
                            )
                            .toList(),
                      )
                    ],
                  ),
                ),
                AppButton(
                  buttonColorScheme: ButtonColorScheme.primary,
                  onTap: onStartTap,
                  size: ButtonSize.small,
                  primaryLabel: localizations.go,
                  innerPadding: const EdgeInsets.symmetric(
                    horizontal: NumericBase.$5x,
                  ),
                )
              ],
            ),
            if (isPedestrian && (calories != null || steps != null)) ...[
              Spacing.verticalGapBetweenChips.heightBox,
              SizedBox(
                height: 24,
                child: Row(
                  children: <Widget>[
                    if (calories != null) ...[
                      _IconAndTextBlock(
                        icon: EventsOnTheRoute.calories,
                        value: calories!.toInt(),
                        label: localizations.calories,
                      ),
                    ],
                    if (steps != null) ...[
                      _IconAndTextBlock(
                        icon: getStepIcon(context),
                        value: steps!.toInt(),
                        label: localizations.steps,
                      ),
                    ],
                  ]
                      .insertBetween(
                        Spacing.horizontalGapBetweenChips.widthBox,
                      )
                      .toList(),
                ),
              ),
            ],
          ],
        ),
      );

  IconData getStepIcon(BuildContext context) {
    if (Directionality.of(context) == TextDirection.ltr) {
      return EventsOnTheRoute.stepPedestrianLtr;
    } else {
      return EventsOnTheRoute.stepPedestrianRtl;
    }
  }
}
