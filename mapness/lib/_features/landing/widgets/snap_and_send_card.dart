import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';

class SnapAndSendCard extends ConsumerWidget {
  const SnapAndSendCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const horizontalPadding = Spacing.$4x;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: SizedBox(
          height: 188,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(RadiusBorder.xl),
            child: ColoredBox(
              color: context.colorsV2.backgroundSurface1,
              child: Stack(
                children: [
                  const SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xff7FB1BC), Color(0xff518591)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/images_svg/snap_map_grid.svg',
                    package: PackageConfig.packageName,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width - horizontalPadding * 2,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: Spacing.$6x + Spacing.$0_5x),
                      child: SvgPicture.asset(
                        'assets/images_svg/marker_photo.svg',
                        package: PackageConfig.packageName,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(Spacing.$6x),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  context.l10n.snapAndSendTitle,
                                  style: context.textStyleV3.h4SemiBold,
                                ),
                                const SizedBox(height: Spacing.$1x),
                                Text(
                                  context.l10n.snapAndSendDescription,
                                  style: context.textStyleV3.captionLargeRegular.copyWith(
                                    color: context.colorsV2.foregroundSoft,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppButton(
                            buttonColorScheme: ButtonColorScheme.onColor,
                            color: context.colorsV2.accentContainerDefault.withOpacity(0.1),
                            onTap: () {
                              Metrics.logEventAdvanced(MetricsConstants.exploreKeys.enhanceUrbanSceneBannerButton,
                                  action: MetricAction.tap.name, group: MetricsConstants.exploreTag);
                              CommonFunctions.openSnapAndSend();
                            },
                            trailing: Icon(
                              context.isLTR ? SystemIcons.arrowRight : SystemIcons.arrowLeft,
                              color: context.colorsV2.accentOnContainer,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
