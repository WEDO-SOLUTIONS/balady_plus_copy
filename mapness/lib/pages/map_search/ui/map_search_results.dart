import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/features/search/ui/search_results.dart';
import 'package:mapness/widgets/search/ui/search_item.dart';
import 'package:provider/provider.dart';

import '../../../features/search/models/search_scope.dart';

class MapSearchResults extends ConsumerWidget {
  const MapSearchResults({
    super.key,
    required this.results,
    required this.scrollController,
  });

  final SearchResultMessage results;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = context.read<SearchScope>();

    return SearchResults(
      results: results,
      scrollController: scrollController,
      loaderBuilder: (context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.black,
          ),
        ),
      ),
      itemBuilder: (context, item) => SearchItem(
        result: item,
        onTap: () {
          ref.read(searchHistoryProvider(scope.value).notifier).put(
                SearchHistoryItem.fromDirectoryObject(item),
              );
          PoiMapRoute.open(context,item.id!.objectId);
        },
      ),
    );
  }
}
