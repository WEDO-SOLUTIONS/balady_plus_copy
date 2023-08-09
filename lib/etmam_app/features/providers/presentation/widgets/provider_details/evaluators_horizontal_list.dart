import 'package:balady_plus/etmam_app/features/providers/providers_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/shared/shared_feature_exports.dart'
    show CustomIndicatorWidget, CustomVerticalSpace;

class EvaluatorsHorizontalList extends StatefulWidget {
  const EvaluatorsHorizontalList({Key? key}) : super(key: key);

  @override
  State<EvaluatorsHorizontalList> createState() =>
      _EvaluatorsHorizontalListState();
}

class _EvaluatorsHorizontalListState extends State<EvaluatorsHorizontalList> {
  int currentIndex = 0;

  String name = "ahmadfaisal".tr();
  double rating = 5;
  String comment = 'elevator_comment'.tr();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 148,
          child: PageView.builder(
            padEnds: false,
            itemCount: 3,
            controller: PageController(),
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (BuildContext context, int itemIndex) {
              return EvaluatorCard(
                  evaluatorName: name,
                  rating: rating,
                  evaluatorComment: comment);
            },
          ),
        ),
        const CustomVerticalSpace(height: 12),
        // indicator
        SizedBox(
            height: 10.0,
            child: CustomIndicatorWidget(
              currentIndex: currentIndex,
              length: 3,
            ))
      ],
    );
  }
}
