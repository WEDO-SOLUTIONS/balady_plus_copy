part of 'toast_overlay.dart';

class _ToastWidget extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final String? actionText;
  final String? iconAsset;
  final IconData? iconData;
  final Color? iconColor;
  final bool isFlipped;

  final VoidCallback? onActionTap;
  final VoidCallback? onCloseTap;

  const _ToastWidget({
    required this.title,
    this.titleStyle,
    this.actionText,
    this.onActionTap,
    this.onCloseTap,
    this.iconData,
    this.iconColor,
    this.iconAsset,
    this.isFlipped = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasAction = actionText != null;
    final children = [
      if (onCloseTap != null) ...[
        GestureDetector(
          onTap: onCloseTap,
          child: Icon(
            SystemIcons.closeSmall,
            color: context.colorsV2.foregroundDefault,
          ),
        ),
        const SizedBox(width: Spacing.$2x),
      ],
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
                  Text(
                    title,
                    style: titleStyle ?? context.textStyleV3.bodyLargeRegular,
                  ),
                  if (hasAction)
                    GestureDetector(
                      onTap: onActionTap,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: Spacing.$3x),
                        child: Text(
                          actionText!,
                          style: context.textStyleV3.bodyLargeRegular.copyWith(
                            color: context.colorsV2.accentActive,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
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
    ];

    return SafeArea(
      child: Container(
        constraints: const BoxConstraints(minHeight: 44),
        padding: EdgeInsets.only(
          left: Spacing.$3x,
          right: Spacing.$3x,
          top: Spacing.$3x + Spacing.$0_5x,
          bottom: hasAction ? 0.0 : Spacing.$3x + Spacing.$0_5x,
        ),
        decoration: BoxDecoration(
          color: context.colorsV2.backgroundSurface1,
          borderRadius: BorderRadius.circular(20),
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
}
