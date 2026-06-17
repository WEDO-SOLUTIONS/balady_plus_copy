import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/poi_card/domain/model/poi_sheet_sizes.dart';
import 'package:mapness/features/poi_card/provider/poi_card_actions_provider.dart';
import 'package:mapness/features/poi_card/provider/poi_my_location_provider.dart';
import 'package:mapness/features/poi_card/widgets/footer/footer_style.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_map_controls.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';
import 'package:mapness/shared/ui/bottom_sheet/ui/disable_overscroll_behavior.dart';
import 'package:mapness/shared/ui/sheets/card_header.dart';
import 'package:shimmer/shimmer.dart';

part 'poi_deeplink_location_action.dart';
part 'poi_deeplink_location_content.dart';

@RoutePage()
class DeeplinkPage extends ConsumerWidget {
  final LatLng? closestPoint;
  final PoiCameraConfig? cameraConfig;

  const DeeplinkPage({
    required this.closestPoint,
    this.cameraConfig,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);

    final data = ref.watch(
      poiMyLocationProvider(
        closestPoint: closestPoint,
        cameraConfig: cameraConfig,
      ),
    );
    final sheetSizes = _calculateSheetSize(context, data);

    return Directionality(
      textDirection: switch (language) {
        Language.arabic => TextDirection.rtl,
        Language.english => TextDirection.ltr,
      },
      child: LayoutBuilder(
        builder: (context, constrains) => DgisBottomSheet(
          showBarrier: false,
          scrollBehavior: const NeverScrollableConfiguration(),
          availableExpansions: Expansion.values.toSet(),
          initialExpansion: Expansion.middle,
          collapsedHeight: sheetSizes.collapsedHeight,
          middleHeight: sheetSizes.middleHeight,
          hiddenHeight: sheetSizes.hiddenHeight,
          mapControlsBuilder: (context, bottomSheetSize, biggestHeight, smallestHeight) => SizedBox(
            height: constrains.maxHeight - sheetSizes.middleHeight,
            child: const PoiCardMapControls(),
          ),
          body: (context) => ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                PoiDeeplinkContent(
                  location: closestPoint!,
                  onTapClose: () => onClose(context, ref),
                  data: data,
                ),
                PoiDeeplinkPersonActions(
                  onShare: () => ref.read(poiCardActionsProvider.notifier).shareMyLocation(closestPoint),
                  onGo: () {
                    context.router.popAndPush(
                      RoutingRoutesRoute(
                        points: [
                          RouteParamsPointWithLabel(
                            value: null,
                            label: context.l10n.myLocation,
                          ),
                          RouteParamsPointWithLabel(
                            value: RouteParamsPoint(
                              latitude: closestPoint!.latitude,
                              longitude: closestPoint!.longitude,
                            ),
                            label: context.l10n.pointToMap,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onClose(BuildContext context, WidgetRef ref) async {
    context.router.pop();
    final read = ref.read(selectedMarkerProvider.notifier);
    await read.removeAllMarkers();
  }

  PoiSheetSizes _calculateSheetSize(BuildContext context, AsyncValue<PoiMyLocationState?> data) {
    bool twoLineAddress = false;
    bool twoLineTitle = false;
    final sizeOfAddress = _textSize(
      data.maybeWhen(
        data: (value) => value?.address ?? '',
        orElse: () => '',
      ),
      context.textStyles.bodySmallRegular,
    );
    final isAuthorized = data.maybeWhen(
      data: (value) => value?.isAuthorized ?? false,
      orElse: () => false,
    );

    if (sizeOfAddress.width > MediaQuery.of(context).size.width - Spacing.$4x) {
      twoLineAddress = true;
    }

    final sizeOfTitle = _textSize(
      data.maybeWhen(
        data: (value) => value?.title ?? '',
        orElse: () => '',
      ),
      context.textStyles.h4SemiBold,
    );

    if (sizeOfTitle.width > MediaQuery.of(context).size.width - Spacing.$4x - (isAuthorized ? 48 : 0) - 40) {
      twoLineTitle = true;
    }

    return PoiSheetSizes.myLocation(
      /// The old version {MediaQuery.of(context).viewPadding.bottom}
      /// but this value create empty space at the bottom
      bottomPadding: 0,
      isAddressInTwoLines: twoLineAddress,
      isTitleInTwoLine: twoLineTitle,
    );
  }

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.size;
  }
}
