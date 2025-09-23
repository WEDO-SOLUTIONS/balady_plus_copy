import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/search/models/search_history.dart' as models;
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/analytic/bss_service.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';
import 'package:mapness/shared/ui/dismissible/app_dismissible.dart';

class SearchHistoryCollapsible extends ConsumerStatefulWidget {
  final List<models.SearchHistoryItem> history;
  final Function() onClear;
  final Color? contentColor;
  final Color? iconColor;
  final EdgeInsetsGeometry? contentPadding;
  final Function(models.SearchHistoryItem, int, BssHistoryList?) onTap;
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
    final contentColor = widget.contentColor ?? context.colors.backgroundSurface1;
    final bssHistoryList = BssHistoryList(size: widget.history.length);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x).copyWith(top: Spacing.$3x),
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
                        child: ContentRow(
                            backgroundColor: contentColor,
                            onTap: () async {
                              await Future.delayed(const Duration(milliseconds: 300));
                              widget.onTap(widget.history[index], index, bssHistoryList);
                            },
                            leading: AppIcons(
                              iconData: GeneralIcons.timeQuarter,
                              color: widget.iconColor ?? context.colors.foregroundSoft,
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
                  ContentRow(
                    onTap: () {
                      BssService.instance.sendEvent(
                            BssRequest(
                              eventType: BSSEventType.action,
                              actionType: BSSActionType.tap,
                              uiElement: BssUIElement(
                                name: _collapsed
                                    ? BssUIElementNames.expandHistoryList
                                    : BssUIElementNames.rollupHistoryList,
                                ownerName: BssUIElementNames.directorySearchScreen,
                                position:
                                    _collapsed ? 11 : widget.history.length + 1, // Because we have 10 items in the list
                              ),
                              payload: BssPayload(
                                historyList: BssHistoryList(size: widget.history.length),
                              ),
                            ),
                          );
                      setState(() => _collapsed = !_collapsed);
                    },
                    leading: AppIcons(
                      iconData: _collapsed ? SystemIcons.arrowCornerDownLarge : SystemIcons.arrowCornerUpLarge,
                      color: widget.iconColor ?? context.colors.foregroundDefault,
                      size: 24,
                    ),
                    text: ContentRowTextOptions(
                      title: _collapsed ? context.l10n.showMore : context.l10n.showLess,
                    ),
                  ),
              ],
            ),
          ),
          if (_collapsed) const SizedBox(height: Spacing.$4x),
          if (!_collapsed)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Spacing.$3x,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      buttonColorScheme: ButtonColorScheme.neutral,
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
