import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/poi_card/domain/model/qr_trade_license.dart';
import 'package:mapness/_features/poi_card/widgets/card_content.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class QrLicenseInfo extends StatelessWidget {
  const QrLicenseInfo(this.licenseInfo, {super.key});
  final QrLicenseMessage? licenseInfo;

  @override
  Widget build(BuildContext context) {
    final hasDisabledPersonsInfo = licenseInfo?.serveDisabledPersons == true;
    final hasDeliveryInfo = licenseInfo?.hasDelivery == true;

    if (!hasDeliveryInfo && !hasDisabledPersonsInfo) {
      return const SizedBox.shrink();
    }

    return CardContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasDeliveryInfo)
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/svg/poi_card/Truck.svg',
                    package: PackageConfig.packageName,
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    context.l10n.deliveryAvailable,
                    style: context.textStyle.text.copyWith(color: context.color.textAndIconsBasePrimary),
                  ),
                ],
              ),
            ),
          if (hasDeliveryInfo && hasDisabledPersonsInfo)
            const Divider(
              height: 1,
              indent: 32,
            ),
          if (hasDisabledPersonsInfo)
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/svg/poi_card/Accessibility.svg',
                    package: PackageConfig.packageName,
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.l10n.accessibility,
                        style: context.textStyle.text,
                      ),
                      Text(
                        context.l10n.motorVisual,
                        style: context.textStyle.footNote.copyWith(
                          color: context.color.textAndIconsBasePrimary.withOpacity(
                            0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
