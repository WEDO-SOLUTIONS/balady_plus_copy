import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart' as ui_kit;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/routing/providers/public_transport_arrived.dart';
import 'package:mapness/pages/routing/lib/route_point_extension.dart';
import 'package:mapness/pages/routing/route_details_state_mapper.dart';
import 'package:mapness/pages/routing/ui/models/routing_details_ui_model.dart';
import 'package:mapness/pages/routing/ui/models/two_state_ext.dart';
import 'package:mapness/pages/routing/ui/widgets/public_transport/routing_public_transport_content.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/ar_functions.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';
import 'package:mapness/widgets/routing/lib/duration_distance_fmt.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/tools/public_transport_colors.dart';
import 'package:sheetify/sheetify.dart';

/// Type of the route details sheet
/// Needed to show the correct header and footer
enum RouteDetailsSheetType {
  about,
  driving,
}

@RoutePage()
class RouteDetailsPage extends ConsumerStatefulWidget {
  final RouteParamsPointWithLabel? destination;
  final RouteParamsPointWithLabel? startPoint;
  final Future<void> Function()? onPressed;
  final Future<void> Function()? onClose;
  final String buttonLabel;
  final List<BriefPublicTransportModel> publicTransportRoutes;
  final int initialIndex;
  final void Function(int index)? onActiveChanged;
  final RouteDetailsSheetType type;
  final ValueChanged<double>? onSheetHeightChanged;

  const RouteDetailsPage({
    required this.publicTransportRoutes,
    required this.buttonLabel,
    required this.type,
    this.initialIndex = 0,
    this.onActiveChanged,
    this.destination,
    this.onPressed,
    this.onClose,
    this.startPoint,
    this.onSheetHeightChanged,
    super.key,
  });

  @override
  ConsumerState<RouteDetailsPage> createState() => _RouteDetailsPageState();
}

class _RouteDetailsPageState extends ConsumerState<RouteDetailsPage> {
  late final MultiStateSheetController<TwoStateSheet> _bottomSheetController;
  List<RouteDetailsPublicTransport>? _transports;
  int _activeIndex = 0;
  late BriefPublicTransportModel? _route;

  bool get _hasPublicTransportRoutes => widget.publicTransportRoutes.isNotEmpty && widget.onActiveChanged != null;
  bool get _showTopHeaderRoutes => _hasPublicTransportRoutes && widget.publicTransportRoutes.length > 1;
  StatefulSheetDelegate<double>? get topHeaderOffset =>
      _showTopHeaderRoutes ? const StatefulSheetDelegateValue(value: 16.0) : null;

  static const contentRowStartPadding = ui_kit.Spacing.$4x;
  static const linePointCircleSize = 14.0;
  static const connectedLineWidth = 2.0;
  double get lineStartPosition => contentRowStartPadding + (linePointCircleSize / 2) - (connectedLineWidth / 2);

  @override
  void initState() {
    super.initState();
    _bottomSheetController = MultiStateSheetController(
      behavior: MultiSnappingBehavior(
        models: [
          FractionSnappingModel({0.0}),
          OffsetSnappingModel({_PublicTransportRoutes.height + 16.0}),
        ],
      ),
      stateMapper: const RouteDetailsStateMapperV2(),
      initialState: _initialState,
    );
    _bottomSheetController.addListener(_notifySheetHeight);
    _activeIndex = widget.initialIndex;
    _route = widget.publicTransportRoutes[_activeIndex];
  }

  void _notifySheetHeight() => widget.onSheetHeightChanged?.call(_bottomSheetController.sheetHeight);

