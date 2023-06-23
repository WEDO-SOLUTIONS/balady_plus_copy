import 'package:flutter/material.dart';

import '../../../../_shared_feature_/shared_feature_exports.dart'
    show ShimmerEffectWidget;

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
          child: const ShimmerEffectWidget(),
        );
      },
    );
  }
}
