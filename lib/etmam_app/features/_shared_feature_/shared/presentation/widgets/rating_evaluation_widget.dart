import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomHorizontalSpace, CustomTextWidget;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, IconPath, trans;

class RatingEvaluationWidget extends StatelessWidget {
  final double? rating;
  final double? totalEvaluation;
  final Color? ratingColor;
  final bool withEvaluationWord;

  const RatingEvaluationWidget(
      {Key? key,
      this.rating,
      this.totalEvaluation,
      this.ratingColor,
      this.withEvaluationWord = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          IconPath.ratingStar,
          height: 12,
          width: 12,
          color: ratingColor ?? AppColor.starRatingColor,
        ),
        const CustomHorizontalSpace(width: 8),
        CustomTextWidget(
          rating.toString(),
          fontColor: ratingColor ?? AppColor.starRatingColor,
          fontSize: 14,
          fontWeight: AppFontWeight.medium,
        ),
        const CustomHorizontalSpace(width: 8),
        CustomTextWidget(
          totalEvaluation != null
              ? withEvaluationWord
                  ? trans('evaluation')
                      .replaceAll("-", totalEvaluation.toString())
                  : "(${(totalEvaluation)})"
              : "",
          fontColor: AppColor.bottomNavigationShadow,
          fontSize: 14,
          fontWeight: AppFontWeight.regular,
        ),
      ],
    );
  }
}

class EtmamRatingEvaluationWidget extends StatelessWidget {
  final dynamic rating;
  final dynamic totalEvaluation;
  final bool withDot;
  final bool withIcon;
  final bool isCenter;

  const EtmamRatingEvaluationWidget(
      {Key? key,
      required this.rating,
      required this.totalEvaluation,
      this.isCenter = false,
      this.withDot = true,
      this.withIcon = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isCenter ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        if (!withDot && withIcon) ...[
          SvgPicture.asset(
            IconPath.boldRatingStar,
            height: 16,
            width: 16,
          ),
          const CustomHorizontalSpace(width: 3.0),
        ],
        Container(
          margin: const EdgeInsets.only(top: 3),
          child: CustomTextWidget(
            "$rating/5",
            fontColor: AppColor.black400,
            fontSize: 13.0,
            textAlign: TextAlign.start,
            maxLines: 1,
            fontWeight: AppFontWeight.bold,
            textOverflow: TextOverflow.ellipsis,
          ),
        ),
        if (withDot && withIcon) ...[
          const CustomHorizontalSpace(width: 6.0),
          SvgPicture.asset(
            IconPath.boldRatingStar,
            height: 16,
            width: 16,
            color: AppColor.baladyDarkGreen2,
          ),
        ],

        const CustomHorizontalSpace(width: 6.0),
        // line or dot
        // withDot
        //     ? Container(
        //         width: 4,
        //         height: 4,
        //         decoration: const BoxDecoration(
        //             shape: BoxShape.circle, color: AppColor.black400),
        //       )
        //     : Container(
        //         width: 1,
        //         height: 8,
        //         color: AppColor.black400,
        //       ),
        const CustomHorizontalSpace(width: 5.0),
        // reviews
        Container(
          margin: const EdgeInsets.only(top: 3.5),
          child: CustomTextWidget(
            _getNumberOfReviews(),
            fontColor: AppColor.black400,
            fontSize: 13.0,
            textAlign: TextAlign.start,
            maxLines: 1,
            fontWeight: AppFontWeight.bold,
            textOverflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _getNumberOfReviews() {
    var reviews = totalEvaluation;
    return "(${"$reviews"})";
  }
}
