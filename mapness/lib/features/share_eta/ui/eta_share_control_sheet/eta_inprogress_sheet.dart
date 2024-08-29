import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/share_eta/ui/eta_share_control_sheet/eta_share_sheet.dart';
import 'package:mapness/features/share_eta/ui/pulse_indicator.dart';

class EtaInprogressSheet extends StatelessWidget {
  final VoidCallback onShareMorePressed;
  final VoidCallback onStopSharePressed;
  final String? timeLeft;

  const EtaInprogressSheet(
      {required this.onShareMorePressed, required this.onStopSharePressed, super.key, this.timeLeft});

  @override
  Widget build(BuildContext context) => EtaShareSheet(
        title: 'Live location is sharing',
        timeLeft: timeLeft,
        subtitleBuilder: (context, timeLeft) => Row(
          children: [
            const PulseIndicator(),
            Spacing.$1_5x.widthBox,
            Text(
              timeLeft,
              style: context.textStyleV3.bodySmallRegular.copyWith(
                color: context.colorsV2.foregroundSoft,
              ),
            ),
          ],
        ),
        contentBuilder: (context) => [
          ContentRow(
            onTap: onShareMorePressed,
            options: ContentRowOptions(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.$4x,
                vertical: Spacing.$3x,
              ),
              dividerEnabled: true,
              title: 'Share more',
              titleStyle: context.textStyleV3.bodyLargeRegular.copyWith(
                color: context.colorsV2.foregroundDefault,
              ),
              leadingIcon: Icon(SystemIcons.share, color: context.colorsV2.foregroundSoft),
            ),
          ),
          ContentRow(
            onTap: onStopSharePressed,
            options: ContentRowOptions(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.$4x,
                vertical: Spacing.$3x,
              ),
              title: 'Stop sharing',
              titleStyle: context.textStyleV3.bodyLargeRegular.copyWith(
                color: context.colorsV2.foregroundDefault,
              ),
              leadingIcon: Icon(GeneralIcons.clearCircle, color: context.colorsV2.foregroundSoft),
            ),
          )
        ],
      );
}
