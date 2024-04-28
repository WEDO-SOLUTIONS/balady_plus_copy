import 'dart:math';

import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/entities/search/models/search_history.dart' as models;
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/search/ui/search_history_item.dart';

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
  ConsumerState<SearchHistoryCollapsible> createState() =>
      _MapSearchHistoryCollapsibleState();
}

class _MapSearchHistoryCollapsibleState
    extends ConsumerState<SearchHistoryCollapsible> {
  bool _collapsed = true;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Dismissible(
                key: ValueKey(widget.history[index].hashKey),
                onDismissed: (direction) {
                  widget.onDelete(widget.history[index]);
                },
                background: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: NonThemeColor.color50,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.filled(
                      2,
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                        ),
                        child: Text(
                          context.l10n.delete,
                          style: Theme.of(context)
                              .extension<ThemeTextStyles>()!
                              .footNote
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: index == 0
                        ? const Radius.circular(8)
                        : const Radius.circular(0),
                    bottom: index == widget.history.length - 1 &&
                            widget.history.length <= 10
                        ? const Radius.circular(8)
                        : const Radius.circular(0),
                  ),
                  child: InkWell(
                    onTap: () {
                      widget.onTap(widget.history[index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: SearchHistoryItem(
                        result: widget.history[index],
                      ),
                    ),
                  ),
                ),
              ),
              itemCount: _collapsed
                  ? min(10, widget.history.length)
                  : widget.history.length,
              separatorBuilder: (context, index) => Container(
                color: Colors.white,
                child:  Padding(
                  padding: const EdgeInsetsDirectional.only(start: 56),
                  child: Divider(
                    thickness: 1,
                    height: 2,
                    color: context.color.surfaceBasePrimary,
                  ),
                ),
              ),
            ),
            if (widget.history.length > 10) ...[
              Container(
                color: Colors.white,
                child:  Padding(
                  padding: const EdgeInsetsDirectional.only(start: 56),
                  child: Divider(
                    thickness: 1,
                    height: 2,
                    color: context.color.surfaceBasePrimary,
                  ),
                ),
              ),
              Material(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _collapsed = !_collapsed;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: _ShowMore(
                      _collapsed
                          ? context.l10n.showMore
                          : context.l10n.showLess,
                    ),
                  ),
                ),
              ),
            ],
            if (!_collapsed) ...[
              const SizedBox(
                height: 16,
              ),
              Material(
                color: NonThemeColor.color32,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: widget.onClear,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        context.l10n.deleteHistory,
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()!
                            .text
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
}

class _ShowMore extends StatelessWidget {
  const _ShowMore(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/svg/ic_show_more.svg',
              package: PackageConfig.packageName,
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .text
                  .copyWith(color: context.color.textAndIconsBasePrimary),
            ),
          ],
        ),
      );
}
