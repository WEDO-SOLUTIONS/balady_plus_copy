import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/facility_qr/data/license_ratings_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class RatingCard extends StatefulWidget {
  final RatingItem item;
  final Function onChanged;

  const RatingCard({Key? key, required this.item, required this.onChanged})
      : super(key: key);

  @override
  _RatingCardState createState() => _RatingCardState();
}

class _RatingCardState extends State<RatingCard> {
  bool isRedRating = false;
  bool isYellowRating = false;
  int rating = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setRating();
    return Theme(
      data: ThemeData(
        disabledColor: AppColor.greyStarRating,
      ),
      child: Container(
        height: 140,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 7),
        decoration: const BoxDecoration(
          color: Color(0xfffdfcfc),
          boxShadow: [
            BoxShadow(
                color: Color(0x1b000000),
                offset: Offset(0, 2),
                blurRadius: 5,
                spreadRadius: 0)
          ],
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //card title
            CustomTextWidget(
              // widget.item.name,
              widget.item.name ?? "",
              fontSize: 17,
              maxLines: 1,
              fontWeight: AppFontWeight.bold,
              fontColor: AppColor.black,
            ),
            // rating widget
            RatingBar.builder(
              minRating: 1,
              itemSize: 45,
              itemPadding: const EdgeInsets.symmetric(horizontal: 5.0),
              maxRating: 5,
              initialRating: rating.toDouble(),
              itemCount: 5,
              onRatingUpdate: (rating) => setState(() {
                /* if (rating <= 2) {
                  isRedRating = true;
                  isYellowRating = false;
                } else if (rating == 3) {
                  isRedRating = false;
                  isYellowRating = true;
                } else if (rating > 3) {
                  isRedRating = false;
                  isYellowRating = false;
                }*/
                this.rating = rating.toInt();
                widget.onChanged(this.rating);
              }),
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return RatingRowWidget(0,
                        isRedRating: isRedRating,
                        isYellowRating: isYellowRating);
                  case 1:
                    return RatingRowWidget(1,
                        isRedRating: isRedRating,
                        isYellowRating: isYellowRating);
                  case 2:
                    return RatingRowWidget(2,
                        isRedRating: isRedRating,
                        isYellowRating: isYellowRating);
                  case 3:
                    return RatingRowWidget(3,
                        isRedRating: isRedRating,
                        isYellowRating: isYellowRating);
                  case 4:
                    return RatingRowWidget(4,
                        isRedRating: isRedRating,
                        isYellowRating: isYellowRating);
                  default:
                    return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void setRating() {
    if (widget.item.value != null) {
      rating = widget.item.value ?? 0;
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
    }
  }
}

class RatingRowWidget extends StatefulWidget {
  final int index;
  final bool isRedRating;
  final bool isYellowRating;

  const RatingRowWidget(this.index,
      {Key? key, this.isRedRating = false, this.isYellowRating = false})
      : super(key: key);

  @override
  _RatingRowWidgetState createState() => _RatingRowWidgetState();
}

class _RatingRowWidgetState extends State<RatingRowWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          IconPath.qrStarIcon,
          color: widget.isRedRating
              ? AppColor.redStarRating
              : widget.isYellowRating
                  ? AppColor.yellowStarRating
                  : AppColor.baladyDarkGreen2,
          height: 32,
          width: 32,
        ),
        const CustomVerticalSpace(height: 5),
        CustomTextWidget(
          widget.index == 0
              ? ("lbl_bad").tr()
              : widget.index == 4
                  ? ("lbl_good").tr()
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
