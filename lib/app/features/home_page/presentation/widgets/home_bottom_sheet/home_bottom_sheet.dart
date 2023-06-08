import 'package:flutter/material.dart';

import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../home_exports.dart'
    show
        GameChallenge,
        ImportantServices,
        NewServices,
        PrayerTimes,
        ShareWithUs;

class HomeBottomSheet extends StatelessWidget {
  const HomeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return const DraggableSheetCard(
      minSize: 0.5,
      maxSize: 0.9,
      cornerRadius: 36,
      children: [
        ImportantServices(),
        ShareWithUs(),
        NewServices(),
        GameChallenge(),
        PrayerTimes(),
      ],
    );
  }
}
