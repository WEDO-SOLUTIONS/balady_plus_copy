import 'package:flutter/material.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../home_exports.dart'
    show
        BaladySmartAdvisorCard,
        ChallengeHomeCard,
        DraggableHeaderComponent,
        NewServices,
        PrayerHomeCard,
        ReadHomeCard,
        ReportHomeCard;

class HomeBottomSheet extends StatelessWidget {
  const HomeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return const DraggableSheetCard(
      minSize: 0.6,
      maxSize: 0.9,
      cornerRadius: 36,
      children: [
        DraggableHeaderComponent(),
        ReportHomeCard(),
        BaladySmartAdvisorCard(),
        PrayerHomeCard(),
        ReadHomeCard(),
        ChallengeHomeCard(),
        NewServices(),
        SizedBox(height: 30),
      ],
    );
  }
}
