import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../../../app/core/utils/constants/constants.dart';
import '../../../../../core/utils/utils_exports.dart';

class CategoryRatingWidget extends StatefulWidget {
  RatingItem item;
  final Function onChangeRate;

  CategoryRatingWidget(
      {Key? key, required this.item, required this.onChangeRate})
      : super(key: key);

  @override
  State<CategoryRatingWidget> createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<CategoryRatingWidget> {
  bool isRedRating = false;
  bool isYellowRating = false;
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      padding: EdgeInsets.only(top: 24, bottom: 16, right: 8, left: 8),
      decoration: new BoxDecoration(
        color: Color(0xfffdfcfc),
        boxShadow: [
          BoxShadow(
              color: Color(0x1b000000),
              offset: Offset(0, 2),
              blurRadius: 5,
              spreadRadius: 0)
        ],
      ),
      child: Column(
        children: [
          CustomTextWidget(
            widget.item.name ?? "",
            fontSize: 17,
            fontWeight: AppFontWeight.bold,
            fontColor: AppColor.black,
            textAlign: TextAlign.center,
          ),
          const CustomVerticalSpace(height: 18),
          // RatingBar(
          //     initialRating: 0,
          //     direction: Axis.horizontal,
          //     allowHalfRating: false,
          //     itemCount: 5,
          //     itemPadding: const EdgeInsets.symmetric(horizontal: 8.0),
          //     ratingWidget: RatingWidget(
          //         empty: CustomSvgIconWidget(
          //           IconPath.emptyStarIcon,
          //           iconSize: 35,
          //         ),
          //         full: CustomSvgIconWidget(
          //           IconPath.fullStarIcon,
          //           iconSize: 35,
          //         ),
          //         half: CustomSvgIconWidget(
          //           IconPath.emptyStarIcon,
          //           iconSize: 35,
          //         )),
          //     onRatingUpdate: (rating) {
          //       widget.onChangeRate(rating.toInt());
          //     }),
          RatingBar.builder(
            unratedColor: AppColor.black200,
            minRating: 1,
            itemSize: 48,
            itemPadding: const EdgeInsets.symmetric(horizontal: 5.0),
            maxRating: 5,
            initialRating: rating.toDouble(),
            itemCount: 5,
            onRatingUpdate: (rating) => setState(() {
              if (rating <= 2) {
                isRedRating = true;
                isYellowRating = false;
              } else if (rating == 3) {
                isRedRating = false;
                isYellowRating = true;
              } else if (rating > 3) {
                isRedRating = false;
                isYellowRating = false;
              }
              this.rating = rating.toInt();
              widget.onChangeRate(rating.toInt());
            }),
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return EtmamRatingRowWidget(0,
                      isRedRating: isRedRating, isYellowRating: isYellowRating);
                case 1:
                  return EtmamRatingRowWidget(1,
                      isRedRating: isRedRating, isYellowRating: isYellowRating);
                case 2:
                  return EtmamRatingRowWidget(2,
                      isRedRating: isRedRating, isYellowRating: isYellowRating);
                case 3:
                  return EtmamRatingRowWidget(3,
                      isRedRating: isRedRating, isYellowRating: isYellowRating);
                case 4:
                  return EtmamRatingRowWidget(4,
                      isRedRating: isRedRating, isYellowRating: isYellowRating);
                default:
                  return Container();
              }
            },
          ),
          const CustomVerticalSpace(height: 30),
        ],
      ),
    );
  }
}

class EtmamRatingRowWidget extends StatefulWidget {
  final int index;
  final bool isRedRating;
  final bool isYellowRating;

  const EtmamRatingRowWidget(this.index,
      {Key? key, this.isRedRating = false, this.isYellowRating = false})
      : super(key: key);

  @override
  _RatingRowWidgetState createState() => _RatingRowWidgetState();
}

class _RatingRowWidgetState extends State<EtmamRatingRowWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          Constants.imgPath + "greyStar.png",
          color: widget.isRedRating
              ? AppColor.redBrown
              : widget.isYellowRating
                  ? AppColor.greenishYellow500
                  : AppColor.baladyDarkGreen2,
          height: 32,
          width: 32,
        ),
        const CustomVerticalSpace(height: 5),
        CustomTextWidget(
          widget.index == 0
              ? trans("lbl_bad")
              : widget.index == 4
                  ? trans("lbl_good")
                  : "",
          fontSize: 13,
          maxLines: 1,
          fontWeight: AppFontWeight.medium,
          fontColor: AppColor.black400,
        ),
      ],
    );
  }
}
