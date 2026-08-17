import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/features/favorite_lists/data/favorite_lists_api_exception.dart';
import 'package:mapness/features/favorite_lists/data/models/favorite_list_dto.dart';
import 'package:mapness/features/favorite_lists/data/models/favorite_list_place_dto.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_list_detail.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_list_place_poi.dart';
import 'package:mapness/features/favorite_lists/ui/widgets/favorite_list_places_tile.dart';
import 'package:mapness/features/favorite_lists/ui/widgets/favorite_progress_indicator.dart';
import 'package:mapness/features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/shared/extensions/brief_route_info_message_ext.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/make_address.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/find_brief_route_info.dart';
import 'package:urbi_utils/urbi_utils.dart';

class FavoriteListPlacesContent extends ConsumerWidget {
  const FavoriteListPlacesContent({required this.listId, super.key});

  final String listId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listDetailAsync = ref.watch(favoriteListDetailProvider(listId: listId));

    return Padding(
      padding: const EdgeInsets.only(top: Spacing.$2x),
      child: listDetailAsync.when(
        data: (listDetail) {
          final places = listDetail.list.places ?? [];
          if (places.isEmpty) {
            // TODO(claude): localize string
            return Text(
              'No places in this list yet',
              style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Spacing.$3x,
            children: places
                .map<Widget>(
                  (place) => FavoriteListPlaceTile(list: listDetail.list, place: place),
                )
                .insertBetween(
                  Divider(
                    color: context.colors.borderSoft,
                    height: 0.5,
                    thickness: 0.5,
                    indent: Spacing.$6x.toDouble(),
                  ),
                )
                .toList(),
          );
        },
        loading: () => const FavoriteProgressIndicator(),
        error: (error, stackTrace) => Text(
          error is FavoriteListsApiException
              ? error.localizedMessage(ref.read(appLanguageProvider))
              : context.l10n.somethingWentWrongPleaseTryAgainLater,
          style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
        ),
      ),
    );
  }
}
