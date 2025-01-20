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
    required this.onClose,
    this.hintText,
    super.key,
    this.onHistoryItemTap,
  });

  final VoidCallback onClose;
  final int itemCount;
  final String? hintText;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final void Function(SearchHistoryItem? item)? onHistoryItemTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentColor = context.colorsV2.backgroundSurface4;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.colorsV2.backgroundSurface1,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: SearchHeaderDelegate(
                child: Container(
                  color: context.color.surfaceBasePrimary,
                  padding: const EdgeInsets.all(Spacing.$4x).copyWith(top: 12),
                  child: BaladySearchWithBackButton(
                    option: SearchTextBackOption(
                      text: context.l10n.cancel,
                      onPressed: onClose,
                    ),
                    searchInput: BaladyInput.searchV2(
                      autofocus: true,
                      hintText: hintText ?? context.l10n.search,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          ref.read(suggestQueryProvider.notifier).update('');
                        } else {
                          ref.read(suggestQueryProvider.notifier).update(value);
                        }
                      },
                      fillColor: context.colorsV2.neutralContainerDefault,
                      hintColor: context.colorsV2.foregroundSoft,
                      textStyle: context.textStyleV3.bodySmallRegular,
                    ),
                  ),
                ),
              ),
            ),
            if (itemCount == 0)
              SliverToBoxAdapter(
                child: SearchHistory(
                  onTap: (item) {
                    onHistoryItemTap?.call(item);
                  },
                ),
              ),
            if (itemCount > 0)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: Spacing.$4x,
                    right: Spacing.$4x,
                    bottom: Spacing.$4x,
                  ),
                  child: Material(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(RadiusBorder.xl),
                    color: contentColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: Spacing.$1x),
                      child: ListView.builder(
                        controller: ScrollController(),
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: itemCount,
                        itemBuilder: itemBuilder,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  const SearchHeaderDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) =>
      child;

  @override
  double get maxExtent => 72;

  @override
  double get minExtent => 72;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
