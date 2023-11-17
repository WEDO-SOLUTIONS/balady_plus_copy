import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/entities/search/models/search_history.dart' as models;
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/widgets/search/ui/search_history_item.dart';

class MapSearchHistoryCollapsible extends ConsumerStatefulWidget {
  const MapSearchHistoryCollapsible({
    super.key,
    required this.history,
  });

  final List<models.SearchHistoryItem> history;

  @override
  ConsumerState<MapSearchHistoryCollapsible> createState() =>
      _MapSearchHistoryCollapsibleState();
}

class _MapSearchHistoryCollapsibleState
    extends ConsumerState<MapSearchHistoryCollapsible> {
  bool _collapsed = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => Material(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: index == 0
                    ? const Radius.circular(8)
                    : const Radius.circular(0),
                topRight: index == 0
                    ? const Radius.circular(8)
                    : const Radius.circular(0),
                bottomLeft: index == widget.history.length - 1 &&
                        widget.history.length <= 10
                    ? const Radius.circular(8)
                    : const Radius.circular(0),
                bottomRight: index == widget.history.length - 1 &&
                        widget.history.length <= 10
                    ? const Radius.circular(8)
                    : const Radius.circular(0),
              ),
              child: InkWell(
                onTap: () {
                  PoiMapRoute(dgisObjectId: widget.history[index].objectId!)
                      .push(context);
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
            itemCount: _collapsed
                ? min(10, widget.history.length)
                : widget.history.length,
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                color: Colors.white,
                child: const Padding(
                  padding: EdgeInsets.only(right: 56),
                  child: Divider(
                    thickness: 1,
                    height: 2,
                    color: Color(0x17022224),
                  ),
                ),
              );
            },
          ),
          if (widget.history.length > 10) ...[
            Container(
              color: Colors.white,
              child: const Padding(
                padding: EdgeInsets.only(right: 56),
                child: Divider(
                  thickness: 1,
                  height: 2,
                  color: Color(0x17022224),
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
                    _collapsed ? "Show more" : "Show less",
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
              color: const Color(0xFF42909B),
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () {
                  ref.read(searchHistoryProvider.notifier).clear();
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      "Delete history",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}

class _ShowMore extends StatelessWidget {
  const _ShowMore(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          SvgPicture.asset(
            "assets/icons/svg/ic_show_more.svg",
            package: PackageConfig.packageName,
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 16,
              height: 1.4,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1E2A36),
            ),
          ),
        ],
      ),
    );
  }
}
