import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mapness/_features/favourites/providers/favourite_markers.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class FavouritesToggle extends ConsumerWidget {
  const FavouritesToggle({required this.isEditing, super.key});

  final bool isEditing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(favouriteToggleProvider);

    return ContentWrapper(
      color: context.color.surfaceBaseSecondary,
      children: [
        ContentRow(
          onToggle: isEditing
              ? null
              : (_) async {
                  await ref.read(favouriteToggleProvider.notifier).toggle();
                  ref.read(layersControlsProvider.notifier).updateLayerInfo();
                },
          options: ContentRowOptions(
            actionWidget: ContentRowActionOptions(
              toggleInitialValue: state,
              enabledToggle: true,
            ),
            title: context.l10n.showFavoritesOnMap,
          ),
        ),
      ],
    );
  }
}
