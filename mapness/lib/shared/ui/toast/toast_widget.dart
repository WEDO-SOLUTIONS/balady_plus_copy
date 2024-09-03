part of 'toast_overlay.dart';

class _ToastWidget extends StatelessWidget {
  final String title;
  final String actionText;
  final String? iconAsset;
  final IconData? iconData;

  final VoidCallback onActionTap;

  const _ToastWidget({
    required this.title,
    required this.actionText,
    required this.onActionTap,
    this.iconData,
    this.iconAsset,
  });

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Container(
          padding: const EdgeInsets.only(
            left: Spacing.$4x,
            right: Spacing.$4x,
            top: Spacing.$3x,
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
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: context.textStyleV3.bodyLargeRegular,
                    ),
                    GestureDetector(
                      onTap: onActionTap,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: Spacing.$3x),
                        child: Text(
                          actionText,
                          style: context.textStyleV3.bodyLargeRegular.copyWith(
                            color: context.colorsV2.accentActive,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.$2x),
              if (iconData != null)
                Icon(
                  iconData,
                  color: context.colorsV2.foregroundDefault,
                )
              else if (iconAsset != null)
                SvgPicture.asset(iconAsset!),
            ],
          ),
        ),
      );
}
