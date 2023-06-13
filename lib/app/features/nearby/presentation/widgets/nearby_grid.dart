import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show NearByTypes;
import '../../nearby_exports.dart' show NearbyItem;

class NearbyGrid extends StatelessWidget {
  const NearbyGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final nearbyItem = [
      {
        'title': 'حياة بارك',
        'subtitle': 'منتجعات جده، خمس نجوم',
        'type': 'hotel',
      },
      {
        'title': 'مسجد قباء',
        'subtitle': 'مسجد قباء، المدينة المنورة',
        'type': 'mosque',
      },
      {
        'title': 'كوستا',
        'subtitle': 'مطعم كوستا، جده',
        'type': 'coffee',
      },
      {
        'title': 'بافلو برجر',
        'subtitle': 'مطعم بافلو برجر، جده',
        'type': 'restaurant',
      },
    ];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: nearbyItem.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.1,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemBuilder: (context, index) {
          return NearbyItem(
            title: nearbyItem[index]['title'] as String,
            subtitle: nearbyItem[index]['subtitle'] as String,
            type: NearByTypes.values.firstWhere(
              (element) => element.title == nearbyItem[index]['type'],
            ),
          );
        },
      ),
    );
  }
}
