import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/routing_page/widgets/working_hours.dart';
import 'package:flutter/material.dart';

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
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      height: 1.33,
                    ),
                  ),
                  const SizedBox(height: 4),
                  CustomTextWidget(
                    item.streetAddress!,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                    textStyle: AppStyle.mainTextSecondaryStyle,
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
