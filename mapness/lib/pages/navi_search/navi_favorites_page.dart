import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/features/favorite_lists/providers/all_favourite_items.dart';
import 'package:mapness/features/favourites/helpers/favourite_entity_id.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';
import 'package:mapness/widgets/favourites/favourite_item_widget.dart';
import 'package:provider/provider.dart';

@RoutePage()
class NaviFavoritesPage extends HookConsumerWidget {
  const NaviFavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(allFavouriteItemsProvider);
    return asyncState.map(
      error: (error) => ErrorSheetWidget(
        buttonLabel: context.l10n.tryAgain,
        onRetry: () {
          ref.invalidate(allFavouriteItemsProvider);
        },
        onClose: (_) => context.router.pop(),
      ),
      loading: (_) => Material(
        color: context.colors.backgroundSurface1,
        child: Center(child: CircularProgressIndicator(color: context.colors.accentDefault)),
      ),
      data: (data) {
        final allFav = data.value;

        return Scaffold(
          appBar: BaladyTopBar(
            systemUiOverlayStyle: context.read<ThemeController>().systemOverlayStyle,
            title: context.l10n.favorites,
            onLeadingPressed: () => context.router.pop(),
            leading: Semantics(
              label: context.l10n.a11yBack,
              button: true,
              child: ExcludeSemantics(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: Spacing.$4x),
                    Icon(SystemIcons.arrowCornerLeftLarge, color: context.colors.foregroundDefault),
                    const SizedBox(width: Spacing.$4x),
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: context.colors.backgroundSurface4,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: Spacing.$4x.heightBox),
                if (allFav.isEmpty)
                  SliverToBoxAdapter(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: context.colors.backgroundSurface2,
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(Spacing.$4x),
                            child: Text(
                              context.l10n.toSavePlacesAsFavoritesOpenTheCardAndTapTheBookmarkIcon,
                              textAlign: TextAlign.center,
                              style: context.textStyle.text.copyWith(color: context.colors.foregroundDefault),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x, bottom: Spacing.$4x),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                fit: BoxFit.fitWidth,
                                ref.read(appLanguageProvider) == Language.arabic
                                    ? Assets.images.favoritesExampleArabic.keyName
                                    : Assets.images.favoritesExampleEnglish.keyName,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                SliverList.separated(
                  itemCount: allFav.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, index) {
                    final item = allFav[index];
                    const radius = Radius.circular(RadiusBorder.l);
                    return Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: context.colors.backgroundSurface2,
                        borderRadius: BorderRadius.vertical(
                          top: index == 0 ? radius : Radius.zero,
                          bottom: index == allFav.length - 1 ? radius : Radius.zero,
                        ),
                      ),
                      child: FavouriteItemWidget(
                        isLongPressEnabled: false,
                        isDeletable: false,
                        isSelected: false,
                        isEditing: false,
                        icon: SystemIcons.bookmark.icon(color: context.colors.foregroundMuted),
                        key: ValueKey(item.id),
                        isFirst: index == 0,
                        isLast: index == allFav.length - 1,
                        onTap: () => context.router.replaceOrPush(
                          route: PoiCardWidgetRoute(
                            objectId: DgisObjectIdMessage(
                              objectId: parseObjectIdFromFavouriteEntityId(item.entity?.id)!,
                              entranceId: 0,
                            ),
                          ),
                          toCompareRoutes: [PoiCardWidgetRoute.page],
                        ),
                        item: item,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
