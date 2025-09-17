import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/saudi_national_day/saudi_national_day.dart';

class TrafficControlWidget extends StatelessWidget {
  final double opacity;
  final bool isEnabled;
  final BorderRadius? borderRadius;
  final Function()? onTap;

  const TrafficControlWidget({
    required this.opacity,
    required this.isEnabled,
    this.borderRadius,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 250),
        child: MapButton(
          borderRadius: borderRadius,
          onTap: onTap,
          child: SizedBox(
            width: 24,
            height: 24,
            child: SvgPicture.asset(
              isEnabled
                  ? SaudiNationalDay.isNow()
                      ? Assets.icons.svg.carActiveSaudi.keyName
                      : Assets.icons.svg.carActive.keyName
                  : Assets.icons.svg.car.keyName,
              // package: packageName,
              colorFilter: onTap == null
                  ? ColorFilter.mode(
                      context.colors.foregroundMuted.withOpacity(0.36),
                      BlendMode.srcIn,
                    )
                  : null,
            ),
          ),
        ),
      );
}
