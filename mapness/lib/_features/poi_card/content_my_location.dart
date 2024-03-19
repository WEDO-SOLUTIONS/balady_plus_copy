// ignore_for_file: prefer_expression_function_bodies

import 'package:balady_uikit/colors/app_colors_theme.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/poi_card/widgets/footer/footer_style.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';
import 'package:mapness/shared/ui/bottom_sheet/ui/disable_overscroll_behavior.dart';

import '../../shared/config/package_config.dart';

class ContentMyLocation extends ConsumerWidget {
  final LatLng? closestPoint;
  final ThemeData theme;

  const ContentMyLocation({
    required this.theme,
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
          body: (context) {
            return Theme(
              data: theme,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 400,
                  maxWidth: 200,
                ),
                child: Builder(builder: (context) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PoiMyLocationHeader(
                        onTapClose: () {
                          context.pop();
                        },
                        theme: theme,
                      ),
                      Container(
                        width: double.infinity,
                        color: Colors.white,
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
                                  colorIcon: theme
                                      .extension<AppColorsThemeExt>()
                                      ?.text_and_icons_status_accent,
                                  onTap:
                                      () {}, // () => viewModel.share(objectMessage),
                                ),
                                FooterIconButton(
                                  flex: 2,
                                  assetName: 'assets/icons/svg/ic_copy.svg',
                                  colorIcon: theme
                                      .extension<AppColorsThemeExt>()
                                      ?.text_and_icons_status_accent,
                                  onTap:
                                      () {}, // () => viewModel.share(objectMessage),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            );
          },
        );
      }),
    );
  }
}

class PoiMyLocationHeader extends ConsumerWidget {
  const PoiMyLocationHeader({
    required this.onTapClose,
    required this.theme,
    super.key,
  });

  final Function()? onTapClose;
  final ThemeData theme;

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
            const SizedBox(height: 12),
            _title(theme, title),
            _titleAddition(theme, 'titleAddition'),
            const SizedBox(height: 2),
            const SizedBox(height: 6),
          ],
        );
      }),
    );
  }

  Widget _title(ThemeData theme, String text) {
    final titleTextStyle = theme
        .extension<ThemeTextStyles>()!
        .headingS
        .copyWith(
            color: theme
                .extension<AppColorsThemeExt>()
                ?.text_and_icons_base_primary);
    return Theme(
      data: theme,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              text,
              style: titleTextStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.start,
            ),
          ),
          _buildcloseButton(),
        ],
      ),
    );
  }

  Widget _titleAddition(ThemeData theme, String text) => text.isNotEmpty
      ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                text,
                style: theme.extension<ThemeTextStyles>()!.textS.copyWith(
                      color: theme
                          .extension<AppColorsThemeExt>()
                          ?.text_and_icons_base_primary
                          .withOpacity(
                            0.5,
                          ),
                    ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(
              width: 56,
            ),
          ],
        )
      : const SizedBox.shrink();

  Widget _buildcloseButton() => Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Material(
            borderRadius: borderRadius,
            child: InkWell(
              borderRadius: borderRadius,
              onTap: onTapClose,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  color:
                      context.color.text_and_icons_base_primary.withAlpha(10),
                ),
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset(
                  'assets/icons/svg/ic_search_close.svg',
                  semanticsLabel: 'MinApps Screen',
                  package: PackageConfig.packageName,
                  colorFilter: ColorFilter.mode(
                    context.color.text_and_icons_base_primary.withOpacity(0.7),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
