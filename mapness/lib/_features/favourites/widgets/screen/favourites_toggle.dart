import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/providers/favourite_markers.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';

class FavouritesToggle extends ConsumerWidget {
  const FavouritesToggle({required this.isEditing, super.key});
  final bool isEditing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(favouriteToggleProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: ShapeDecoration(
        color: NonThemeColor.color46,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            context.l10n.showFavoritesOnMap,
            textAlign: TextAlign.right,
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .heading2
                .copyWith(color: NonThemeColor.color47),
          ),
          const Spacer(),
          CupertinoSwitch(
            value: state,
            activeColor: NonThemeColor.color32,
            onChanged: isEditing
                ? null
                : (_) async {
                    ref.read(urbiMetricsProvider.notifier).logEvent(
                          'Favorites/Toggle show on map => Tap',
                        );
                    await ref.read(favouriteToggleProvider.notifier).toggle();
                    ref.read(layersControlsProvider.notifier).updateLayerInfo();
                  },
          ),
        ],
      ),
    );
  }
}
