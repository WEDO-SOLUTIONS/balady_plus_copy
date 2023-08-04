import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/app_style.dart';

class MapCard extends StatelessWidget {
  String activityId;
  String type;
  String price;
  String desc;
  String area;
  String duration;
  String distance;
  bool isFavorite;
  bool isSeasonal;
  String subMunicipality;
  String entityLogo;
  String? entityName;
  String? location;
  List<String>? locations;
  bool isEntity;
  bool isFree;
  final Function onPress;

  MapCard(
      {required this.activityId,
      required this.desc,
      required this.price,
      required this.area,
      required this.duration,
      required this.type,
      required this.distance,
      required this.subMunicipality,
      this.isFavorite = false,
      this.isSeasonal = false,
      this.entityName,
      required this.entityLogo,
      required this.isEntity,
      this.location,
      this.locations,
      required this.onPress,
      this.isFree = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onPress();
      },
      child: Container(
        height: 141,
        width: 325,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            boxShadow: [
              BoxShadow(
                  color: Color(0x14000000),
                  offset: Offset(0, 2),
                  blurRadius: 24,
                  spreadRadius: 0)
            ],
            color: AppColor.white),
        child: Row(
          children: [
            Container(
              width: 80,
              height: double.infinity,
              margin: const EdgeInsets.only(left: 12),
              child: Stack(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: Image.asset(getActivityImgForMapCard(activityId),
                          height: double.infinity, fit: BoxFit.cover)),
                  Align(
                      alignment: AlignmentDirectional.topStart,
                      child: EntityImg(
                        img: entityLogo,
                        isNetworkImage: isEntity,
                        withBorder: true,
                      ))
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 4),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RentOrInvestWidget(type: type),
                        Expanded(
                          child: PriceWidget(
                            price: price,
                            isSeasonal: isSeasonal,
                            isInvestment: type == "Investment",
                            fontSize: 10,
                            priceFontSize: 12,
                            isFree: isFree,
                            isDirectRental: type == "DirectRental",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      desc,
                      style: AppStyle.cardTitleTextStle
                          .copyWith(fontSize: 13, color: AppColor.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          //flex: 2,
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/" + 'pinLocation@3x.png',
                                height: 12,
                                width: 11,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              /*EntityLocationWithBadge(
                                location: location,
                                locations: locations,
                              )*/
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 11,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/" + 'map_area_icon.png',
                                height: 12,
                                width: 12,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                area,
                                overflow: TextOverflow.ellipsis,
                                style: AppStyle.cardTitleTextStle.copyWith(
                                    color: AppColor.gray10, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/" + 'distance@3x.png',
                                height: 12,
                                width: 12,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                distance,
                                overflow: TextOverflow.ellipsis,
                                style: AppStyle.cardTitleTextStle
                                  ..copyWith(
                                      color: AppColor.gray10, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EntityImg extends StatelessWidget {
  final String img;
  final bool withBorder;
  final double size;
  final bool isNetworkImage;

  const EntityImg(
      {Key? key,
      required this.img,
      this.withBorder = true,
      this.size = 32,
      this.isNetworkImage = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSVG = img.endsWith(".svg");
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: withBorder
                ? Border.all(color: AppColor.primary900Light, width: 1)
                : null,
            color: Colors.white),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: isSVG
                ? SvgPicture.asset(img)
                : isNetworkImage
                    ? Image.network(
                        img,
                        errorBuilder: (ctx, object, _) {
                          return Container(
                              color: AppColor.primary500Light,
                              child: Image.asset(
                                "assets/images/" + 'smallLogo@3x.png',
                              ));
                        },
                      )
                    : Image.asset(img)));
  }
}

String getActivityImgForOpportunityCard(String? activityId) {
  return "assets/images/activity/opportunityCard/" +
      getActivityId(activityId) +
      '.png';
}

String getActivityImgForOpportunityDetails(String? activityId) {
  return "assets/images/activity/opportunityDetails/" +
      getActivityId(activityId) +
      '_big.png';
}

String getActivityImg(String? activityId) {
  return "assets/images/activity/activityIcon/ic_" +
      getActivityId(activityId) +
      '@3x.png';
}

String getActivityImgForMapCard(String? activityId) {
  return "assets/images/activity/map/map_" +
      getActivityId(activityId) +
      '@3x.png';
}

String getActivityId(String? activityId) {
  List<String> activities = [
    '101',
    '102',
    '103',
    '104',
    '105',
    '106',
    '107',
    '108',
    '109',
    '110',
    '111',
    '112',
    '113',
    '114',
    '115',
    '116',
    '117',
    '201',
    '202',
    '203',
    '204',
    '205',
    '206',
    '207',
    '208',
  ];
  if (activityId != null &&
      activityId.isNotEmpty &&
      activities.contains(activityId)) {
    return activityId;
  } else {
    return 'activity_placeholder';
  }
}

class RentOrInvestWidget extends StatelessWidget {
  final String type;
  const RentOrInvestWidget({Key? key, required this.type}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: type == "TempRental"
              ? AppColor.primary700Light
              : AppColor.secondary700Light),
      child: Text(
        type == "Investment" ? ('investment').tr() : ('rent').tr(),
        style: AppStyle.cardTitleTextStle.copyWith(
            fontSize: 12,
            color: type == "TempRental" ? AppColor.white : AppColor.white),
      ),
    );
  }
}

class PriceWidget extends StatelessWidget {
  final String price;
  final bool isInvestment;
  final bool isDirectRental;
  final bool isSeasonal;
  final bool isOrder;
  final double fontSize;
  final double priceFontSize;
  final bool isFree;

  PriceWidget(
      {required this.price,
      required this.isInvestment,
      required this.isDirectRental,
      this.fontSize = 14,
      this.priceFontSize = 15,
      this.isSeasonal = false,
      this.isOrder = false,
      this.isFree = false});

  @override
  Widget build(BuildContext context) {
    return AutoSizeText.rich(
      TextSpan(children: [
        if (!isInvestment && !isOrder && !isSeasonal && !isDirectRental)
          TextSpan(
            text: ('يبدأ من').tr() + "  ",
            style: AppStyle.cardTitleTextStle
                .copyWith(color: AppColor.primary900Light, fontSize: fontSize),
          ),
        TextSpan(
            text: isFree && !isDirectRental ? ("free").tr() : price + "  ",
            style: AppStyle.cardTitleTextStle
              ..copyWith(
                  color: AppColor.primary900Light, fontSize: priceFontSize)),
        if (!isFree)
          TextSpan(
              text: isDirectRental
                  ? ("sar_year").tr()
                  : isInvestment
                      ? ("sr_booklet").tr()
                      : isOrder
                          ? ("price_per_period").tr()
                          : ("sar_per_meter").tr(),
              style: AppStyle.cardTitleTextStle
                ..copyWith(
                    color: AppColor.primary900Light, fontSize: fontSize)),
      ]),
      maxLines: 1,
      maxFontSize: fontSize,
      minFontSize: fontSize - 5,
      textAlign: TextAlign.end,
      textScaleFactor: 1,
    );
  }
}
