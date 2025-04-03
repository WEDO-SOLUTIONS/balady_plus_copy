import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/search/models/search_history.dart' as models;
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/dismissible/app_dismissible.dart';

class SearchHistoryCollapsible extends ConsumerStatefulWidget {
  final List<models.SearchHistoryItem> history;
  final Function() onClear;
  final Color? contentColor;
  final Color? iconColor;
  final EdgeInsetsGeometry? contentPadding;
  final Function(models.SearchHistoryItem) onTap;
  final Function(models.SearchHistoryItem) onDelete;

  const SearchHistoryCollapsible({
    required this.onClear,
    required this.onDelete,
    required this.onTap,
    required this.history,
    this.contentColor,
    this.iconColor,
    this.contentPadding,
    super.key,
  });

  @override
  ConsumerState<SearchHistoryCollapsible> createState() => _MapSearchHistoryCollapsibleState();
}

class _MapSearchHistoryCollapsibleState extends ConsumerState<SearchHistoryCollapsible> {
  bool _collapsed = true;

  @override
  Widget build(BuildContext context) {
    final hasManyResults = widget.history.length > 10;
    final contentColor = widget.contentColor ?? context.colorsV2.backgroundSurface4;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            clipBehavior: Clip.antiAlias,
            borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.xl)),
            color: contentColor,
            child: Column(
              children: [
                ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final isLast = index == widget.history.length - 1;
                    final isLastItemAndNoManyResults = isLast && !hasManyResults;
                    final isFirst = index == 0;
                    return Padding(
                      padding: widget.contentPadding != null ? widget.contentPadding! : EdgeInsets.zero,
                      child: AppDismissible(
                        addTopBorderRadius: isFirst,
                        addBottomBorderRadius: isLastItemAndNoManyResults,
                        onDismiss: () => widget.onDelete(widget.history[index]),
                        elementKey: ValueKey(widget.history[index].hashKey),
                        child: ContentRowV2(
                            backgroundColor: contentColor,
                            onTap: () async {
                              await Future.delayed(const Duration(milliseconds: 300));
                              widget.onTap(widget.history[index]);
                            },
                            leading: AppIcons(
                              iconData: GeneralIcons.timeQuarter,
                              color: widget.iconColor ?? context.colorsV2.foregroundDefault,
                              size: 24,
                            ),
                            text: ContentRowTextOptions(
                              title: widget.history[index].title,
                              subtitle: widget.history[index].address,
                            ),
                            isDividerEnabled: !isLastItemAndNoManyResults),
                      ),
                    );
                  },
                  itemCount: _collapsed ? min(10, widget.history.length) : widget.history.length,
                ),
                if (hasManyResults)
                  ContentRowV2(
                    onTap: () => setState(() => _collapsed = !_collapsed),
                    leading: AppIcons(
                      iconData: _collapsed ? SystemIcons.arrowCornerDownLarge : SystemIcons.arrowCornerUpLarge,
                      color: widget.iconColor ?? context.colorsV2.foregroundDefault,
                      size: 24,
                    ),
                    text: ContentRowTextOptions(
                      title: _collapsed ? context.l10n.showMore : context.l10n.showLess,
                    ),
                  ),
              ],
            ),
          ),
          if (_collapsed) const SizedBox(height: 16),
          if (!_collapsed)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Spacing.$3x,
              ),
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
