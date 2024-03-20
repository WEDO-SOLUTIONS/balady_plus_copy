import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/poi_card/poi_card_view_model.dart';
import 'package:mapness/_features/poi_card/widgets/footer/footer_style.dart';
import 'package:mapness/_features/poi_card/widgets/poi_card_map_controls.dart';
import 'package:mapness/_features/profile/domain/user_profile_data.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';
import 'package:mapness/shared/ui/bottom_sheet/ui/disable_overscroll_behavior.dart';

import '../ui_kit_tmp/poi_header.dart';

part 'poi_my_location_action.dart';
part 'poi_my_location_content.dart';

class ContentMyLocation extends ConsumerWidget {
  final LatLng? closestPoint;

  const ContentMyLocation({
    required this.closestPoint,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = PoiCardViewModel(ref: ref);
    _cameraAnimation(ref);

    return Directionality(
      textDirection: switch (ref.watch(appLanguageProvider)) {
        Language.arabic => TextDirection.rtl,
        Language.english => TextDirection.ltr,
      },
      child: LayoutBuilder(
        builder: (context, constrains) => DgisBottomSheet(
          showBarrier: false,
          scrollBehavior: const NeverScrollableConfiguration(),
          availableExpansions: Expansion.values.toSet(),
          initialExpansion: Expansion.middle,
          collapsedHeight: 150,
          middleHeight: 180,
          hiddenHeight: 100,
          mapControlsBuilder:
              (context, scrollController, biggestHeight, smallestHeight) =>
                  PoiCardMapControls(
            scrollController: scrollController,
            biggestHeight: biggestHeight,
          ),
          body: (context) => ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 400,
              maxWidth: 200,
            ),
            child: Builder(
              builder: (context) => Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  PoiMyLocationContent(
                    location: closestPoint!,
                    onTapClose: context.pop,
                  ),
                  MyLocationPoiActions(
                    onShare: () => viewModel.shareMyLocation(closestPoint),
                    onCopy: () => viewModel.copyToClipboard(closestPoint),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _cameraAnimation(WidgetRef ref) {
    if (closestPoint != null) {
      // TODO(@DmitriiProshutinskii): Add marker on the map
      // ref.read(selectedMarkerProvider.notifier).showMarker(
      //       Markers.pinMarker(
      //         GeoPointWithElevationMessage(
      //           latitude: closestPoint!.latitude,
      //           longitude: closestPoint!.longitude,
      //           elevation: 100,
      //         ),
      //       ),
      //     );
      ref.read(cameraPositionProvider.notifier).animateTo(
            CameraPositionMessage(
              point: GeoPointMessage(
                  latitude: closestPoint!.latitude,
                  longitude: closestPoint!.longitude),
              zoom: 17,
              tilt: 0,
              bearing: 0,
            ),
          );
    }
  }
}
