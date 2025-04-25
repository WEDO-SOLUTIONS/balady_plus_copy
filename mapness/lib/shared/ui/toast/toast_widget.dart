part of 'toast_overlay.dart';

class _ToastWidget extends ConsumerWidget {
  final String title;
  final TextStyle? titleStyle;
  final String? firstText;
  final String? secondText;
  final String? iconAsset;
  final IconData? iconData;
  final Color? iconColor;
  final bool isFlipped;

  final VoidCallback? onFirstTap;
  final VoidCallback? onSecondTap;

  const _ToastWidget({
    required this.title,
    this.titleStyle,
    this.secondText,
    this.firstText,
    this.onFirstTap,
    this.onSecondTap,
    this.iconData,
    this.iconColor,
    this.iconAsset,
    this.isFlipped = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasFirstAction = firstText != null;
    final hasSecondAction = secondText != null;
    final children = [
      Expanded(
        child: LayoutBuilder(
          builder: (context, constraints) => ConstrainedBox(
            constraints: constraints.copyWith(minHeight: 24),
            child: Align(
              alignment: context.isLTR ? Alignment.centerLeft : Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          _getTitle(l10n: ref.watch(appLocaleProvider), title: title),
                          style: titleStyle ?? context.textStyleV3.bodyLargeRegular,
                        ),
                      ),
                      const SizedBox(width: Spacing.$2x),
                      if (iconData != null)
                        Icon(
                          iconData,
                          color: iconColor ?? context.colorsV2.foregroundDefault,
                        )
                      else if (iconAsset != null)
                        SvgPicture.asset(iconAsset!),
                    ],
                  ),
                  Row(
                    children: [
                      if (hasFirstAction)
                        GestureDetector(
                          onTap: onFirstTap,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                              top: Spacing.$3x,
                              bottom: Spacing.$3x,
                            ),
                            child: Text(
                              firstText!,
                              style: context.textStyleV3.bodySmallSemiBold.copyWith(
                                color: context.colorsV3.accentDefault,
                              ),
                            ),
                          ),
                        ),
                      if (hasSecondAction)
                        GestureDetector(
                          onTap: onSecondTap,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                              top: Spacing.$3x,
                              bottom: Spacing.$3x,
                              start: Spacing.$4x,
                            ),
                            child: Text(
                              secondText!,
                              style: context.textStyleV3.bodySmallSemiBold.copyWith(
                                color: context.colorsV3.accentDefault,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ];

    return SafeArea(
      child: Container(
        constraints: const BoxConstraints(minHeight: 44),
        padding: EdgeInsets.only(
          left: Spacing.$4x,
          right: Spacing.$4x,
          top: Spacing.$3x + Spacing.$0_5x,
          bottom: hasFirstAction || hasSecondAction ? 0.0 : Spacing.$3x + Spacing.$0_5x,
        ),
        decoration: BoxDecoration(
          color: context.colorsV2.backgroundSurface1,
          borderRadius: BorderRadius.circular(RadiusBorder.l),
          boxShadow: const [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 56,
              offset: Offset(18, 0),
            ),
            BoxShadow(
              color: Color(0x0B000000),
              blurRadius: 20,
              offset: Offset(18, 0),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: isFlipped ? children.reversed.toList() : children,
        ),
      ),
    );
  }

  String _getTitle({
    required AppLocalizations l10n,
    required String title,
  }) =>
      switch (title) {
        'beta_notification' => l10n.firstToTryNavigation,
        _ => title,
      };
}
