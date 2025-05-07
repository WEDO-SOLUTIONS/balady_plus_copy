import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/icons/system_icons.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';
import 'package:mapness/widgets/favourites/empty_result_widget.dart';
import 'package:mapness/widgets/favourites/favourite_item_widget.dart';

@RoutePage()
class FavouritesPickerPage extends ConsumerWidget {
  const FavouritesPickerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(favouriteCacheProvider);
    if (asyncState.isLoading) {
      return Material(
        color: context.color.surfaceBasePrimary,
        child: Center(
          child: CircularProgressIndicator(
            color: context.color.textAndIconsStatusAccent,
          ),
        ),
      );
    }
    if (asyncState.hasError) {
      return ErrorSheetWidget(
        buttonLabel: context.l10n.tryAgain,
        onRetry: () => ref.invalidate(favouriteCacheProvider),
        onClose: (_) => context.router.popForced(),
      );
    }
    final state = asyncState.requireValue;

    return Material(
      color: NonThemeColor.color11,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ColoredBox(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: SafeArea(
                bottom: false,
                child: Stack(
                  children: [
                    Align(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          context.l10n.favourites,
                          style: Theme.of(context).extension<ThemeTextStyles>()!.footNoteBold.copyWith(
                                color: context.color.textAndIconsBasePrimary,
                              ),
                        ),
                      ),
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          context.router.popForced();
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            SystemIcons.arrowCornerLeftLarge,
                            color: context.color.textAndIconsBasePrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              child: Container(
                color: context.color.surfaceBasePrimary,
                child: state.items.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 63,
                        ),
                        child: EmptyResultWidget(
                          text: context.l10n.toSavePlacesAsFavoritesOpenTheCardAndTapTheBookmarkIcon,
                        ),
                      )
                    :

                    /// items
                    ListView.separated(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16,
                        ),
                        itemCount: state.items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, index) {
                          final item = state.items[index];

                          /// item
                          return Padding(
                            padding:
                                index == (state.items.length - 1) ? const EdgeInsets.only(bottom: 8) : EdgeInsets.zero,
                            child: FavouriteItemWidget(
                              key: ValueKey(item.id),
                              onTap: () => context.router.popForced(item),
                              isEditing: false,
                              isDeletable: false,
                              isLongPressEnabled: false,
                              item: item,
                              isFirst: false,
                              isLast: false,
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
