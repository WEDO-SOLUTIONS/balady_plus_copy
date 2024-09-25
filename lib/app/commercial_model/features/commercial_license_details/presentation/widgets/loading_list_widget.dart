import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import 'package:flutter/material.dart';

class LoadingListWidget extends StatelessWidget {
  const LoadingListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ItemWidget(),
        ItemWidget(),
        ItemWidget(),
        ItemWidget(),
        ItemWidget(),
      ],
    );
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          ShimmerEffectWidget(
            width: 30,
            height: 30,
            borderRadius: 6,
          ),
          SizedBox(width: 8),
          Expanded(
            child: ShimmerEffectWidget(
              height: 30,
              borderRadius: 6,
            ),
          )
        ],
      ),
    );
  }
}
