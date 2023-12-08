import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mapness/_features/favourites/providers/favourite_markers.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class FavouritesToggle extends ConsumerWidget {
  final bool isEditing;

  const FavouritesToggle({required this.isEditing, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(favouriteToggleProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: ShapeDecoration(
        color: const Color(0x238DBABD),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            context.l10n.showFavoritesOnMap,
            textAlign: TextAlign.right,
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .textL
                .copyWith(color: const Color(0xFF001022)),
          ),
          const Spacer(),
          CupertinoSwitch(
            value: state,
            activeColor: const Color(0xFF42909B),
            onChanged: isEditing
                ? null
                : (_) async =>
                    await ref.read(favouriteToggleProvider.notifier).toggle(),
          ),
        ],
      ),
    );
  }
}
