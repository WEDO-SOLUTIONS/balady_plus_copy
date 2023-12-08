import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomHorizontalSpace,
        CustomSvgIconWidget,
        CustomTextWidget,
        RatingEvaluationWidget;
import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, IconPath;

class EvaluatorCard extends StatelessWidget {
  final String evaluatorName;
  final double rating;
  final String evaluatorComment;

  const EvaluatorCard(
      {Key? key,
      required this.evaluatorName,
      required this.rating,
      required this.evaluatorComment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 148,
      margin: EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: AppColor.lightGrey,
      ),
      child: Column(
        children: [
          EvaluatorCardHeader(
            evaluatorName: evaluatorName,
            rating: rating,
          ),
          Expanded(
            child: CustomTextWidget(
              evaluatorComment,
              maxLines: 1,
              textAlign: TextAlign.start,
              fontSize: 14,
              textOverflow: TextOverflow.ellipsis,
              fontWeight: AppFontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class EvaluatorCardHeader extends StatelessWidget {
  final String evaluatorName;
  final double rating;

  const EvaluatorCardHeader(
      {Key? key, required this.evaluatorName, required this.rating})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              const CustomSvgIconWidget(
                IconPath.evaluatorIcon,
                iconSize: 32,
              ),
              const CustomHorizontalSpace(width: 8),
              CustomTextWidget(
                evaluatorName,
                maxLines: 1,
                textAlign: TextAlign.start,
                fontSize: 14,
                textOverflow: TextOverflow.ellipsis,
                fontWeight: AppFontWeight.w600,
              ),
            ],
          ),
        ),
        RatingEvaluationWidget(
          rating: rating,
        ),
      ],
    );
  }
}
