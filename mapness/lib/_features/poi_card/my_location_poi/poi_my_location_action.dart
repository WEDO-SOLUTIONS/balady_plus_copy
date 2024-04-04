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
    final textStyle = context.textStyle.accentM;
    final accent = context.color.text_and_icons_status_accent;
    final primary = context.color.text_and_icons_base_inverse_primary;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
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
                  style: textStyle.copyWith(color: accent),
                ),
                assetName: 'assets/icons/svg/ic_copy.svg',
                colorIcon: accent,
                onTap: onCopy,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
