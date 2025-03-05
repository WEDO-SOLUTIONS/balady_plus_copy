import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/features/search/ui/search_history.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class SearchScreen extends HookWidget {
  final VoidCallback onClose;
  final int itemCount;
  final String? hintText;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final void Function(SearchHistoryItem? item)? onHistoryItemTap;
  final void Function(String)? onChanged;
  final VoidCallback? onTapOfSearch;

  const SearchScreen({
    required this.itemBuilder,
    required this.itemCount,
    required this.onClose,
    this.onChanged,
    this.hintText,
    super.key,
    this.onHistoryItemTap,
    this.onTapOfSearch,
  });

  @override
  Widget build(BuildContext context) {
    final contentColor = context.colorsV2.backgroundSurface4;
    final focusNode = useFocusNode();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                    child: BaladySearchWithBackButtonV2(
                      option: SearchTextBackOption(
                        text: context.l10n.cancel,
                        onPressed: onClose,
                      ),
                      searchInput: BaladyTextInput.search(
                        config: BaladyInputConfig(
                          onTap: onTapOfSearch,
                          focusNode: focusNode,
                          autofocus: true,
                          hintText: hintText ?? context.l10n.search,
                          onChanged: onChanged,
                          fillColor: context.colorsV2.neutralContainerDefault,
                          hintColor: context.colorsV2.foregroundSoft,
                          textStyle: context.textStyleV3.bodySmallRegular,
                        ),
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