  @override
  void didUpdateWidget(RouteDetailsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      _activeIndex = widget.initialIndex;
    }
  }

  @override
  void dispose() {
    _bottomSheetController.removeListener(_notifySheetHeight);
    _bottomSheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _route = widget.publicTransportRoutes[_activeIndex];
    _transports = _getTransports(context, _route!);

    final direction = Localizations.localeOf(context).languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;

    return Directionality(
      textDirection: direction,
      child: MultiStateSheet<TwoStateSheet>(
        scrollController: _bottomSheetController,
        backgroundColor: context.colors.backgroundSurface4,
        safeAreaColor: context.colors.backgroundSurface1,
        outsideOpacityDelegate: _bottomSheetController.defaultOpacityDelegate,
        topHeaderOffset: topHeaderOffset,
        topHeader: _showTopHeaderRoutes
            ? _PublicTransportRoutes(
                routes: widget.publicTransportRoutes,
                activeIndex: _activeIndex,
                onActiveChanged: (index) {
                  setState(() {
                    _activeIndex = index;
                  });
                  widget.onActiveChanged?.call(index);
                },
              )
            : null,
        dragger: null,
        header: _Header(
          route: _route!,
          destination: widget.destination,
          onClose: () => widget.onClose?.call(),
          type: widget.type,
        ),
        content: [
          RoutingPublicTransportContent(
            data: _transports,
            startPoint: widget.startPoint,
            destination: widget.destination,
          ),
        ],
        footer: ColoredBox(
          color: context.colors.backgroundSurface1,
          child: SizedBox(
            width: double.infinity,
            child: ui_kit.AppButton(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + ui_kit.Spacing.$2x,
                left: ui_kit.Spacing.$4x,
                right: ui_kit.Spacing.$4x,
                top: ui_kit.Spacing.$3x,
              ),
              buttonColorScheme: ui_kit.ButtonColorScheme.accentSecondary,
              size: ui_kit.ButtonSize.large,
              primaryLabel: widget.buttonLabel,
              onTap: () {
                context.router.pop();
                widget.onPressed?.call();
              },
            ),
          ),
        ),
      ),
    );
  }

  List<RouteDetailsPublicTransport> _getTransports(BuildContext context, BriefPublicTransportModel route) {
    final transports = <RouteDetailsPublicTransport>[];

    for (var i = 0; i < route.publicTransportTransferRouteLongEntry.length; i++) {
      final transferEntry = route.publicTransportTransferRouteLongEntry[i];

      if (_isPedestrianTransfer(transferEntry)) {
        transports.add(_createPedestrianTransport(transferEntry, route, i));
      } else {
        transports.add(_createMetroTransport(transferEntry, route, i, context));
      }
    }

    return transports;
  }

  /// Checks if the transfer is pedestrian (no route parts)
  bool _isPedestrianTransfer(PublicTransportTransferRouteLongEntryMessage transferEntry) =>
      transferEntry.value.routeParts.isEmpty;

  /// Creates a pedestrian transport entry
  RouteDetailsPublicTransport _createPedestrianTransport(
    PublicTransportTransferRouteLongEntryMessage transferEntry,
    BriefPublicTransportModel route,
    int index,
  ) => RouteDetailsPublicTransportPedestrian(
    length: transferEntry.length.millimeters,
    isTransfer: isTransfer(route.publicTransportTransferRouteLongEntry, index),
  );

  /// Creates a metro transport entry
  RouteDetailsPublicTransport _createMetroTransport(
    PublicTransportTransferRouteLongEntryMessage transferEntry,
    BriefPublicTransportModel route,
    int index,
    BuildContext context,
  ) {
    final routeParts = _buildRouteParts(transferEntry);

    return RouteDetailsPublicTransportMetro(
      length: transferEntry.length.millimeters,
      routeParts: routeParts,
      lineColor: _getMetroLineColor(route, index, context),
      lineName: route.transports[index].names.first,
    );
  }

  /// Builds route parts from transfer entry
  List<RoutePart> _buildRouteParts(PublicTransportTransferRouteLongEntryMessage transferEntry) => transferEntry
      .value
      .routeParts
      .map(
        (routePart) => RoutePart(
          stations: [
            transferEntry.value.startPointName,
            ...routePart.intermediateStops.map((stop) => stop.name),
            transferEntry.value.finishPointName,
          ],
        ),
      )
      .toList();

  /// Gets the metro line color for the transport
  Color? _getMetroLineColor(BriefPublicTransportModel route, int index, BuildContext context) {
    if (route.transports.length > index && route.transports[index].names.isNotEmpty) {
      return getMetroLineColor(route.transports[index].names.first, context);
    }
    return null;
  }

  TwoStateSheet get _initialState => switch (widget.type) {
    RouteDetailsSheetType.about => TwoStateSheet.expanded,
    RouteDetailsSheetType.driving => TwoStateSheet.hidden,
  };
}

class _Header extends ConsumerStatefulWidget {
  final BriefPublicTransportModel route;
  final RouteParamsPointWithLabel? destination;
  final VoidCallback? onClose;
  final RouteDetailsSheetType type;
  const _Header({
    required this.route,
    required this.type,
    this.destination,
    this.onClose,
  });

  @override
  ConsumerState<_Header> createState() => _HeaderState();
}

