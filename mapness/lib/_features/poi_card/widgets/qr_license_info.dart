import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/_features/poi_card/domain/model/qr_trade_license.dart';
import 'package:mapness/_features/poi_card/widgets/card_content.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class QrLicenseInfo extends StatelessWidget {
  final QrLicenseMessage? licenseInfo;

  const QrLicenseInfo(this.licenseInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    var hasDisabledPersonsInfo = licenseInfo?.serveDisabledPersons == true;
    var hasDeliveryInfo = licenseInfo?.hasDelivery == true;

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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
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
                    style:
                        context.textStyle.textM.copyWith(color: colorPrimary),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
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
                        style: context.textStyle.textM,
                      ),
                      Text(
                        context.l10n.motorVisual,
                        style: context.textStyle.textS.copyWith(
                            color: colorPrimary.withOpacity(
                          0.5,
                        )),
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
