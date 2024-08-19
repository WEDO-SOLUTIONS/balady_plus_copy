part of '../poi_card_footer.dart';

class _EntranceItem extends StatelessWidget {
  static const int flex = 2;
  final bool hasEntrances;
  final void Function() onEntranceTap;
  const _EntranceItem({
    required this.hasEntrances,
    required this.onEntranceTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasEntrances) {
      return const SizedBox.shrink();
    }

    return FooterIconButton(
      flex: flex,
      assetName: 'assets/icons/svg/ic_entrance.svg',
      onTap: onEntranceTap,
      colorIcon: context.color.textAndIconsStatusAccent,
      colorButton: context.staticColor.surfaceStatusContrastAccent,
    );
  }
}
