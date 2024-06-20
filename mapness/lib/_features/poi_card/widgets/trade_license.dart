import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/poi_card/widgets/card_content.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class TradeLicense extends StatelessWidget {
  const TradeLicense(this.tradeLicense, {super.key});
  final TradeLicenseMessage? tradeLicense;

  @override
  Widget build(BuildContext context) {
    final title = tradeLicense?.license ?? '11234567898765432';
    final subtitle = context.l10n.tinId;
    return CardContent(
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/svg/ic_info_circle.svg',
                package: PackageConfig.packageName,
                height: 24,
                width: 24,
              ),
              const SizedBox(
                width: 8,
              ),
              Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: context.color.textAndIconsBasePrimary.withAlpha(125),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: context.color.textAndIconsBasePrimary.withAlpha(125),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
