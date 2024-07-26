import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/features/search/ui/search_history.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/suggest.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({
    required this.itemBuilder,
    required this.itemCount,
    required this.onBackTap,
    this.hintText,
    super.key,
    this.onHistoryItemTap,
  });

  final VoidCallback onBackTap;
  final int itemCount;
  final String? hintText;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final void Function(SearchHistoryItem? item)? onHistoryItemTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: context.color.surfaceBasePrimary,
        body: Column(
          children: [
            Container(
              color: context.color.surfaceBasePrimary,
              padding: const EdgeInsets.all(Spacing.$4x).copyWith(top: MediaQuery.of(context).padding.top + 12),
              child: BaladySearchWithBackButton(
                onBackButtonPressed: onBackTap,
                searchInput: BaladyInput(
                  higlighFocusedBorder: false,
                  autofocus: true,
                  hintText: hintText ?? context.l10n.search,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      ref.read(suggestQueryProvider.notifier).update('');
                    } else {
                      ref.read(suggestQueryProvider.notifier).update(value);
                    }
                  },
                ),
              ),
            ),
            if (itemCount == 0)
              SearchHistory(
                onTap: (item) {
                  onHistoryItemTap?.call(item);
                },
              ),
            if (itemCount > 0)
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  itemCount: itemCount,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: itemBuilder,
              ),
            ),
          ],
        ),
      );
}
