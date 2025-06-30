import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:dgis_map_platform_interface/src/utils/public_transport_ext.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/stateless_botomsheet_controller_hook.dart';
import 'package:mapness/widgets/routing/lib/duration_distance_fmt.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/path_public_card.dart';

@RoutePage()
class RouteDetailsPage extends HookConsumerWidget {
  final BriefPublicTransportModel route;

  const RouteDetailsPage({
    required this.route,
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
    final transfers = '${route.transferCount.toString()} transfers';

    return StatelessBottomSheet(
      scrollController: scrollController,
      backgroundColor: context.colorsV3.backgroundSurface4,
      header: Container(
          color: context.colorsV3.backgroundSurface1,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: Row(
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
                        time: pub.distanceToPedestrianTime(
                          isPedestrian ? pub.length.millimeters : null,
                        ),
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
              _buildInfoRow(
                context,
                icon: Icons.access_time,
                title: 'Duration',
                value: duration,
              ),
              Spacing.$3x.heightBox,
              _buildInfoRow(
                context,
                icon: Icons.swap_horiz,
                title: 'Transfers',
                value: transfers,
              ),
              Spacing.$3x.heightBox,
              _buildInfoRow(
                context,
                icon: Icons.route,
                title: context.l10n.route,
                value: route.transports.map((e) => e.names.join(', ')).join(' → '),
              ),
              Spacing.$4x.heightBox,
              Text(
                'Route Details',
                style: context.textStyleV3.h4SemiBold.copyWith(
                  color: context.colorsV3.foregroundDefault,
                ),
              ),
              Spacing.$2x.heightBox,
              Text(
                'This route uses public transportation including ${route.transports.where((t) => t.names.isNotEmpty).length} different transport lines.',
                style: context.textStyleV3.bodySmallRegular.copyWith(
                  color: context.colorsV3.foregroundSoft,
                ),
              ),
              Spacing.$2x.heightBox,
              Text(
                'The journey includes ${route.transferCount} transfer${route.transferCount > 1 ? 's' : ''} between different transport modes.',
                style: context.textStyleV3.bodySmallRegular.copyWith(
                  color: context.colorsV3.foregroundSoft,
                ),
              ),
              Spacing.$2x.heightBox,
              Text(
                'Total travel time is approximately $duration.',
                style: context.textStyleV3.bodySmallRegular.copyWith(
                  color: context.colorsV3.foregroundSoft,
                ),
              ),
              Spacing.$6x.heightBox,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: context.colorsV3.foregroundSoft,
        ),
        Spacing.$2x.widthBox,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textStyleV3.bodySmallRegular.copyWith(
                  color: context.colorsV3.foregroundSoft,
                ),
              ),
              Text(
                value,
                style: context.textStyleV3.bodyLargeSemiBold.copyWith(
                  color: context.colorsV3.foregroundDefault,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
