part of '../footer.dart';

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
      // onTap: () => widget.viewModel.onEntranceTap(objectMessage),
      // desc: (hasContacts == false)
      //     ? Text(
      //         context.l10n.exits,
      //         style: Theme.of(context)
      //             .extension<ThemeTextStyles>()!
      //             .accentS
      //             .copyWith(color: context.color.text_and_icons_base_primary.withOpacity(0.5)),
      //         overflow: TextOverflow.ellipsis,
      //         maxLines: 1,
      //         textAlign: TextAlign.start,
      //       )
      //     : const SizedBox.shrink(),
    );
  }
}
