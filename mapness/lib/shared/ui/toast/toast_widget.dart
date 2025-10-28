part of 'toast_overlay.dart';

class _ToastWidget extends ConsumerWidget {
  final String title;
  final TextStyle? titleStyle;
  final List<ToastAction> actions;
  final ToastIcon? icon;
  final bool isFlipped;

  const _ToastWidget({
    required this.title,
    required this.actions,
    this.titleStyle,
    this.isFlipped = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                          style: titleStyle ?? context.textStyles.bodyLargeRegular,
                        ),
                      ),
                      const SizedBox(width: Spacing.$2x),
                      switch (icon) {
                        ToastIconAsset() => SvgPicture.asset((icon as ToastIconAsset).asset),
                        ToastIconData() => Icon((icon as ToastIconData).data,
                            color: (icon as ToastIconData).color ?? context.colors.foregroundDefault),
                        null => const SizedBox.shrink(),
                      },
                    ],
                  ),
                  Row(
                    children: actions
                        .mapIndexed<Widget>(
                          (index, action) => CupertinoButton(
                            onPressed: action.onTap,
                            padding: EdgeInsets.zero,
                            minSize: 0,
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(
                                top: Spacing.$3x,
                                bottom: Spacing.$3x,
                                start: index != 0 ? Spacing.$4x : 0,
                              ),
                              child: Text(
                                action.title,
                                style: context.textStyles.bodySmallSemiBold.copyWith(
                                  color: context.colors.accentDefault,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
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
          bottom: actions.isNotEmpty ? 0.0 : Spacing.$3x + Spacing.$0_5x,
        ),
        decoration: BoxDecoration(
          color: context.colors.backgroundSurface1,
          borderRadius: BorderRadius.circular(RadiusBorder.l),
          boxShadow: Shadows.m,
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
