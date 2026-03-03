import 'package:mapness/shared/providers/theme_controller.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/string_ext.dart';
import 'package:provider/provider.dart';

class EtaShareExpired extends ConsumerWidget {
  final String title;
  final String subtitle;

  const EtaShareExpired({required this.title, required this.subtitle, super.key});

  factory EtaShareExpired.liveLocation(BuildContext context) => EtaShareExpired(
    title: context.l10n.locationUnavailable,
    subtitle: context.l10n.locationBroadcastExpired.multilines,
  );

  factory EtaShareExpired.eta(BuildContext context) =>
      EtaShareExpired(title: context.l10n.driveEnded, subtitle: context.l10n.driverReachedDestination.multilines);

  factory EtaShareExpired.broadcastExpired(BuildContext context) => EtaShareExpired(
    title: context.l10n.locationUnavailableEta,
    subtitle: context.l10n.broadcastHasExpired.multilines,
  );

  String asset(BuildContext context) => switch (context.read<ThemeController>().currentTheme) {
    BaladyAppThemes.dark => Assets.imagesSvg.illustrationErrorDark.keyName,
    BaladyAppThemes.light => Assets.imagesSvg.illustrationError.keyName,
    BaladyAppThemes.saudiDay => Assets.imagesSvg.illustrationError.keyName,
    BaladyAppThemes.foundationDay => Assets.imagesSvg.illustrationError.keyName,
    BaladyAppThemes.mekkah => Assets.imagesSvg.illustrationError.keyName,
  };
  @override
Widget build(BuildContext context, WidgetRef ref) => Container(
        decoration: BoxDecoration(
          color: context.colors.backgroundSurface2,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(RadiusBorder.xl),
            topRight: Radius.circular(RadiusBorder.xl),
          ),
        ),
        child: Column(
          children: [
            ContentRow(
              options: ContentRowOptions(
                padding: EdgeInsets.zero,
                titleStyle: context.textStyles.h3SemiBold.copyWith(color: context.colors.foregroundDefault),
                customActionWidget: AppButton.close(
                  onTap: Navigator.of(context).pop,
                  padding: EdgeInsets.zero,
                  textColor: context.colors.neutralOnContainer,
                  color: context.colors.neutralContainerDefault,
                  innerPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                ),
              ),
            ),
            SvgPicture.asset(
              ref.watch(activeCityEventProvider)?.illustrationError ?? Assets.imagesSvg.illustrationError.keyName,
            ),
            const SizedBox(height: Spacing.$2x),
            Text(
              title,
              style: context.textStyles.h3SemiBold.copyWith(
                color: context.colors.foregroundDefault,
              ),
            ),
            const SizedBox(height: Spacing.$3x),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: context.textStyles.bodyLargeRegular.copyWith(
                color: context.colors.foregroundSoft,
              ),
            ),
            const SizedBox(
              height: Spacing.$8x,
            )
          ],
        ),
      );
}
