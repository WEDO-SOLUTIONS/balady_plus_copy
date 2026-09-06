import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/suggest.dart';
import 'package:mapness/widgets/favourites/screen/favourites_search_screen.dart';

@RoutePage()
class FavouritesSearchPage extends StatelessWidget {
  final FavouriteItemMarkerType markerType;

  const FavouritesSearchPage({required this.markerType, super.key});

  @override
  Widget build(BuildContext context) => SearchScope(
    named: SearchScopeEnum.favourites,
    child: Material(
      color: context.colors.screenOverlayDimming40,
      child: FavouritesSearch(markerType: _getMarkerType()),
    ),
  );

  FavouriteItemMarkerType _getMarkerType() {
    try {
      return FavouriteItemMarkerType.values.byName(markerType.name);
    } catch (_) {
      return FavouriteItemMarkerType.place;
    }
  }
}

class FavouritesSearch extends ConsumerWidget {
  const FavouritesSearch({required this.markerType, super.key});

  final FavouriteItemMarkerType markerType;

  @override
  Widget build(BuildContext context, WidgetRef ref) => FavouritesSearchScreen(
    markerType: markerType,
    hintText: switch (markerType) {
      FavouriteItemMarkerType.unknown || FavouriteItemMarkerType.place => '',
      FavouriteItemMarkerType.home => context.l10n.home_address,
      FavouriteItemMarkerType.work => context.l10n.work_address,
    },
    onTapOfSearch: () {
      ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.journeySearch);
    },
    onClose: () {
      FocusScope.of(context).unfocus();
      context.router.pop();
    },
    onChanged: (value) {
      if (value.isEmpty) {
        ref.read(suggestQueryProvider.notifier).update('');
      } else {
        ref.read(suggestQueryProvider.notifier).update(value);
      }
    },
  );
}
