// ignore_for_file: prefer_expression_function_bodies

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/poi_card/poi_card_view_model.dart';
import 'package:mapness/_features/poi_card/ui_kit_tmp/poi_header.dart';
import 'package:mapness/_features/poi_card/widgets/footer/footer_style.dart';
import 'package:mapness/_features/poi_card/widgets/poi_card_map_controls.dart';
import 'package:mapness/_features/profile/domain/user_profile_data.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
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
    final viewModel = PoiCardViewModel(ref: ref);
    _cameraAnimation(ref);
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
                    MyLocationPoiActions(
                      onShare: () => viewModel.shareMyLocation(closestPoint),
                      onCopy: () => viewModel.copyToClipboard(closestPoint),
                      language: ref.watch(appLanguageProvider),
                    ),
                  ],
                );
              }),
            );
          },
        );
      }),
    );
  }

  void _cameraAnimation(WidgetRef ref) {
    if (closestPoint != null) {
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

class MyLocationPoiActions extends StatelessWidget {
  final Function()? onShare;
  final Function()? onCopy;
  // Tempreary solution: add context.l10n.copy
  final Language language;
  const MyLocationPoiActions({
    required this.language,
    super.key,
    this.onShare,
    this.onCopy,
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
                desc: Text(
                  context.l10n.share,
                  style: context.textStyle.accentM.copyWith(
                      color: context.color.text_and_icons_base_inverse_primary),
                ),
                assetName: 'assets/icons/svg/ic_share.svg',
                colorIcon: context.color.text_and_icons_base_inverse_primary,
                colorButton: context.color.text_and_icons_status_accent,
                onTap: onShare,
              ),
              FooterIconButton(
                flex: 2,
                desc: Text(
                  //context.l10n.copy,
                  switch (language) {
                    Language.arabic => 'نسخ',
                    Language.english => 'Copy',
                  },
                  style: context.textStyle.accentM.copyWith(
                    color: context.color.text_and_icons_status_accent,
                  ),
                ),
                assetName: 'assets/icons/svg/ic_copy.svg',
                colorIcon: context.color.text_and_icons_status_accent,
                onTap: onCopy,
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
        final userData = ref.watch(authProvider).requireValue;
        final language = ref.read(appLanguageProvider);
        final title =
            userData?.getLocalizedFirstAndLastName(language) ?? 'Guest';

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
