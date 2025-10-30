import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/facility_qr/facility_qr_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/enums/enums.dart';

class FacilityHeaderWidget extends StatelessWidget {
  final String facilityName;
  final bool openNow;
  final String facilityAddress;

  const FacilityHeaderWidget(
      {super.key,
      required this.facilityAddress,
      required this.facilityName,
      required this.openNow});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: CustomTextWidget(
                facilityName,
                fontColor: AppColor.blackModern800Light,
                fontSize: 18,
                maxLines: 10,
                height: 1.4,
                fontWeight: AppFontWeight.bold,
              ),
            ),
            const CustomHorizontalSpace(width: 24),
            CustomTextWidget(
              openNow ? ("lbl_open_now").tr() : ("closed").tr(),
              fontColor: openNow ? AppColor.secondary900Light : AppColor.red,
              fontWeight: AppFontWeight.medium,
              fontSize: 16,
            )
          ],
        ),
        const CustomVerticalSpace(height: 12),
        CustomTextWidget(
          facilityAddress,
          fontWeight: AppFontWeight.medium,
          fontSize: 14,
          fontColor: AppColor.blackModern500Light,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}

/*
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show
        CustomAutoSizeTextWidget,
        CustomHorizontalSpace,
        CustomNetworkImageWidget,
        CustomTextWidget,
        CustomVerticalSpace;

class FacilityHeaderWidget extends StatelessWidget {
  final double coverImageCurrentHeight;
  final double currentCardHeight;
  final String facilityName;
  final String street;
  final String city;
  final double rating;
  final int reviews;
  final FACILITY_STATUS facilityStatus;
  final String coverImg;
  final String shareUrl;

  const FacilityHeaderWidget(
      {Key? key,
      required this.coverImageCurrentHeight,
      required this.currentCardHeight,
      required this.facilityName,
      required this.rating,
      required this.city,
      required this.street,
      required this.reviews,
      required this.facilityStatus,
      required this.shareUrl,
      this.coverImg = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 1),
          height: coverImageCurrentHeight,
          child: CustomNetworkImageWidget(
            coverImg,
            imageHeight: coverImageCurrentHeight,
            imageWidth: double.infinity,
          ),
        ),
        Positioned(
          top: coverImageCurrentHeight / 1.4,
          child: AnimatedContainer(
            alignment: Alignment.bottomCenter,
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 1),
            child: SizedBox(
              height: currentCardHeight,
              width: MediaQuery.of(context).size.width,
              child: FacilityCardWidget(
                name: facilityName,
                rating: rating,
                reviews: reviews,
                street: street,
                city: city,
                cardHeight: currentCardHeight,
                facilityStatus: facilityStatus,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(
              top: MediaQuery.of(context).padding.top, start: 12, end: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Image.asset(IconPath.qrGreyCloseIcon),
              ),
              // remove share icon temp
              /*IconButton(
                onPressed: () {
                  if (shareUrl.isNotEmpty) {
                    Share.share(shareUrl);
                  }
                },
                icon: Image.asset(Constants.imgPath + 'share_circle@3x.png'),
              ),*/
            ],
          ),
        ),
      ],
    );
  }
}

class FacilityCardWidget extends StatelessWidget {
  final String name;
  final String street;
  final String city;
  final double rating;
  final int reviews;
  final double cardHeight;
  final FACILITY_STATUS facilityStatus;

  const FacilityCardWidget(
      {Key? key,
      required this.name,
      required this.rating,
      required this.city,
      required this.street,
      required this.reviews,
      required this.facilityStatus,
      required this.cardHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: cardHeight,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: const [
            BoxShadow(
                color: Color(0x1c000000),
                offset: Offset(0, 2),
                blurRadius: 5,
                spreadRadius: 0)
          ],
          color: const Color(0xfffdfcfc)),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomVerticalSpace(height: 5),
            Row(
              children: [
                Expanded(
                  child: CustomAutoSizeTextWidget(
                    name,
                    maxFontSize: 22,
                    minFontSize: 15,
                    fontWeight: AppFontWeight.bold,
                    fontColor: AppColor.black,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
                const CustomHorizontalSpace(width: 5),
                RateAndReviewWidget(
                  rate: rating,
                  review: reviews,
                  fontSize: 11,
                ),
              ],
            ),
            const CustomVerticalSpace(height: 16),
            AnimatedScale(
              scale: cardHeight == 63 ? 0 : 1,
              duration: const Duration(milliseconds: 1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInOut,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      getAddress(),
                      fontColor: AppColor.black500,
                      fontSize: 14,
                      fontWeight: AppFontWeight.medium,
                      maxLines: 1,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                    const CustomVerticalSpace(height: 16),
                    FacilityStatusWidget(facilityStatus: facilityStatus)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getAddress() {
    String address = "";
    try {
      address = street + " . " + city;
      if (facilityStatus == FACILITY_STATUS.cancel &&
          (street.isNotEmpty || city.isNotEmpty)) {
        address = street + " . " + city + ('previously').tr();
      } else {
        address = street + " . " + city;
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      error.toString();
    }
    return address;
  }
}

class FacilityStatusWidget extends StatelessWidget {
  final FACILITY_STATUS facilityStatus;

  const FacilityStatusWidget({Key? key, required this.facilityStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
      decoration: BoxDecoration(
          color: getBackgroundColor(), borderRadius: BorderRadius.circular(2)),
      child: CustomTextWidget(
        getText(),
        fontColor: getTextColor(),
        fontSize: 13,
        fontWeight: AppFontWeight.medium,
        maxLines: 1,
      ),
    );
  }

  Color getTextColor() {
    switch (facilityStatus) {
      case FACILITY_STATUS.open:
        return AppColor.lightGreen1;
      case FACILITY_STATUS.close:
        return AppColor.red;
      case FACILITY_STATUS.cancel:
        return AppColor.black700;
      default:
        return AppColor.black700;
    }
  }

  Color getBackgroundColor() {
    switch (facilityStatus) {
      case FACILITY_STATUS.open:
        return AppColor.lightGreen;
      case FACILITY_STATUS.close:
        return AppColor.red200;
      case FACILITY_STATUS.cancel:
        return AppColor.black200;
      default:
        return AppColor.black200;
    }
  }

  String getText() {
    switch (facilityStatus) {
      case FACILITY_STATUS.open:
        return ('open').tr();
      case FACILITY_STATUS.close:
        return ('closed');
      case FACILITY_STATUS.cancel:
        return ('canceled').tr();
      default:
        return ('canceled').tr();
    }
  }
}
*/
