import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/widgets/search/ui/search_history_collapsible.dart';
import 'package:mapness/widgets/search/ui/search_history_empty.dart';
import 'package:provider/provider.dart';

class SearchHistory extends ConsumerWidget {
  const SearchHistory({
    required this.onTap,
    super.key,
  });

  final Function(SearchHistoryItem item) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = context.read<SearchScope>();
    final history = ref.watch(searchHistoryProvider(scope.value));

    final search = ref.watch(searchHistoryProvider(scope.value).notifier);

    return history.isEmpty
        ? const SearchHistoryEmpty()
        : SearchHistoryCollapsible(
            history: history,
            onClear: search.clear,
            onTap: onTap,
            onDelete: search.delete,
          );
  }
}
