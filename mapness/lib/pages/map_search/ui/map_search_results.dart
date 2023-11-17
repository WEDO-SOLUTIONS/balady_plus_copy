import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/features/search/ui/search_results.dart';
import 'package:mapness/widgets/search/ui/search_item.dart';

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
          PoiMapRoute(dgisObjectId: item.id!.objectId).push(context);
        },
      ),
    );
  }
}
