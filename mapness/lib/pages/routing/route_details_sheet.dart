import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/pages/routing/ui/models/routing_details_ui_model.dart';
import 'package:mapness/pages/routing/ui/models/roution_details_ext.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/stateless_botomsheet_controller_hook.dart';
import 'package:mapness/shared/lib/ar_functions.dart';
import 'package:mapness/widgets/path_nav/lib/utils.dart';
import 'package:mapness/widgets/routing/lib/duration_distance_fmt.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/path_public_card.dart';
import 'package:urbi_utils/urbi_utils.dart';

@RoutePage()
class RouteDetailsPage extends HookConsumerWidget {
  final String? destination;
  final BriefPublicTransportModel route;
  final void Function()? onPressed;
  final String buttonLabel;

  const RouteDetailsPage({
    required this.route,
    required this.buttonLabel,
    this.destination,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useStatelessBottomsheetController(
      onClose: (controller) {
        context.router.popForced();
      },
      heightModel: BottomSheetHeightModel.aspect(0.7),
    );

    final duration = route.duration.formatDuration(context.l10n);
    final transfers = ArPlurals.transfers(route.transferCount, context.l10n);

    final List<RouteDetailsPublicTransport> transports = [];
    for (var e in route.publicTransportTransferRouteLongEntry) {
      if (e.value.routeParts.isEmpty) {
        transports.add(RouteDetailsPublicTransportPedestrian(length: e.length.millimeters));
      } else {
        final routeParts = <RoutePart>[];

        // TODO: Probably not right
        for (var routePart in e.value.routeParts) {
          final part = RoutePart(stations: [
            e.value.startPointName,
            ...routePart.intermediateStops.map((e) => e.name),
            e.value.finishPointName,
          ]);
          routeParts.add(part);
        }
        transports.add(RouteDetailsPublicTransportMetro(length: e.length.millimeters, routeParts: routeParts));
      }
    }

    return StatelessBottomSheet(
      scrollController: scrollController,
      backgroundColor: context.colorsV3.backgroundSurface4,
      header: Container(
          color: context.colorsV3.backgroundSurface1,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 64),
              Column(
                children: [
                  Text(
                    duration,
                    style: context.textStyleV3.h4SemiBold.copyWith(
                      color: context.colorsV3.foregroundDefault,
                    ),
                  ),
                  Text(
                    transfers,
                    style: context.textStyleV3.bodySmallRegular.copyWith(
                      color: context.colorsV3.foregroundSoft,
                    ),
                  ),
                  const SizedBox(height: Spacing.$3x),
                  Row(
                    children: route.transports.mapIndexed((index, e) {
                      final pub = route.publicTransportTransferRouteLongEntry[index];
                      final isPedestrian = pub.value.routeParts.isEmpty;
                      return TransportIconWidget(
                        isLarge: true,
                        name: e.names.join(', '),
                        time: isPedestrian ? durationByFoot(pub.length.millimeters) : null,
                        isLast: e == route.transports.last,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: Spacing.$4x),
                ],
              ),
              BaladyAppButton.close(
                buttonType: BaladyButtonType.secondary,
                onTap: context.router.popForced,
              ),
            ],
          )),
      content: [
        Padding(
          padding: const EdgeInsets.all(Spacing.$4x),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContentWrapper(
                color: context.colorsV3.backgroundSurface1,
                children: [
                  ContentRowV2(
                    leading: Icon(
                      TransportIcons.locationFullLTR,
                      color: context.colorsV3.accentDefault,
                      size: 24,
                    ),
                    text: ContentRowTextOptions(
                      title: context.l10n.myLocation,
                    ),
                  ),
                ],
              ),
              Spacing.$4x.heightBox,
              ...transports.map((e) => e.toWidget(context)).insertBetween(Spacing.$2x.heightBox),
              if (destination != null) ...[
                Spacing.$4x.heightBox,
                ContentWrapper(
                  color: context.colorsV3.backgroundSurface1,
                  children: [
                    ContentRowV2(
                      leading: Icon(
                        GeneralIcons.bulletCircleSolid,
                        color: context.colorsV3.accentDefault,
                        size: 24,
                      ),
                      text: ContentRowTextOptions(
                        title: destination,
                      ),
                    ),
                  ],
                ),
              ],
              Spacing.$2x.heightBox,
              if (onPressed != null)
                SizedBox(
                  width: double.infinity,
                  child: BaladyAppButton(
                    padding: const EdgeInsets.symmetric(vertical: Spacing.$3x),
                    buttonColorScheme: BaladyButtonColorScheme.accentSecondary,
                    size: BaladyButtonSize.large,
                    primaryLabel: buttonLabel,
                    onTap: () {
                      context.router.popForced();
                      onPressed?.call();
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
