import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import 'package:flutter/material.dart';

class DashboardListShimmer extends StatelessWidget {
  const DashboardListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          height: 200,
          margin: const EdgeInsets.only(top: 16),
          color: Theme.of(context).cardColor,
          child: const ShimmerEffectWidget(),
        );
      },
    );
  }
}
