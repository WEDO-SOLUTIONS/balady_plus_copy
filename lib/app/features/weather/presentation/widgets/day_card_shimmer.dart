import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_shimmer_list_widget.dart';
import 'package:flutter/material.dart';

class DayCardShimmer extends StatelessWidget {
  const DayCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomShimmerWidget(
      childWidth: double.infinity,
      childWidget: Card(
        color: Colors.grey,
      ),
      childHeight: 67,
    );
  }
}
