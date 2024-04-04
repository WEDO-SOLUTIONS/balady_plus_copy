part of '../footer.dart';

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
      final textStyle = context.textStyle.accentS;
      final color = context.color.text_and_icons_status_accent;
      final style = textStyle.copyWith(color: color);
      return FooterIconButton(
        flex: flex,
        assetName: 'assets/icons/svg/ic_share.svg',
        colorIcon: context.color.text_and_icons_status_accent,
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
      flex: flex,

      assetName: 'assets/icons/svg/ic_share.svg',
      colorIcon: context.color.text_and_icons_status_accent,
      onTap: onTap, // () => viewModel.share(objectMessage),
    );
  }
}
