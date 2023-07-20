import 'package:flutter/material.dart';

import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../map_page/presentation/mvvm/map_view_model.dart';
import '../../../home_exports.dart'
    show
        GameChallenge,
        ImportantServices,
        NewServices,
        PrayerTimesCard,
        ShareWithUs;

import 'package:provider/provider.dart';

class HomeBottomSheet extends StatelessWidget {
  const HomeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    MapViewModel mapViewModel = context.watch<MapViewModel?>()!;
    return ValueListenableBuilder<bool>(
      valueListenable: mapViewModel.viewHomeBottomSheet,
      builder: (_, visible, child) {
        return visible ? child! : const SizedBox();
      },
      child: DraggableSheetCard(
        minSize: 0.5,
        maxSize: 0.9,
        cornerRadius: 36,
        children: [
          ImportantServices(),
          ShareWithUs(),
          NewServices(),
          GameChallenge(),
          Container(),
        ],
      ),
    );
  }
}
