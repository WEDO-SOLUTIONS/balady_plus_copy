import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class RouteEditor extends StatelessWidget {
  const RouteEditor({
    required this.points,
    required this.onReorder,
    required this.onTap,
    super.key,
  });

  final List<RoutePoint> points;
  final ReorderCallback onReorder;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: NonThemeColor.color51,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              buildDefaultDragHandles: false,
              onReorder: onReorder,
              itemBuilder: (context, index) => Directionality(
                key: ValueKey(points[index].title),
                textDirection: TextDirection.rtl,
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onTap(index),
                    borderRadius: BorderRadius.circular(12),
                    child: DestinationRow(
                      color: points[index].titleColor(context),
                      value: points[index].title(context.l10n) ?? (index == 0 ? context.l10n.from : context.l10n.to),
                      icon: points[index].icon,
                      index: index,
                    ),
                  ),
                ),
              ),
              itemCount: points.length,
            ),
            const Padding(
              padding: EdgeInsets.only(right: 52),
              child: Divider(
                height: 1,
                color: NonThemeColor.color53,
              ),
            ),
          ],
        ),
      );
}

class DestinationRow extends StatelessWidget {
  const DestinationRow({
    required this.color,
    required this.value,
    required this.icon,
    required this.index,
    super.key,
  });

  final Color color;
  final String value;
  final String icon;
  final int index;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset(
                icon,
                color: context.colors.accentDefault,
                // colorFilter: ColorFilter.mode(
                // index == 0 ? NonThemeColor.color3 : context.colors.accentOnContainer,
                // BlendMode.srcATop,
                // ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                value,
                style: context.textStyle.text.copyWith(color: color),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            ReorderableDragStartListener(
              index: index,
              child: SizedBox(
                width: 24,
                height: 24,
                child: SvgPicture.asset(
                  Assets.icons.svg.icDragIndicator.keyName,
                ),
              ),
            ),
          ],
        ),
      );
}
