import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/analytic/bss_service.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:mapness/shared/providers/analytic/models/extensions/search_type_ext.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';
import 'package:mapness/shared/ui/dismissible/app_dismissible.dart';

class SearchHistoryCollapsible extends ConsumerStatefulWidget {
  final List<SearchHistoryDirectoryObjectMessage> history;
  final Function() onClear;
  final Color? contentColor;
  final Color? iconColor;
  final EdgeInsetsGeometry? contentPadding;
  final Function(SearchHistoryDirectoryObjectMessage, int, BssHistoryList?) onTap;
  final Function(SearchHistoryDirectoryObjectMessage, int) onDelete;

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

  Future<void> _showRemoveHistoryConfirmation(BuildContext context) async {
    final confirmed = await context.router.push<bool>(const RemoveHistoryConfirmationRoute());
    if (confirmed == true) {
      widget.onClear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDGA =
        context.read<ThemeController>().currentTheme == BaladyAppThemes.darkDGA ||
            context.read<ThemeController>().currentTheme == BaladyAppThemes.lightDGA;

    final backgroundColor = isDGA ? context.colors.accentSecondarySoft : context.colors.backgroundSurface1;

    final hasManyResults = widget.history.length > 10;
    final contentColor = widget.contentColor ?? backgroundColor;
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
                        onDismiss: () => widget.onDelete(widget.history[index], index),
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
                          isDividerEnabled: !isLastItemAndNoManyResults,
                        ),
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
                            position: _collapsed
                                ? 11
                                : widget.history.length + 1, // Because we have 10 items in the list
                          ),
                          payload: BssPayload(historyList: BssHistoryList(size: widget.history.length)),
                        ),
                      );
                      setState(() => _collapsed = !_collapsed);
                    },
                    options: ContentRowOptions(
                      title: _collapsed ? context.l10n.showMore : context.l10n.showLess,
                      titleStyle: context.textStyles.bodySmallMedium.copyWith(color: context.colors.accentDefault),
                    ),
                    leading: AppIcons(iconData: SystemIcons.ellipsis, color: context.colors.accentDefault, size: 24),
                    trailing: ContentRowCustomTrailingOptions(
                      builder: (_) => Padding(
                        padding: const EdgeInsetsGeometry.directional(end: Spacing.$4x),
                        child: AppIcons(
                          iconData: _collapsed ? SystemIcons.arrowCornerDownSmall : SystemIcons.arrowCornerUpSmall,
                          color: context.colors.foregroundMuted,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (_collapsed) const SizedBox(height: Spacing.$4x),
          if (!_collapsed)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Spacing.$3x),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      buttonColorScheme: ButtonColorScheme.accentSecondary,
                      buttonType: ButtonType.secondary,
                      onTap: () => _showRemoveHistoryConfirmation(context),
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
