import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/shared/config/package_config.dart';

class CloseButtonPOI extends StatelessWidget {
  const CloseButtonPOI({
    required this.onTapClose,
    super.key,
  });

  final Function()? onTapClose;

  @override
  Widget build(BuildContext context) => Material(
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
              color: context.color.textAndIconsBasePrimary.withAlpha(10),
            ),
            padding: const EdgeInsets.all(8),
            child: SvgPicture.asset(
              'assets/icons/svg/ic_search_close.svg',
              package: PackageConfig.packageName,
              colorFilter: ColorFilter.mode(
                context.color.textAndIconsBasePrimary.withOpacity(0.7),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      );
}
