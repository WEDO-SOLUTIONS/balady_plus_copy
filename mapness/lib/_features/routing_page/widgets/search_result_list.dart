import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/_features/routing_page/widgets/working_hours.dart';

import '../../navigation_dashboard/widgets/mapness_typography.dart';
import '../data/object_info.dart';

class SearchResultList extends StatelessWidget {
  const SearchResultList({
    required this.items,
    required this.onItemTap,
    super.key,
  });

  final List<ObjectInfo> items;
  final Function(int) onItemTap;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, index) {
          final item = items[index];
          return InkWell(
            onTap: () => onItemTap(index),
            child: Padding(
              padding: EdgeInsets.only(
                top: index == 0 ? 8 : 0,
                left: 18.0,
                right: 18.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      height: 1.33,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.streetAddress!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: MapnessTypography.s,
                  ),
                  if (!item.isOpen24x7 &&
                      item.hoursFrom != null &&
                      item.hoursTo != null) ...[
                    const SizedBox(height: 4),
                    WorkingHours(
                      hoursFrom: item.hoursFrom!,
                      hoursTo: item.hoursTo!,
                      isOpen24x7: item.isOpen24x7,
                      showIcon: false,
                      compact: true,
                    ),
                  ],
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(height: 1, color: Colors.black12),
                  ),
                ],
              ),
            ),
          );
        },
        childCount: items.length,
      ),
    );
  }
}
