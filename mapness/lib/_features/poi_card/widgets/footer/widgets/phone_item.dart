part of '../poi_card_footer.dart';

class _PhoneItem extends StatelessWidget {
  final bool hasContacts;
  final int flex;
  final void Function() onTap;

  const _PhoneItem({
    required this.hasContacts,
    required this.onTap,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasContacts) {
      return const SizedBox.shrink();
    }
    return FooterIconButton(
      flex: flex,
      assetName: 'assets/icons/svg/ic_phone_poi.svg',
      onTap: onTap,
      colorButton: context.staticColor.surfaceStatusContrastAccent,
      colorIcon: context.color.textAndIconsStatusAccent,
    );
  }
}
