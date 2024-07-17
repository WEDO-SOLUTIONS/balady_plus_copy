import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/search/models/search_history.dart' as models;
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/search/ui/search_tap_handler.dart';

class SearchHistoryCollapsible extends ConsumerStatefulWidget {
  const SearchHistoryCollapsible({
    required this.onClear,
    required this.onDelete,
    required this.onTap,
    required this.history,
    super.key,
  });

  final List<models.SearchHistoryItem> history;
  final Function() onClear;
  final Function(models.SearchHistoryItem) onTap;
  final Function(models.SearchHistoryItem) onDelete;

  @override
  ConsumerState<SearchHistoryCollapsible> createState() => _MapSearchHistoryCollapsibleState();
}

class _MapSearchHistoryCollapsibleState extends ConsumerState<SearchHistoryCollapsible> {
  bool _collapsed = true;

  @override
  Widget build(BuildContext context) {
    final hasManyResults = widget.history.length > 10;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final isLastItem = index == widget.history.length - 1;

              return Dismissible(
                key: ValueKey(widget.history[index].hashKey),
                onDismissed: (direction) {
                  widget.onDelete(widget.history[index]);
                },
                background: Container(
                  padding: const EdgeInsets.all(Spacing.$4x),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: NonThemeColor.color50,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.filled(
                      2,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          context.l10n.delete,
                          style: context.textStyle.footNote.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                child: Material(
                  color: context.color.surfaceBaseSecondary,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(index == 0 ? RadiusBorder.xl : 0),
                    bottom: Radius.circular(isLastItem && !hasManyResults ? RadiusBorder.xl : 0),
                  ),
                  child: SearchTapHandler(
                    onTap: () => widget.onTap(widget.history[index]),
                    child: ContentRow(
                      options: ContentRowOptions(
                        leadingIcon: AppIcons(
                          iconData: GeneralIcons.timeQuarter,
                          color: context.color.textAndIconsBaseSecondary,
                          size: 24,
                        ),
                        title: widget.history[index].title,
                        subtitle: widget.history[index].address,
                        dividerEnabled: !isLastItem || hasManyResults,
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: _collapsed ? min(10, widget.history.length) : widget.history.length,
          ),
          if (hasManyResults) ...[
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 56),
                child: Divider(
                  thickness: 1,
                  height: 2,
                  color: context.color.surfaceBasePrimary,
                ),
              ),
            ),
            Material(
              color: context.color.surfaceBaseSecondary,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(RadiusBorder.xl),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: ContentRow(
                  onTap: () => setState(() => _collapsed = !_collapsed),
                  options: ContentRowOptions(
                    leadingIcon: AppIcons(
                      iconData: _collapsed ? SystemIcons.arrowCornerDownLarge : SystemIcons.arrowCornerUpLarge,
                      color: context.color.textAndIconsBaseSecondary,
                      size: 24,
                    ),
                    title: _collapsed ? context.l10n.showMore : context.l10n.showLess,
                  ),
                ),
              ),
            ),
          ],
          if (!_collapsed)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Spacing.verticalPaddingInsideCell),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      buttonColorScheme: ButtonColorScheme.tertiary,
                      onTap: widget.onClear,
                      primaryLabel: context.l10n.deleteHistory,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
