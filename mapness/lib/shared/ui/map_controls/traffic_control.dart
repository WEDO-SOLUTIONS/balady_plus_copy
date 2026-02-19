import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:provider/provider.dart';

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
  String car(BuildContext context) => switch (context.read<ThemeController>().currentTheme) {
    BaladyAppThemes.dark => Assets.icons.svg.darkCar.keyName,
    BaladyAppThemes.light => Assets.icons.svg.car.keyName,
    BaladyAppThemes.saudiDay => Assets.icons.svg.car.keyName,
  };
  String carActive(BuildContext context) => switch (context.read<ThemeController>().currentTheme) {
    BaladyAppThemes.dark => Assets.icons.svg.darkCarActive.keyName,
    BaladyAppThemes.light => Assets.icons.svg.carActive.keyName,
    BaladyAppThemes.saudiDay => Assets.icons.svg.carActiveSaudi.keyName,
  };

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
          isEnabled ? carActive(context) : car(context),
          // package: packageName,
          colorFilter: onTap == null
              ? ColorFilter.mode(context.colors.foregroundDefault.withOpacity(0.36), BlendMode.srcIn)
              : null,
        ),
      ),
    ),
  );
}
