import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';
import 'package:mapness/widgets/favourites/favourite_item_widget.dart';

@RoutePage()
class NaviFavoritesPage extends HookConsumerWidget {
  const NaviFavoritesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(favouriteCacheProvider);
    return asyncState.map(
      error: (error) => ErrorSheetWidget(
        buttonLabel: context.l10n.tryAgain,
        onRetry: () {
          ref.invalidate(favouriteCacheProvider);
        },
        onClose: (_) => context.router.popForced(),
      ),
      loading: (_) => Material(
        color: context.color.surfaceBasePrimary,
        child: Center(
          child: CircularProgressIndicator(
            color: context.color.textAndIconsStatusAccent,
          ),
        ),
      ),
      data: (data) {
        final state = data.value;
        final allFav = <FavouriteItem>[
          if (state.home != null) state.home!,
          if (state.work != null) state.work!,
          ...List.of(state.items),
        ];

        return Scaffold(
          appBar: BaladyTopBar.iconAndText(
            systemUiOverlayStyle: SystemUiOverlayStyle.dark,
            title: context.l10n.favorites,
            leading: ActionModel(
              icon: SystemIcons.arrowCornerLeftLarge,
              onPressed: () => context.router.popForced(),
            ),
          ),
          backgroundColor: context.colorsV3.backgroundSurface4,
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.$4x,
            ),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Spacing.$4x.heightBox,
                ),
                if (allFav.isEmpty)
                  SliverToBoxAdapter(
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: context.colorsV3.backgroundSurface2,
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(Spacing.$4x),
                              child: Text(
                                context.l10n.toSavePlacesAsFavoritesOpenTheCardAndTapTheBookmarkIcon,
                                textAlign: TextAlign.center,
                                style: context.textStyle.text.copyWith(
                                  color: context.colorsV3.foregroundDefault,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: Spacing.$4x,
                                right: Spacing.$4x,
                                bottom: Spacing.$4x,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  fit: BoxFit.fitWidth,
                                  ref.read(appLanguageProvider) == Language.arabic
                                      ? 'assets/images/favorites_example_arabic.png'
                                      : 'assets/images/favorites_example_english.png',
                                  package: PackageConfig.packageName,
                                ),
                              ),
                            ),
                          ],
                        )),
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
                        color: context.colorsV3.backgroundSurface2,
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
                        icon: SystemIcons.bookmark.icon(
                          color: context.colorsV3.foregroundMuted,
                        ),
                        key: ValueKey(item.id),
                        isFirst: index == 0,
                        isLast: index == allFav.length - 1,
                        onTap: () => context.router.replaceOrPush(
                          route: PoiCardWidgetRoute(
                            objectId: DgisObjectIdMessage(
                              objectId: int.parse(item.entity!.id),
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
