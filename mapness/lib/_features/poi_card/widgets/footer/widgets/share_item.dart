part of '../poi_card_footer.dart';

class _ShareItem extends StatelessWidget {
  final bool hasContactsAndHasEntrances;
  final int flex;
  final void Function() onTap;
  const _ShareItem({
    required this.hasContactsAndHasEntrances,
    required this.flex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (hasContactsAndHasEntrances) {
      final textStyle = context.textStyle.footNoteBold;
      final color = context.color.textAndIconsStatusAccent;
      final style = textStyle.copyWith(color: color);
      return FooterIconButton(
        flex: flex,
        assetName: 'assets/icons/svg/ic_share.svg',
        colorIcon: context.color.textAndIconsStatusAccent,
        desc: Text(
          context.l10n.share,
          style: style,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.start,
        ),
        onTap: onTap,
      );
    }
    return FooterIconButton(
      onTap: onTap,
      flex: flex,
      assetName: 'assets/icons/svg/ic_share.svg',
      colorIcon: context.color.textAndIconsStatusAccent,
      colorButton: context.staticColor.surfaceStatusContrastAccent,
    );
  }
}
