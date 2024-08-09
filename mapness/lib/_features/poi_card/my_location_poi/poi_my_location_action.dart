part of 'content_my_location.dart';

class MyLocationPoiActions extends StatelessWidget {
  final Function()? onShare;
  final Function()? onCopy;

  const MyLocationPoiActions({
    super.key,
    this.onShare,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textStyle.footNoteBold;
    final accent = context.colorsV2.accentDefault;
    final secondary = context.staticColor.surfaceStatusContrastAccent;
    final primary = context.color.textAndIconsBaseInversePrimary;
    final secondaryText = context.color.textAndIconsStatusAccent;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.color.surfaceBasePrimary,
        boxShadow: Shadows.s,
      ),
      padding: const EdgeInsets.all(8),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FooterIconButton(
                desc: Text(
                  context.l10n.share,
                  style: textStyle.copyWith(color: primary),
                ),
                assetName: 'assets/icons/svg/ic_share.svg',
                colorIcon: primary,
                colorButton: accent,
                onTap: onShare,
              ),
              FooterIconButton(
                desc: Text(
                  context.l10n.copy,
                  style: textStyle.copyWith(color: secondaryText),
                ),
                assetName: 'assets/icons/svg/ic_copy.svg',
                colorIcon: secondaryText,
                colorButton: secondary,
                onTap: onCopy,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