class _HeaderState extends ConsumerState<_Header> {
  bool get _bottomSafeArea => widget.type == RouteDetailsSheetType.driving;
  @override
  Widget build(BuildContext context) {
    final duration = widget.route.duration.formatDuration(context.l10n);
    final durationByFoot = '${context.l10n.number(widget.route.durationInMinutes())} ${context.l10n.min}';
    final transfers = ArPlurals.transfers(widget.route.transferCount, context.l10n);
    final p = publicTransportArrivedProvider(
      destination: (widget.destination?.value?.latitude, widget.destination?.value?.longitude),
    );
    final arrivalState = ref.watch(p);
    final _showArrival = widget.type == RouteDetailsSheetType.driving && arrivalState.value == true;

    return Container(
      color: context.colors.backgroundSurface1,
      padding: const EdgeInsets.symmetric(horizontal: ui_kit.Spacing.$4x),
      child: SafeArea(
        top: false,
        bottom: _bottomSafeArea,
        child: _showArrival
            ? YouArrivedHeader(onClose: () => widget.onClose?.call())
            : Column(
                children: [
                  const SizedBox(height: ui_kit.Spacing.$1x),
                  DraggerContainer(
                    draggerColor: context.colors.backgroundSurface5,
                  ),
                  const SizedBox(height: ui_kit.Spacing.$1x),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            duration,
                            style: context.textStyles.h4SemiBold.copyWith(
                              color: context.colors.foregroundDefault,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: transfers,
                                  style: context.textStyles.bodySmallRegular.copyWith(
                                    color: context.colors.foregroundDefault,
                                  ),
                                ),
                                TextSpan(
                                  text: ' • $durationByFoot',
                                  style: context.textStyles.bodySmallRegular.copyWith(
                                    color: context.colors.foregroundSoft,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ui_kit.AppButton.close(onTap: widget.onClose, padding: EdgeInsets.zero),
                    ],
                  ),
                  const SizedBox(height: ui_kit.Spacing.$4x),
                ],
              ),
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
    padding: const EdgeInsets.only(bottom: ui_kit.Spacing.$12x, top: ui_kit.Spacing.$2x),
    child: Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: context.colors.accentDefault,
            shape: BoxShape.circle,
          ),
          child: Icon(
            ui_kit.GeneralIcons.flag,
            color: context.colors.accentOnAccent,
            size: 24,
          ),
        ),
        ui_kit.Spacing.$3x.widthBox,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.arrivedPub,
              style: context.textStyles.bodyLargeSemiBold.copyWith(
                color: context.colors.foregroundDefault,
              ),
            ),
            Text(
              context.l10n.thankYou,
              style: context.textStyles.bodySmallRegular.copyWith(
                color: context.colors.foregroundSoft,
              ),
            ),
          ],
        ),
        const Spacer(),
        ui_kit.AppButton.close(onTap: onClose),
      ],
    ),
  );
}

class _PublicTransportRoutes extends StatelessWidget {
  final List<BriefPublicTransportModel> routes;
  final int activeIndex;
  final void Function(int index) onActiveChanged;

  static const height = 60.0;

  const _PublicTransportRoutes({
    required this.routes,
    required this.activeIndex,
    required this.onActiveChanged,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    child: ListView.separated(
      padding: const EdgeInsets.only(left: ui_kit.Spacing.$4x, right: ui_kit.Spacing.$4x),
      scrollDirection: Axis.horizontal,
      itemCount: routes.length,
      itemBuilder: (context, index) {
        final transfers = ArPlurals.transfers(routes[index].transferCount, context.l10n);
        final isActive = index == activeIndex;
        return InkWell(
          onTap: () {
            onActiveChanged(index);
          },
          child: Container(
            constraints: const BoxConstraints(minWidth: 110),
            padding: const EdgeInsets.all(ui_kit.Spacing.$2x),
            decoration: BoxDecoration(
              color: isActive ? context.colors.accentSecondaryDefault : context.colors.backgroundSurface1,
              borderRadius: BorderRadius.circular(ui_kit.RadiusBorder.l),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  routes[index].duration.formatDuration(context.l10n),
                  style: context.textStyles.bodyLargeRegular.copyWith(
                    color: isActive
                        ? context.colors.accentSecondaryOnAccentSecondary
                        : context.colors.foregroundDefault,
                  ),
                ),
                ui_kit.Spacing.$1x.heightBox,
                Text(
                  transfers,
                  style: context.textStyles.bodySmallRegular.copyWith(
                    color: isActive ? context.colors.accentSecondaryMuted : context.colors.foregroundSoft,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => ui_kit.Spacing.$2x.widthBox,
    ),
  );
}
