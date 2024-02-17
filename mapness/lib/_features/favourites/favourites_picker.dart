import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/favourites/providers/favourite_repository.dart';
import 'package:mapness/_features/favourites/widgets/empty_result_widget.dart';
import 'package:mapness/_features/favourites/widgets/screen/favourite_item_widget.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';

class FavouritesPicker extends ConsumerWidget {
  const FavouritesPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(favouriteRepositoryProvider);

    if (asyncState.isLoading) {
      return Material(
        color: context.color.surface_base_primary,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (asyncState.hasError) {
      return ErrorSheet(
        buttonLabel: 'Reload',
        onClose: () => context.pop(),
        onRetry: () {
          ref.invalidate(favouriteRepositoryProvider);
        },
      );
    }
    final state = asyncState.requireValue;

    return Material(
      color: const Color(0x0D1E2A36),
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
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          context.l10n.favourites,
                          style: Theme.of(context)
                              .extension<ThemeTextStyles>()!
                              .accentM
                              .copyWith(
                                color: context.color.text_and_icons_base_primary,
                              ),
                        ),
                      ),
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          context.pop();
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: SvgPicture.asset(
                            'assets/icons/svg/ic_chevron_right.svg',
                            height: 24,
                            width: 24,
                            package: PackageConfig.packageName,
                            colorFilter: ColorFilter.mode(
                              context.color.text_and_icons_base_primary,
                              BlendMode.srcIn,
                            ),
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
            child: Container(
              color: context.color.surface_base_primary,
              child: state?.items.isEmpty ?? false
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 63,
                      ),
                      child: EmptyResultWidget(
                        text: context.l10n
                            .toSavePlacesAsFavoritesOpenTheCardAndTapTheBookmarkIcon,
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
                      itemCount: state?.items.length ?? 0,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, index) {
                        final item = state!.items[index];

                        /// item
                        return FavouriteItemWidget(
                          onTap: () {
                            context.pop(item);
                          },
                          onDelete: () {},
                          isEditing: false,
                          isDeletable: false,
                          item: item,
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
