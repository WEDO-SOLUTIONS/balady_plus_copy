import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/features/favourites/mappers/directory_object_message_mapper.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/suggest_item.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/analytic/bss_service.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:provider/provider.dart';

class FavouritesSuggestList extends ConsumerWidget {
  const FavouritesSuggestList({
    required this.suggest,
    required this.markerType,
    super.key,
  });

  final SuggestResultMessage suggest;
  final FavouriteItemMarkerType markerType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggests = suggest.suggests.whereType<SuggestMessage>().toList();
    final myLocation = ref.watch(locationProvider);
    final contentColor = context.colors.backgroundSurface1;
    final searchText = ref.read(searchProvider(context.read<SearchScope>().value)).searchText;

    Future<void> onObjectTap(DirectoryObjectMessage object) async {
      final objectId = object.id?.objectId;
      if (objectId != null) {
        final favItem = object.mapToFavourite();
        FocusManager.instance.primaryFocus?.unfocus();
        final repo = ref.read(favouriteCacheProvider.notifier);
        await switch (markerType) {
          FavouriteItemMarkerType.unknown || FavouriteItemMarkerType.place => repo.addItem(favItem),
          FavouriteItemMarkerType.home => repo.setHome(favItem),
          FavouriteItemMarkerType.work => repo.setWork(favItem),
        };
        if (context.mounted && context.router.canPop()) {
          context.router.pop(favItem);
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.only(
        top: Spacing.$1_5x,
        left: Spacing.$4x,
        right: Spacing.$4x,
        bottom: Spacing.$4x,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.suggestedSearches,
            style: context.textStyles.captionLargeRegular.copyWith(
              color: context.colors.foregroundSoft,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Spacing.$3x),
            child: Material(
              clipBehavior: Clip.antiAlias,
              borderRadius: const BorderRadius.all(
                Radius.circular(RadiusBorder.xl),
              ),
              color: contentColor,
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: Spacing.$1_5x),
                physics: const NeverScrollableScrollPhysics(),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                itemBuilder: (context, index) => SuggestItem(
                  suggest: suggests[index],
                  index: index,
                  suggestList: BssSuggestList(size: suggests.length),
                  searchRequest: BssSearchRequest(text: searchText),
                  myLocation: myLocation == null
                      ? null
                      : GeoPointMessage(
                          latitude: myLocation.latitude,
                          longitude: myLocation.longitude,
                        ),
                  isLast: index == suggests.length - 1,
                  onObjectTap: onObjectTap,
                ),
                itemCount: suggests.length,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: Spacing.$1_5x),
            child: AppButton(
              buttonColorScheme: ButtonColorScheme.accentSecondary,
              buttonType: ButtonType.secondary,
              primaryLabel: context.l10n.showResults,
              onTap: () {
                final scope = context.read<SearchScope>();
                final search = ref.read(searchProvider(scope.value).notifier);
                final searchState = ref.read(searchProvider(scope.value));
                final title = searchState.searchText;

                search.searchMore(title);

                ref
                    .read(urbiAnalyticsProvider)
                    .track(
                      '${MetricsConstants.searchTag}::${MetricsConstants.searchKeys.searchButtonPressed}',
                    );
                BssService.instance.sendEvent(
                  BssRequest(
                    eventType: BSSEventType.action,
                    actionType: BSSActionType.tap,
                    uiElement: const BssUIElement(
                      name: BssUIElementNames.searchMoreButton,
                      ownerName: BssUIElementNames.suggestList,
                    ),
                    payload: BssPayload(
                      searchRequest: BssSearchRequest(text: searchText),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
