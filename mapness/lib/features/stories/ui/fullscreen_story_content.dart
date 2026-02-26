part of 'fullscreen_strory_error.dart';

class _FullscreenErrorContent extends StatelessWidget {
  final VoidCallback? onClose;
  final VoidCallback? onRetry;
  final String? buttonLabel;
  final String? errorLabel;
  final String? errorTitle;

  const _FullscreenErrorContent({this.onClose, this.onRetry, this.buttonLabel, this.errorLabel, this.errorTitle});

  String asset(BuildContext context) => switch (context.read<ThemeController>().currentTheme) {
    BaladyAppThemes.dark => Assets.imagesSvg.illustrationErrorDark.keyName,
    BaladyAppThemes.light => Assets.imagesSvg.illustrationError.keyName,
    BaladyAppThemes.saudiDay => Assets.imagesSvg.illustrationError.keyName,
  };

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      if (onClose != null)
        Padding(
          padding: const EdgeInsetsDirectional.only(end: Spacing.$4x),
          child: Align(
            alignment: AlignmentDirectional.topEnd,
            child: Padding(
              padding: const EdgeInsets.only(bottom: Spacing.$2x, top: Spacing.$1x),
              child: BaladyAppButton(
                buttonType: BaladyButtonType.secondary,
                buttonColorScheme: BaladyButtonColorScheme.neutral,
                primaryIcon: SystemIcons.close,
                onTap: () => context.router.pop(),
              ),
            ),
          ),
        ),
      const Spacer(),
      Padding(padding: EdgeInsets.zero, child: SvgPicture.asset(asset(context))),
      Padding(
        padding: const EdgeInsets.only(top: Spacing.$4x, bottom: Spacing.$2x),
        child: Text(
          errorTitle ?? context.l10n.somethingWentWrong,
          textAlign: TextAlign.center,
          style: context.textStyleV3.h3SemiBold.copyWith(color: context.colors.foregroundDefault),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$3x),
        child: Text(
          errorLabel ?? context.l10n.somethingWentWrongPleaseTryAgainLater,
          textAlign: TextAlign.center,
          style: context.textStyleV3.bodyLargeRegular.copyWith(color: context.colors.foregroundSoft),
        ),
      ),
      const Spacer(),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
        child: BaladyAppButton(
          onTap: onRetry,
          size: BaladyButtonSize.large,
          buttonColorScheme: BaladyButtonColorScheme.accentSecondary,
          primaryLabel: buttonLabel ?? context.l10n.tryAgain,
        ),
      ),
    ],
  );
}
