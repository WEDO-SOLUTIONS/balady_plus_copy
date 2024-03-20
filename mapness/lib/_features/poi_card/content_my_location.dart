// ignore_for_file: prefer_expression_function_bodies

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/poi_card/ui_kit_tmp/poi_header.dart';
import 'package:mapness/_features/poi_card/widgets/footer/footer_style.dart';
import 'package:mapness/_features/poi_card/widgets/poi_card_map_controls.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';
import 'package:mapness/shared/ui/bottom_sheet/ui/disable_overscroll_behavior.dart';

class ContentMyLocation extends ConsumerWidget {
  final LatLng? closestPoint;

  const ContentMyLocation({
    required this.closestPoint,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Directionality(
      textDirection: switch (ref.watch(appLanguageProvider)) {
        Language.arabic => TextDirection.rtl,
        Language.english => TextDirection.ltr,
      },
      child: LayoutBuilder(builder: (context, constrains) {
        return DgisBottomSheet(
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
          body: (context) {
            return ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 400,
                maxWidth: 200,
              ),
              child: Builder(builder: (context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PoiMyLocationContent(
                      location: closestPoint!,
                      onTapClose: () {
                        context.pop();
                      },
                    ),
                    const MyLocationPoiActions(),
                  ],
                );
              }),
            );
          },
        );
      }),
    );
  }
}

class MyLocationPoiActions extends StatelessWidget {
  const MyLocationPoiActions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.all(8),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FooterIconButton(
                flex: 2,
                assetName: 'assets/icons/svg/ic_share.svg',
                colorIcon: context.color.text_and_icons_status_accent,
                onTap: () {}, // () => viewModel.share(objectMessage),
              ),
              FooterIconButton(
                flex: 2,
                assetName: 'assets/icons/svg/ic_copy.svg',
                colorIcon: context.color.text_and_icons_status_accent,
                onTap: () {}, // () => viewModel.copy(objectMessage),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PoiMyLocationContent extends ConsumerWidget {
  const PoiMyLocationContent({
    required this.onTapClose,
    required this.location,
    super.key,
  });

  final Function()? onTapClose;

  final LatLng location;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16),
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
      ),
      child: Builder(builder: (context) {
        // final address = data.directoryObjectMessage?.address;
        // final subTitle = data.directoryObjectMessage?.makeAddress() ?? '';
        const title = 'Guest';
        //address?.buildingName ?? data.directoryObjectMessage?.title ?? '';
        //final titleAddition = data.directoryObjectMessage?.titleAddition ?? '';

        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            PoiHeader(
              onTapClose: onTapClose,
              text: title,
              subTitle: "It's you",
            ),
            const SizedBox(height: 12),
            Text(
              '${location.latitude}, ${location.longitude}',
              style: context.textStyle.textM,
            ),
          ],
        );
      }),
    );
  }
}
