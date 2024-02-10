import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_history.dart';
import 'package:provider/provider.dart';

class MapSearchHistory extends ConsumerWidget {
  const MapSearchHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = context.read<SearchScope>();

    return SearchHistory(
      onTap: (item) {
        if (item.objectId != null) {
          PoiMapRoute.open(context, int.parse(item.objectId!));
        } else {
          ref
              .read(searchQueryProvider(scope.value).notifier)
              .update(item.title);
          ref
              .read(searchProvider(scope.value).notifier)
              .searchByText(item.title);
        }
      },
    );
  }
}
