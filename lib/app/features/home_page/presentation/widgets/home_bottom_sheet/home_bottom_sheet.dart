import 'package:flutter/material.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../map_page/presentation/mvvm/map_view_model.dart';
import '../../../home_exports.dart'
    show BaladySmartAdvisorCard, CertificationMapCard, ChallengeHomeCard, DeformityHomeCard, DraggableHeaderComponent, NewServices, PrayerHomeCard, ReadHomeCard, ReportHomeCard;

import 'package:provider/provider.dart';

class HomeBottomSheet extends StatelessWidget {
  const HomeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    MapViewModel mapViewModel = context.watch<MapViewModel?>()!;
    print("initial ${mapViewModel.bottomSheetSizeFraction.value}");
    return ValueListenableBuilder<bool>(
        valueListenable: mapViewModel.viewHomeBottomSheet,
        builder: (_, visible, child) {
          print("initial ${mapViewModel.bottomSheetSizeFraction.value}");
          return visible ? child! : const SizedBox();
        },
        child: DraggableSheetCard(
          minSize: 0.05,
          maxSize: 0.9,
          cornerRadius: 36,
          initialChildSize: mapViewModel.bottomSheetSizeFraction.value,
          children: [
            DraggableHeaderComponent(),
            ReportHomeCard(),
            CertificationMapCard(),
            DeformityHomeCard(),
            PrayerHomeCard(),
            ReadHomeCard(),
            BaladySmartAdvisorCard(),
            //  ChallengeHomeCard(),
            NewServices(),
            SizedBox(height: 30),
          ],
        ));
  }
}
