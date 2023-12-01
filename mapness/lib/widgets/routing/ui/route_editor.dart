import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/shared/config/package_config.dart';


class RouteEditor extends StatelessWidget {
  const RouteEditor({
    super.key,
    required this.points,
    required this.onReorder,
    required this.onTap,
  });

  final List<RoutePoint> points;
  final ReorderCallback onReorder;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x1A1E2A36),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: onReorder,
            itemBuilder: (BuildContext context, int index) {
              return Directionality(
                key: ValueKey(points[index].title),
                textDirection: TextDirection.rtl,
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onTap(index),
                    borderRadius: BorderRadius.circular(12),
                    child: DestinationRow(
                      color: points[index].titleColor,
                      value:
                          points[index].title ?? (index == 0 ? "From" : "To"),
                      icon: points[index].icon,
                      index: index,
                    ),
                  ),
                ),
              );
            },
            itemCount: points.length,
          ),
          const Padding(
            padding: EdgeInsets.only(right: 52),
            child: Divider(
              height: 1,
              color: Color(0x261E2A36),
            ),
          )
        ],
      ),
    );
  }
}

class DestinationRow extends StatelessWidget {
  const DestinationRow({
    super.key,
    required this.color,
    required this.value,
    required this.icon,
    required this.index,
  });

  final Color color;
  final String value;
  final String icon;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              package: PackageConfig.packageName,
              colorFilter: ColorFilter.mode(
                index == 0 ? const Color(0xFF52B374) : const Color(0xFF4CA5B4),
                BlendMode.srcATop,
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).extension<ThemeTextStyles>()!.textM.copyWith(color: color),
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
                "assets/icons/svg/ic_drag_indicator.svg",
                package: PackageConfig.packageName,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
