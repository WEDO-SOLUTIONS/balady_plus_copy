import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/favorite_lists/data/favorite_lists_api_exception.dart';
import 'package:mapness/features/favorite_lists/data/models/favorite_list_dto.dart';
import 'package:mapness/features/favorite_lists/data/models/icon_type.dart';
import 'package:mapness/features/favorite_lists/data/models/marker_color_code.dart';
import 'package:mapness/features/favorite_lists/data/models/migrate_legacy_favorites_result_dto.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_lists.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_lists_migration.dart';
import 'package:mapness/features/favorite_lists/ui/models/sheet_action_button.dart';
import 'package:mapness/features/favorite_lists/ui/widgets/favorite_list_places_content.dart';
import 'package:mapness/features/favorite_lists/ui/widgets/favorite_progress_indicator.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';

@RoutePage()
class FavoriteListsPage extends HookConsumerWidget {
  const FavoriteListsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasHandledMigrationBanner = useRef(false);
    ref.listen<AsyncValue<MigrateLegacyFavoritesResultDto?>>(
      favoriteListsMigrationProvider,
      (previous, next) {
        if (hasHandledMigrationBanner.value) {
          return;
        }
        final result = next.value;
        if (result == null || !result.showMigrationBanner) {
          return;
        }
        hasHandledMigrationBanner.value = true;
        context.router.push(
          ConfirmationSheetRoute(
            // TODO(claude): localize string
            title: 'Favorites migrated successfully',
            // TODO(claude): localize string
            message: 'Your existing favorites have been migrated to the new Favorites list.',
            buttons: [
              SheetActionButton(
                // TODO(claude): localize string
                label: 'Got it',
                buttonColorScheme: ButtonColorScheme.accent,
                buttonType: ButtonType.primary,
                onTap: () async => context.router.pop(),
              ),
            ],
          ),
        );
      },
    );

    final favoriteListsAsync = ref.watch(favoriteListsProvider);
    final favoriteListLimitsAsync = ref.watch(favoriteListLimitsProvider);
    final canCreateMoreLists = favoriteListsAsync.maybeWhen(
      data: (lists) => favoriteListLimitsAsync.maybeWhen(
        data: (limits) => lists.length < limits.maxLists,
        orElse: () => true,
      ),
      orElse: () => true,
    );

