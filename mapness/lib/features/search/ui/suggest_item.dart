import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/widgets/search/ui/suggest_item.dart' as widgets;
import 'package:provider/provider.dart';

class SuggestItem extends ConsumerWidget {
  const SuggestItem({
    super.key,
    required this.suggest,
    required this.onObjectTap,
  });

  final SuggestMessage suggest;
  final Function(DirectoryObjectMessage) onObjectTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = context.read<SearchScope>();

    return widgets.SuggestItem(
      suggest: suggest,
      onTap: () {
        if (suggest.handler.incompleteTextHandler != null) {
          ref.read(searchQueryProvider(scope.value).notifier).update(
                suggest.handler.incompleteTextHandler!.queryText,
              );
        } else if (suggest.handler.performSearchHandler != null) {
          ref
              .read(searchProvider(scope.value).notifier)
              .searchByQuery(suggest.handler.performSearchHandler!.searchQuery);
        } else {
          final objectItem = suggest.handler.objectHandler!.item;
          ref.read(searchHistoryProvider(scope.value).notifier).put(
                SearchHistoryItem.fromDirectoryObject(objectItem),
              );
          onObjectTap(objectItem);
        }
      },
    );
  }
}
