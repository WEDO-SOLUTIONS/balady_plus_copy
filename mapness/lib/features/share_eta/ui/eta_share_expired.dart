import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/string_ext.dart';

class EtaShareExpired extends StatelessWidget {
  final String title;
  final String subtitle;

  const EtaShareExpired({required this.title, required this.subtitle, super.key});

  factory EtaShareExpired.liveLocation(BuildContext context) => EtaShareExpired(
        title: context.l10n.locationUnavailable,
        subtitle: context.l10n.locationBroadcastExpired.multilines,
      );

  factory EtaShareExpired.eta(BuildContext context) => EtaShareExpired(
        title: context.l10n.driveEnded,
        subtitle: context.l10n.driverReachedDestination.multilines,
      );

  factory EtaShareExpired.broadcastExpired(BuildContext context) => EtaShareExpired(
        title: context.l10n.locationUnavailableEta,
        subtitle: context.l10n.broadcastHasExpired.multilines,
      );

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorsV2.backgroundSurface4,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(RadiusBorder.xl),
          topRight: Radius.circular(RadiusBorder.xl),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.$4x).copyWith(top: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: Spacing.$1_5x),
                child: SheetDragger(),
              ),
            ),
            ContentRow(
              options: ContentRowOptions(
                padding: EdgeInsets.zero,
                titleStyle: context.textStyleV3.h3SemiBold.copyWith(
                  color: context.colorsV2.foregroundDefault,
                ),
                customActionWidget: AppButton.close(
                  onTap: context.pop,
                  padding: EdgeInsets.zero,
                  textColor: context.colorsV2.neutralOnContainer,
                  color: context.colorsV2.neutralContainerDefault,
                  innerPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                ),
              ),
            ),
            SvgPicture.asset(
              'assets/images_svg/illustration_error.svg',
              package: PackageConfig.packageName,
            ),
            const SizedBox(height: Spacing.$2x),
            Text(
              title,
              style: context.textStyleV3.h3SemiBold.copyWith(
                color: context.colorsV2.foregroundDefault,
              ),
            ),
            const SizedBox(height: Spacing.$3x),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: context.textStyleV3.bodyLargeRegular.copyWith(
                color: context.colorsV2.foregroundSoft,
              ),
            ),
            const SizedBox(
              height: Spacing.$8x,
            )
          ],
        ),
      ),
    );
  }
}
