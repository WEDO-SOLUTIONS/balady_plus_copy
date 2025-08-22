import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/poi_card/domain/model/loading_or_failure_model.dart';
import 'package:mapness/features/poi_card/domain/poi_card_state_mapper.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_map_controls_wrapper.dart';
import 'package:mapness/features/saudi_pass/providers/get_all_offers_ids_provider.dart';
import 'package:mapness/features/saudi_pass/providers/show_map_offers_provider.dart';
import 'package:mapness/features/saudi_pass/repo/offer_details_body.dart';
import 'package:mapness/features/saudi_pass/widgets/offers_bottom_sheet_widget.dart';
import 'package:mapness/features/saudi_pass/widgets/offers_on_map_widget.dart';
import 'package:mapness/pages/poi_card/poi_card_error_or_loading.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:sheetify/multi_state_sheet/multi_state_sheet.dart';
import 'package:sheetify/multi_state_sheet/state_snapping/behaviors/multi_snapping_behavior.dart';
import 'package:sheetify/multi_state_sheet/state_snapping/models/components_snapping_model.dart';
import 'package:sheetify/multi_state_sheet/state_snapping/models/fraction_snapping_model.dart';

@RoutePage()
class OfferListBottomSheetMapPage extends HookConsumerWidget {
  final List<String> offersId;

  const OfferListBottomSheetMapPage({required this.offersId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;

    final scrollController = useMemoized(
      () => MultiStateSheetController<PoiCardBottomSheetState>(
        behavior: MultiSnappingBehavior(
          models: [
            FractionSnappingModel({0.0, if (offersId.length == 1) .3 else 0.8}),
            ComponentsSnappingModel(
              componentsDescriptions: [
                SnapComponent.merge(
                  a: const SnapComponent.size(component: Components.header),
                  b: const SnapComponent.size(component: Components.footer),
                  merge: (a, b) => a + b,
                ),
              ],
            )
          ],
        ),
        stateMapper: const PoiCardStateMapper(),
        initialState: PoiCardBottomSheetState.halfOpen,
      ),
      [offersId.length],
    );

    final backgroundColor = context.colors.backgroundSurface4;

    final offersAsync = ref.watch(getAllOffersIdsProvider(offersId));

    if (offersAsync.isLoading) {
      return const PoiLoadingOrErrorSheet(
        sheetHeight: 250,
        contentHeight: 200,
        data: PoiLoading(),
      );
    }

    final list = offersAsync.value ?? const <OfferDetails>[];
    final first = list.isNotEmpty ? list.first : null;

    final duration = first?.briefDurationTo;
    final durationString = switch (duration) {
      null => '',
      final n when n < 1 => '${(duration * 1000).toInt()} ${l10n.meter}',
      final n => '${n.toInt()} ${l10n.km}',
    };

    return SafeArea(
      top: false,
      child: MultiStateSheet(
        outside: PoiCardMapControlsWrapper(
          bottomSheetController: scrollController,
          objectIdForIndoorLevels: null,
        ),
        scrollController: scrollController,
        backgroundColor: backgroundColor,
        header: Padding(
          padding: const EdgeInsets.only(left: uikit.Spacing.$4x, right: uikit.Spacing.$4x, bottom: uikit.Spacing.$3x),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  '${offersId.length} ${l10n.offers}',
                  style: context.textStyles.h4SemiBold,
                ),
                Text(
                  l10n.selectedLocation,
                  style: context.textStyles.bodySmallRegular,
                ),
              ]),
              uikit.AppButton.close(
                primaryIcon: uikit.SystemIcons.closeSmall,
                onTap: () async {
                  final showMapOffers = ref.read(showMapOffersProvider.notifier);
                  await showMapOffers.removeMarker(offerPoiPinId);
                  context.router.popForced();
                },
              ),
            ],
          ),
        ),
        content: [OffersBottomSheetWidget(list)],
        footer: Padding(
          padding: const EdgeInsets.only(
            left: uikit.Spacing.$4x,
            right: uikit.Spacing.$4x,
            bottom: uikit.Spacing.$4x,
          ),
          child: uikit.AppButton(
            size: uikit.ButtonSize.large,
            primaryIcon: uikit.TransportIcons.locationDirectionNavigator,
            iconColor: colors.accentSecondaryOnAccentSecondary,
            primaryLabel: '${l10n.poiCardDirections} $durationString',
            color: colors.accentSecondaryDefault,
            textColor: colors.accentSecondaryOnAccentSecondary,
            buttonColorScheme: uikit.ButtonColorScheme.accent,
            onTap: first == null ? null : () => _openNavigationPage(context, first),
          ),
        ),
      ),
    );
  }

  void _openNavigationPage(BuildContext context, OfferDetails offer) {
    context.router.push(
      RoutingRoutesRoute(
        points: [
          RouteParamsPointWithLabel(value: null, label: context.l10n.myLocation),
          RouteParamsPointWithLabel(
            value: RouteParamsPoint(
              latitude: double.parse(offer.location.latitude),
              longitude: double.parse(offer.location.longitude),
            ),
            label: offer.name,
          ),
        ],
      ),
    );
  }
}
