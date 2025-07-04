import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:dgis_map_platform_interface/src/utils/public_transport_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/ar_functions.dart';
import 'package:mapness/widgets/routing/lib/duration_distance_fmt.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/models/path_card_localization.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/models/path_card_status.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/path_card_wrapper.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/path_status.dart';
import 'package:urbi_utils/urbi_utils.dart';

class PathPublicCard extends ConsumerWidget {
  final BriefPublicTransportModel route;
  final PathCardLocalization localizations;
  final Function()? onStartNavigation;
  final String? destination;
  final PathCardStatus? additionalInfo;

  const PathPublicCard({
    required this.route,
    required this.localizations,
    this.onStartNavigation,
    this.destination,
    this.additionalInfo,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final duration = route.duration.formatDuration(context.l10n);
    final transfers = ArPlurals.transfers(route.transferCount, context.l10n);

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
                    Row(
                      children: <Widget>[
                        Text(
                          transfers,
                          style: context.textStyleV3.captionMediumRegular,
                        ),
                        if (additionalInfo != null) ...[
                          Text(
                            '·',
                            style: context.textStyle.caption,
                          ),
                          PathBadge(additionalInfo!),
                        ],
                      ].insertBetween(Spacing.$1x.widthBox).toList(),
                    )
                  ],
                ),
              ),
              BaladyAppButton(
                buttonColorScheme: BaladyButtonColorScheme.accentSecondary,
                onTap: onStartNavigation,
                primaryLabel: localizations.go.toUpperCase(),
                innerPadding: const EdgeInsets.symmetric(
                  horizontal: Spacing.$5x,
                ),
              )
            ],
          ),
          Spacing.$4x.heightBox,
          if (route.transports.length > 1) ...[
            Row(
              children: route.transports.mapIndexed((index, e) {
                final pub = route.publicTransportTransferRouteLongEntry[index];
                final isPedestrian = pub.value.routeParts.isEmpty;
                return TransportIconWidget(
                  name: e.names.join(', '),
                  time: pub.distanceToPedestrianTime(
                    isPedestrian ? pub.length.millimeters : null,
                  ),
                  isLast: e == route.transports.last,
                );
              }).toList(),
            ),
            Spacing.$4x.heightBox,
          ],
          BaladyAppButton(
            buttonColorScheme: BaladyButtonColorScheme.accentSecondary,
            buttonType: BaladyButtonType.secondary,
            onTap: () {
              context.router.push(
                RouteDetailsRoute(
                  route: route,
                  destination: destination,
                  onPressed: () async => onStartNavigation?.call(),
                  onClose: () async => context.router.popForced(),
                  buttonLabel: context.l10n.go.toUpperCase(),
                ),
              );
            },
            primaryLabel: context.l10n.aboutRoute,
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

class TransportIconWidget extends StatelessWidget {
  final String name;
  final int? time;
  final bool isLast;
  final bool isLarge;

  const TransportIconWidget({
    required this.name,
    this.time,
    this.isLast = false,
    this.isLarge = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          _buildIcon(name, context),
          if (time != null) ...[
            Text(
              '$time',
              style: context.textStyleV3.bodyLargeRegular.copyWith(
                color: context.colorsV3.neutralOnContainer,
              ),
            ),
          ],
          if (!isLast)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isLarge ? Spacing.$1_5x : Spacing.$1x),
              child: Icon(
                SystemIcons.arrowCornerRightSmall,
                size: 16,
                color: context.colorsV3.foregroundMuted,
              ),
            ),
        ],
      );

  Widget _buildIcon(String line, BuildContext context) {
    if (line.isEmpty) {
      return Icon(
        TransportIcons.pedestrianLTR,
        size: isLarge ? 24 : 16,
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
      size: isLarge ? 24 : 16,
      color: color,
    );
  }
}
