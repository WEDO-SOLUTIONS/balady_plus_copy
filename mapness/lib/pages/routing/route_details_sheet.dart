// ignore_for_file: unused_local_variable, dead_code

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/features/routing/providers/public_transport_arrived.dart';
import 'package:mapness/pages/routing/route_details_state_mapper.dart';
import 'package:mapness/pages/routing/ui/models/routing_details_ui_model.dart';
import 'package:mapness/pages/routing/ui/models/roution_details_ext.dart';
import 'package:mapness/shared/extensions/bottom_sheet_controller_helper_extension.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/ar_functions.dart';
import 'package:mapness/widgets/routing/lib/duration_distance_fmt.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/path_public_card.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/tools/public_transport_colors.dart';
import 'package:urbi_utils/urbi_utils.dart';

@RoutePage()
class RouteDetailsPage extends ConsumerStatefulWidget {
  final String? destination;
  final BriefPublicTransportModel route;
  final Future<void> Function()? onPressed;
  final Future<void> Function()? onClose;
  final String buttonLabel;
  final String? startPoint;
  final ThreeStateBottomSheet initialState;

  const RouteDetailsPage({
    required this.route,
    required this.buttonLabel,
    this.destination,
    this.onPressed,
    this.onClose,
    this.startPoint,
    this.initialState = ThreeStateBottomSheet.open,
    super.key,
  });

  @override
  ConsumerState<RouteDetailsPage> createState() => _RouteDetailsPageState();
}

class _RouteDetailsPageState extends ConsumerState<RouteDetailsPage> {
  late final StatefulBottomSheetController<ThreeStateBottomSheet> _bottomSheetController;
  List<RouteDetailsPublicTransport>? _transports;

  @override
  void initState() {
    super.initState();
    _bottomSheetController = StatefulBottomSheetController(
      behavior: AspectRatioSnappingBehavior(aspectRatios: {0.0, 0.85}),
      stateMapper: const RouteDetailsStateMapper(),
      initialState: widget.initialState,
    );
  }

  @override
  void dispose() {
    _bottomSheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final duration = widget.route.duration.formatDuration(context.l10n);
    final transfers = ArPlurals.transfers(widget.route.transferCount, context.l10n);

    _transports ??= _getTransports(context);

    // Watch the arrival detection provider
    final arrivalState = ref.watch(publicTransportArrivedProvider(
      route: widget.route,
      destination: widget.destination,
    ));

    return StatefulBottomSheet<ThreeStateBottomSheet>(
      scrollController: _bottomSheetController,
      backgroundColor: context.colorsV3.backgroundSurface4,
      outsideOpacityDelegate: _bottomSheetController.defaultOpacityDelegate,
      header: _Header(
        route: widget.route,
        destination: widget.destination,
        onClose: () => widget.onClose?.call(),
      ),
      footer: SizedBox(
        width: double.infinity,
        child: BaladyAppButton(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + Spacing.$2x,
            left: Spacing.$4x,
            right: Spacing.$4x,
            top: Spacing.$3x,
          ),
          buttonColorScheme: BaladyButtonColorScheme.accentSecondary,
          size: BaladyButtonSize.large,
          primaryLabel: widget.buttonLabel,
          onTap: () {
            context.router.popForced();
            widget.onPressed?.call();
          },
        ),
      ),
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
                      title: widget.startPoint ?? context.l10n.myLocation,
                    ),
                  ),
                ],
              ),
              Spacing.$2x.heightBox,
              ...(_transports ?? [])
                  .map(
                      (e) => e.toWidget(context, lineColor: e is RouteDetailsPublicTransportMetro ? e.lineColor : null))
                  .insertBetween(Spacing.$2x.heightBox),
              Spacing.$2x.heightBox,
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
                      title: widget.destination ?? context.l10n.destination,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<RouteDetailsPublicTransport> _getTransports(BuildContext context) {
    final transports = <RouteDetailsPublicTransport>[];
    for (var i = 0; i < widget.route.publicTransportTransferRouteLongEntry.length; i++) {
      final e = widget.route.publicTransportTransferRouteLongEntry[i];
      // If route part is empty, it means that we have to show pedestrian transport
      if (e.value.routeParts.isEmpty) {
        transports.add(
          RouteDetailsPublicTransportPedestrian(
            length: e.length.millimeters,
            isTransfer: isTransfer(widget.route.publicTransportTransferRouteLongEntry, i),
          ),
        );
      } else {
        // If route part is not empty, it means that we have to show metro transport
        final routeParts = <RoutePart>[];
        for (final routePart in e.value.routeParts) {
          final part = RoutePart(stations: [
            e.value.startPointName,
            ...routePart.intermediateStops.map((e) => e.name),
            e.value.finishPointName,
          ]);
          routeParts.add(part);
        }
        transports.add(
          RouteDetailsPublicTransportMetro(
            length: e.length.millimeters,
            routeParts: routeParts,
            lineColor: widget.route.transports[i].names.isNotEmpty
                ? getMetroLineColor(widget.route.transports[i].names.first, context)
                : null,
          ),
        );
      }
    }
    return transports;
  }
}

class _Header extends ConsumerStatefulWidget {
  final BriefPublicTransportModel route;
  final String? destination;
  final VoidCallback? onClose;
  const _Header({
    super.key,
    required this.route,
    this.destination,
    this.onClose,
  });

  @override
  ConsumerState<_Header> createState() => _HeaderState();
}

class _HeaderState extends ConsumerState<_Header> {
  @override
  Widget build(BuildContext context) {
    final duration = widget.route.duration.formatDuration(context.l10n);
    final transfers = ArPlurals.transfers(widget.route.transferCount, context.l10n);
    final p = publicTransportArrivedProvider(
      route: widget.route,
      destination: widget.destination,
    );
    final arrivalProvider = ref.watch(p.notifier).checkArrivalNow();
    final arrivalState = ref.watch(p);

    return Container(
      color: context.colorsV3.backgroundSurface1,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
      child: arrivalState.value == true
          ? YouArrivedHeader(onClose: () => widget.onClose?.call())
          : Column(
              children: [
                Row(
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
                        const SizedBox(height: Spacing.$4x),
                      ],
                    ),
                    BaladyAppButton.close(
                      buttonType: BaladyButtonType.secondary,
                      onTap: widget.onClose,
                    ),
                  ],
                ),
                TransportIconsRow(
                  transports: widget.route.transports,
                  pubs: widget.route.publicTransportTransferRouteLongEntry,
                  isLarge: true,
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                const SizedBox(height: Spacing.$4x),
              ],
            ),
    );
  }
}

class YouArrivedHeader extends StatelessWidget {
  final VoidCallback onClose;
  const YouArrivedHeader({
    required this.onClose,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: Spacing.$8x, top: Spacing.$2x),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: context.colorsV3.accentDefault,
                shape: BoxShape.circle,
              ),
              child: Icon(
                GeneralIcons.flag,
                color: context.colorsV3.accentOnAccent,
                size: 24,
              ),
            ),
            Spacing.$3x.widthBox,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.arrivedPub,
                  style: context.textStyleV3.bodyLargeSemiBold.copyWith(
                    color: context.colorsV3.foregroundDefault,
                  ),
                ),
                Text(
                  context.l10n.thankYou,
                  style: context.textStyleV3.bodySmallRegular.copyWith(
                    color: context.colorsV3.foregroundSoft,
                  ),
                ),
              ],
            ),
            const Spacer(),
            BaladyAppButton.close(
              buttonType: BaladyButtonType.secondary,
              onTap: onClose,
            ),
          ],
        ),
      );
}
