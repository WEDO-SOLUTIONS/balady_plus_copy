import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';
import 'package:mapness/widgets/search/ui/search_history_collapsible.dart';
import 'package:mapness/widgets/search/ui/search_history_empty.dart';
import 'package:provider/provider.dart';

class SearchHistory extends ConsumerWidget {
  final Color? contentColor;
  final Color? iconColor;
  final EdgeInsetsGeometry? contentPadding;
  final void Function(SearchHistoryDirectoryObjectMessage item, int index, BssHistoryList? historyList) onTap;

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

    return SearchHistoryCollapsible(
      history: history,
      onClear: search.clear,
      onTap: onTap,
      onDelete: (_, index) => search.delete(index),
      contentPadding: contentPadding,
      iconColor: iconColor,
      contentColor: contentColor,
    );
  }
}
