import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/hajj/poi_marker_rcmc.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/poi_card/domain/poi_card_state_mapper.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/provider/poi_card_actions_provider.dart';
import 'package:mapness/features/poi_card/widgets/photos_header/header_component.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_map_controls_wrapper.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/widgets/hajj/hajj_info_widget.dart';
import 'package:mapness/widgets/hajj/hajj_poi_card_footer.dart';
import 'package:mapness/widgets/hajj/hajj_poi_header.dart';
import 'package:mapness/widgets/hajj/hajj_wrapper_listeners.dart';
import 'package:sliver_tools/sliver_tools.dart';

@RoutePage()
class HajjPoiCardPage extends ConsumerStatefulWidget {
  final PoiMarkerRcmc poiMarkerRcmc;

  const HajjPoiCardPage({required this.poiMarkerRcmc, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HajjPoiCardPageState();
}

class _HajjPoiCardPageState extends ConsumerState<HajjPoiCardPage> with SingleTickerProviderStateMixin {
  late final StatefulBottomSheetController<PoiCardBottomSheetState> _bottomSheetController =
      StatefulBottomSheetController(
    behavior: MultiSnappingBehavior(
      models: [
        AspectRatioSnappingModel({0.0, 1.0}),
        OffsetSnappingModel({HeaderComponent.photosMaxHeight + Spacing.$2x}),
        ComponentsSnappingModel(componentsDescriptions: [
          SnapComponent.merge(
            a: const SnapComponent.size(component: Components.header),
            b: const SnapComponent.size(component: Components.footer),
            merge: (a, b) => a + b,
          ),
        ])
      ],
    ),
    stateMapper: const PoiCardStateMapper(),
    initialState: PoiCardBottomSheetState.halfOpen,
  );

  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: Directionality.of(context),
        child: SafeArea(
          child: StatefulBottomSheet(
            scrollController: _bottomSheetController,
            safeAreaColor: context.colorsV2.backgroundSurface2,
            draggerColor: context.colorsV2.backgroundSurface2,
            backgroundColor: context.colorsV2.backgroundSurface2,
            backgroundColorDelegate: PoiCardStateMapper.backgroundColorDelegate,
            outside: PoiCardMapControlsWrapper(
              bottomSheetController: _bottomSheetController,
              objectIdForIndoorLevels: null,
            ),
            header: HajjPoiHeader(
              poiMarkerRcmc: widget.poiMarkerRcmc,
              onTapClose: () {
                ref.read(selectedMarkerProvider.notifier).removeMarker(hajjPoiPinId);
                context.router.popForced();
              },
            ),
            footer: HajjPoiCardFooter(
              poiMarkerRcmc: widget.poiMarkerRcmc,
              bottomSheetController: _bottomSheetController,
              callPhone: onTapCall,
              onTapCar: () {
                final mapSetting = MapObjectManagerSettings.search();
                ref
                    .read(
                      mapObjectManagerProvider(
                        named: mapSetting.name,
                        layerId: mapSetting.layerId,
                      ).notifier,
                    )
                    .setMapObjectManagerIsVisible(isVisible: false);

                _openRoutingRoutes();
              },
            ),
            sliverBeforeContent: DecoratedSliver(
              decoration: BoxDecoration(
                color: context.colorsV2.backgroundSurface4,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(RadiusBorder.xxl)),
              ),
              sliver: SliverFillAfter(
                sliver: SliverAnimatedSwitcher(
                  duration: Durations.medium2,
                  child: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        const SizedBox(height: Spacing.$4x),
                        HajjInfoWidget(data: widget.poiMarkerRcmc),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  void _openRoutingRoutes() {
    context.router.push(
      RoutingRoutesRoute(
        points: [
          RouteParamsPointWithLabel(
            value: null,
            label: context.l10n.myLocation,
          ),
          RouteParamsPointWithLabel(
            value: RouteParamsPoint(
              latitude: widget.poiMarkerRcmc.latitude,
              longitude: widget.poiMarkerRcmc.longitude,
            ),
            label: widget.poiMarkerRcmc.title,
          ),
        ],
      ),
    );
  }

  void onTapCall() {
    final poiActions = ref.read(poiCardActionsProvider.notifier);
    final phoneNumber = widget.poiMarkerRcmc.contactInfo;

    if (phoneNumber != null) {
      poiActions.callPhone(phoneNumber);
    }
  }
}
