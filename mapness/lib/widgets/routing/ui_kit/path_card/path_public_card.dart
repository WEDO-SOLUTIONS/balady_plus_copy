import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/routing/lib/duration_distance_fmt.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/models/path_card_localization.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/path_card_wrapper.dart';

class PathPublicCard extends StatelessWidget {
  final BriefPublicTransportModel route;
  final PathCardLocalization localizations;

  const PathPublicCard({
    required this.route,
    required this.localizations,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final duration = route.duration.formatDuration(context.l10n);
    final transfers = '${route.transferCount.toString()} transfers';

    return PathCardWrapper(
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
                    Text(duration, style: context.textStyleV3.bodyLargeSemiBold),
                    const SizedBox(height: Spacing.$1x),
                    Text(
                      transfers,
                      style: context.textStyleV3.captionMediumRegular,
                    ),
                  ],
                ),
              ),
              BaladyAppButton(
                buttonColorScheme: BaladyButtonColorScheme.accentSecondary,
                onTap: () {},
                primaryLabel: localizations.go.toUpperCase(),
                innerPadding: const EdgeInsets.symmetric(
                  horizontal: Spacing.$5x,
                ),
              )
            ],
          ),
          Spacing.$4x.heightBox,
          Row(
            children: route.transports
                .map((e) => _TransportIcon(name: e.names.join(', '), isLast: e == route.transports.last))
                .toList(),
          ),
          Spacing.$4x.heightBox,
          BaladyAppButton(
            buttonColorScheme: BaladyButtonColorScheme.accentSecondary,
            buttonType: BaladyButtonType.secondary,
            onTap: () {
              // TODO: Push
            },
            primaryLabel: context.l10n.about,
          )
        ],
      ),
    );
  }

  IconData getStepIcon(BuildContext context) {
    if (Directionality.of(context) == TextDirection.ltr) {
      return TransportIcons.pedestrianLTR;
    } else {
      return TransportIcons.pedestrianRTL;
    }
  }
}

class _TransportIcon extends StatelessWidget {
  final String name;
  final bool isLast;

  const _TransportIcon({required this.name, this.isLast = false});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          _buildIcon(name, context),
          Spacing.$1x.widthBox,
          if (!isLast)
            Icon(
              SystemIcons.arrowCornerRightSmall,
              size: 16,
              color: context.colorsV3.neutralOnContainer,
            ),
        ],
      );

  Widget _buildIcon(String line, BuildContext context) {
    if (line.isEmpty) {
      return Icon(
        TransportIcons.pedestrianLTR,
        size: 16,
        color: context.colorsV3.neutralOnContainer,
      );
    }
    Color? color;
    if (line.contains('Blue')) {
      color = Colors.blue;
    } else if (line.contains('Red')) {
      color = context.colorsV3.errorDefault;
    } else if (line.contains('Green')) {
      color = context.colorsV3.successDefault;
    }
    return Icon(
      TransportIcons.metroStation,
      size: 16,
      color: color,
    );
  }
}
