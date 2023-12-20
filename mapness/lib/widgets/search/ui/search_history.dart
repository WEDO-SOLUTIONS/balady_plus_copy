import 'package:flutter/material.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/widgets/search/ui/search_history_collapsible.dart';
import 'package:mapness/widgets/search/ui/search_history_empty.dart';

class SearchHistory extends StatelessWidget {
  const SearchHistory({
    super.key,
    required this.history,
    required this.onClear,
    required this.onTap,
  });

  final List<SearchHistoryItem> history;
  final Function() onClear;
  final Function(SearchHistoryItem item) onTap;

  @override
  Widget build(BuildContext context) {
    return history.isEmpty
        ? const SearchHistoryEmpty()
        : SearchHistoryCollapsible(
            history: history,
            onClear: onClear,
            onTap: onTap,
          );
  }
}
