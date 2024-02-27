import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/providers/search_in_rect.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';

class SearchInArea extends ConsumerWidget {
  const SearchInArea({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visible = ref.watch(searchInRectProvider.select(
      (value) => value.$2,
    ));

    return visible
        ? MapButton(
            onTap: () {
              ref.read(searchInRectProvider.notifier).update();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: Text(
                context.l10n.searchInThisArea,
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()
                    ?.accentM
                    .copyWith(
                      color: context.color.text_and_icons_base_primary,
                    ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