    return Scaffold(
      backgroundColor: context.colors.backgroundSurface4,
      appBar: BaladyTopBar.iconAndText(
        systemUiOverlayStyle: context.read<ThemeController>().systemOverlayStyle,
        leading: ActionModel(icon: SystemIcons.arrowCornerLeftLarge, onPressed: () => context.router.pop()),
        title: context.l10n.favorites,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.$4x),
          child: Column(
            spacing: 27,
            children: [
              _Section(
                // TODO(claude): localize string
                title: 'My addresses',
                child: ContentWrapper(
                  color: context.colors.backgroundSurface1,
                  children: [
                    ContentRow(
                      leading: Icon(GeneralIcons.home, color: context.colors.foregroundSoft),
                      // TODO(claude): localize string and pass address
                      text: const ContentRowTextOptions(title: 'Home', subtitle: 'Address'),
                      isDividerEnabled: true,
                      trailing: ContentRowTextTrailingOptions(
                        icon: SystemIcons.ellipsis,
                        iconColor: context.colors.foregroundSoft,
                        onPressed: () {
                          // todo open menu
                          context.router.push(const EditMyAddressesRoute());
                        },
                      ),
                      onTap: () {
                        // todo open POI
                      },
                    ),
                    ContentRow(
                      // todo valid icon
                      leading: Icon(GeneralIcons.buildings, color: context.colors.foregroundSoft),
                      // TODO(claude): localize string and pass address
                      text: const ContentRowTextOptions(title: 'Work', subtitle: 'Address'),
                      trailing: ContentRowTextTrailingOptions(
                        icon: SystemIcons.ellipsis,
                        iconColor: context.colors.foregroundSoft,
                        onPressed: () {
                          // todo open menu
                        },
                      ),
                      onTap: () {
                        // todo open POI
                      },
                    ),
                  ],
                ),
              ),
              _Section(
                // TODO(claude): localize string
                title: 'My Lists',
                child: ContentWrapper(
                  color: context.colors.backgroundSurface1,
                  children: [
                    if (canCreateMoreLists)
                      ContentRow(
                        leading: Icon(SystemIcons.zoomPlus, color: context.colors.accentDefault, size: 24),
                        // TODO(claude): localize string
                        text: ContentRowTextOptions(
                          title: 'Create a new list',
                          titleOptions: ContentRowTextOption(baseColor: context.colors.accentDefault),
                        ),
                        onTap: () {
                          context.router.push(CreateOrUpdateFavoriteListRoute());
                        },
                      ),
                    ContentRow(
                      leading: Icon(SystemIcons.bookmarkAdd, color: context.colors.accentDefault, size: 24),
                      text: ContentRowTextOptions(
                        title: context.l10n.addPlace,
                        titleOptions: ContentRowTextOption(baseColor: context.colors.accentDefault),
                      ),
                      isDividerEnabled: true,
                      onTap: () {
                        // todo create new list
                      },
                    ),
                    ...favoriteListsAsync.when(
                      data: (lists) => lists.map((list) {
                        final leading = (list.iconType ?? FavoriteIconType.$default).getIcon().svg(
                          colorFilter: ColorFilter.mode(list.markerColorCode.getColor(context.colors), BlendMode.srcIn),
                        );
                        final text = ContentRowTextOptions(
                          title: list.name,
                          subtitle: _favoriteListSubtitle(context, list),
                        );
                        final hasPlaces = (list.placeCount ?? 0) > 0;

                        if (!hasPlaces) {
                          return ContentRow(
                            leading: leading,
                            text: text,
                            onTap: () => context.router.push(FavoriteListDetailsRoute(list: list)),
                          );
                        }

                        return ContentRowExpandable(
                          leading: leading,
                          text: text,
                          trailingBuilder: (animationValue, easeInValue, isExpanded, toggleFunction) =>
                              ContentRowCustomTrailingOptions(
                                builder: (context) => InkWell(
                                  onTap: toggleFunction,
                                  child: Padding(
                                    padding:
                                        ContentRow.verticalPadding + ContentRow.endPadding + ContentRow.startPadding,
                                    child: Transform.rotate(
                                      angle: pi / 2 * animationValue,
                                      child: AppIcons(
                                        iconData: SystemIcons.arrowCornerRightSmall,
                                        color: context.colors.foregroundDefault,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          onTap: () => context.router.push(FavoriteListDetailsRoute(list: list)),
                          content: Padding(
                            padding: const EdgeInsets.symmetric(vertical: Spacing.$3x, horizontal: Spacing.$4x),
                            child: FavoriteListPlacesContent(listId: list.id),
                          ),
                        );
                      }).toList(),
                      loading: () => [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: Spacing.$4x),
                          child: FavoriteProgressIndicator(),
                        ),
                      ],
                      error: (error, stackTrace) => [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: Spacing.$4x),
                          child: Text(
                            error is FavoriteListsApiException
                                ? error.localizedMessage(ref.read(appLanguageProvider))
                                : context.l10n.somethingWentWrongPleaseTryAgainLater,
                            style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _favoriteListSubtitle(BuildContext context, FavoriteListDto list) {
  final languageCode = Localizations.localeOf(context).languageCode;
  final formattedDate = DateFormat('dd.MM.yy', languageCode).format(list.updatedAt);
  final placeCount = list.placeCount ?? 0;
  // TODO(claude): localize string and handle Arabic plural forms properly
  return 'Modified $formattedDate • $placeCount place${placeCount == 1 ? '' : 's'}';
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: Spacing.$4x,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: Spacing.$1x),
        child: Text(title, style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault)),
      ),
      child,
    ],
  );
}
