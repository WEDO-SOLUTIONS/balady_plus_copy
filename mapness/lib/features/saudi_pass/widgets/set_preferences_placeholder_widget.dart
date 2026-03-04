import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/ui/error_widget/base_error_widget.dart';
import 'package:provider/provider.dart';

class SetPreferencesPlaceholderWidget extends ConsumerWidget {
  final VoidCallback action;

  const SetPreferencesPlaceholderWidget({required this.action, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(darkModeProvider).value?.isDark ?? false;

    return _PlaceholderWidget(
      assetWidget: SvgPicture.asset(ref.read(activeCityEventProvider).getIllustrationPercent(isDark: isDark)),
      action: action,
      title: context.l10n.saudiPassOffersSetPreferences,
      hint: context.l10n.saudiPassOffersSetPreferencesHint,
      actionTitle: context.l10n.saudiPassOffersGoToPreferences,
    );
  }
}

class LoginPreferencesPlaceholderWidget extends ConsumerWidget {
  final VoidCallback action;

  const LoginPreferencesPlaceholderWidget({required this.action, super.key});

  Widget asset(BuildContext context) => switch (context.read<ThemeController>().currentTheme) {
    BaladyAppThemes.dark => Assets.imagesSvg.illustrationPercentDark.svg(),
    BaladyAppThemes.light => Assets.imagesSvg.illustrationPercent.svg(),
    BaladyAppThemes.saudiDay => Assets.imagesSvg.illustrationPercent.svg(),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(darkModeProvider).value?.isDark ?? false;

    return _PlaceholderWidget(
      assetWidget: SvgPicture.asset(ref.read(activeCityEventProvider).getIllustrationPercent(isDark: isDark)),
      action: action,
      title: context.l10n.saudiPassOffersSetPreferences,
      hint: context.l10n.saudiPassOffersLoginHint,
      actionTitle: context.l10n.connectToMomrah,
    );
  }
}

class WentWrongPlaceholderWidget extends StatelessWidget {
  final VoidCallback action;

  const WentWrongPlaceholderWidget({required this.action, super.key});

  @override
  Widget build(BuildContext context) => _PlaceholderWidget(
    assetWidget: const ErrorImageWidget(),
    action: action,
    title: context.l10n.saudiPassSomethingWentWrong,
    hint: context.l10n.saudiPassSomethingWentWrongHint,
    actionTitle: context.l10n.saudiPassSomethingWentWrongTryAgainButton,
  );
}

class EmptyOffersWidget extends StatelessWidget {
  const EmptyOffersWidget({required this.action, super.key});

  final VoidCallback action;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      _PlaceholderWidget(
        assetWidget: const ErrorImageWidget(),
        action: action,
        title: context.l10n.saudiPassNothingFound,
        hint: context.l10n.saudiPassNothingFoundHint,
        actionTitle: context.l10n.saudiPassResetFilters,
      ),
    ],
  );
}

class _PlaceholderWidget extends StatelessWidget {
  final Widget assetWidget;
  final String title;
  final String hint;
  final VoidCallback action;
  final String actionTitle;

  const _PlaceholderWidget({
    required this.assetWidget,
    required this.title,
    required this.hint,
    required this.action,
    required this.actionTitle,
  });

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadiusDirectional.vertical(
      top: Radius.circular(RadiusBorder.xxl),
      bottom: Radius.circular(RadiusBorder.xl),
    );

    final textStyle = context.textStyleV3;
    final colors = context.colors;
    final hintStyle = textStyle.bodyLargeRegular.copyWith(color: colors.foregroundSoft);
    final titleStyle = textStyle.h3SemiBold.copyWith(color: colors.foregroundDefault);

    return ClipRRect(
      borderRadius: borderRadius,
      child: ColoredBox(
        color: colors.backgroundSurface1,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.$4x).copyWith(top: Spacing.$6x),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              assetWidget,
              const SizedBox(height: Spacing.$4x),
              Text(title, style: titleStyle),
              const SizedBox(height: Spacing.$2x),
              Text(hint, style: hintStyle, textAlign: TextAlign.center),
              const SizedBox(height: Spacing.$4x),
              FractionallySizedBox(
                widthFactor: 1,
                child: BaladyAppButton(
                  primaryLabel: actionTitle,
                  onTap: action,
                  size: BaladyButtonSize.large,
                  buttonColorScheme: BaladyButtonColorScheme.accentSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
