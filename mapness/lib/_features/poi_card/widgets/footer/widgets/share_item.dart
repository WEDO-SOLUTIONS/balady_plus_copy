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
  Widget build(BuildContext context) => FooterIconButton(
        onTap: onTap,
        flex: flex,
        assetName: 'assets/icons/svg/ic_share.svg',
        colorIcon: context.color.textAndIconsStatusAccent,
        colorButton: context.staticColor.surfaceStatusContrastAccent,
      );
}
