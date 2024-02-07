import 'package:flutter/material.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/widgets/search/ui/search_history_collapsible.dart';
import 'package:mapness/widgets/search/ui/search_history_empty.dart';

class SearchHistory extends StatelessWidget {
  const SearchHistory({
    required this.history,
    required this.onClear,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  final List<SearchHistoryItem> history;
  final Function() onClear;
  final Function(SearchHistoryItem item) onTap;
  final Function(SearchHistoryItem item) onDelete;

  @override
  Widget build(BuildContext context) => history.isEmpty
      ? const SearchHistoryEmpty()
      : SearchHistoryCollapsible(
          history: history,
          onClear: onClear,
          onTap: onTap,
          onDelete: onDelete,
        );
}
