import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/widgets/search/ui/search_history_collapsible.dart';
import 'package:mapness/widgets/search/ui/search_history_empty.dart';
import 'package:provider/provider.dart';

class SearchHistory extends ConsumerWidget {
  final Color? contentColor;
  final Color? iconColor;
  final EdgeInsetsGeometry? contentPadding;
  final void Function(SearchHistoryItem item) onTap;

  const SearchHistory({
    required this.onTap,
    this.contentColor,
    this.iconColor,
    this.contentPadding,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = context.read<SearchScope>();
    final history = ref.watch(searchHistoryProvider(scope.value));

    if (history.isEmpty) {
      return const SearchHistoryEmpty();
    }

    final search = ref.watch(searchHistoryProvider(scope.value).notifier);

    // Sort the history by createdAt. If we delete this sorting, elements will be sorted by the order of
    // insertion and in reverse order. For example, the last searched element will be the last element in the list.
    // Also if the user has the previous version of the app, the history will be sorted by the order of insertion but
    // the main priority of sorting is by [createdAt] for the new requests.
    // Current version for this sort: 4.2.2
    //
    // If you want ot delete this method please:
    // 1. Test the app with the previous and current version of the app
    // 2. Search for some places and look how the history is sorted.
    // Is it sorted by the order of insertion or by [createdAt]? Is it fit the product requirements?
    history.sort((a, b) {
      final aCreated = a.createdAt;
      final bCreated = b.createdAt;
      if (aCreated != null && bCreated != null) {
        return DateTime.parse(bCreated).compareTo(DateTime.parse(aCreated));
      } else if (aCreated == null && bCreated == null) {
        return 0;
      } else if (aCreated != null && bCreated == null) {
        return -1;
      } else if (aCreated == null && bCreated != null) {
        return 1;
      }
      return 0;
    });

    return SearchHistoryCollapsible(
      history: history,
      onClear: search.clear,
      onTap: onTap,
      onDelete: search.delete,
      contentPadding: contentPadding,
      iconColor: iconColor,
      contentColor: contentColor,
    );
  }
}
