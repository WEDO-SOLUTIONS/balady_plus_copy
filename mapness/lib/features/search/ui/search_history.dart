import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/widgets/search/ui/search_history.dart' as widgets;
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

    return widgets.SearchHistory(
      history: history,
      onClear: () {
        ref.read(searchHistoryProvider(scope.value).notifier).clear();
      },
      onDelete: (item) {
        ref.read(searchHistoryProvider(scope.value).notifier).delete(item);
      },
      onTap: onTap,
    );
  }
}
