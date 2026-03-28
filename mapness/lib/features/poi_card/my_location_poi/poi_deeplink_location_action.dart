part of 'content_deeplink.dart';

class PoiDeeplinkPersonActions extends StatelessWidget {
  final Function()? onShare;
  final Function()? onSave;
  final Function()? onGo;

  const PoiDeeplinkPersonActions({
    super.key,
    this.onShare,
    this.onSave,
    this.onGo,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textStyle.footNoteBold;
    final accent = context.colors.accentDefault;
    final primary = context.color.textAndIconsBaseInversePrimary;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.backgroundSurface2,
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
                  context.l10n.go,
                  style: textStyle.copyWith(color: primary),
                ),
                colorIcon: primary,
                colorButton: accent,
                onTap: onGo,
              ),
              // BALADY-211: In the future, we will add the ability to save a random point to favorites
              // But now it is out of scope of the task
              if (onSave != null)
                FooterIconButton(
                  desc: Text(
                    context.l10n.save,
                    style: textStyle.copyWith(color: accent),
                  ),
                  assetName: Assets.icons.svg.icFav.keyName,
                  colorIcon: accent,
                  onTap: onSave,
                ),
              FooterIconButton(
                desc: Text(
                  context.l10n.share,
                  style: textStyle.copyWith(color: accent),
                ),
                assetName: Assets.icons.svg.icShare.keyName,
                colorIcon: accent,
                onTap: onShare,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
