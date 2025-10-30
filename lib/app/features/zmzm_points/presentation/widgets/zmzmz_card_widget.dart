import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/models/zmzm_item_model.dart';

class ZMZMCardWidget extends StatelessWidget {
  final ZMZMItemModel item;

  const ZMZMCardWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(top: 16, bottom: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: AppColor.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    ImagePath.appBarBackground,
                    width: 58,
                    height: 58,
                  ),
                  CustomHorizontalSpace(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextWidget(
                          item.name,
                          maxLines: 6,
                          fontWeight: AppFontWeight.bold,
                          fontSize: 16,
                          fontColor: AppColor.black,
                        ),
                        CustomVerticalSpace(height: 8),
                        CustomTextWidget(
                          item.city,
                          fontWeight: AppFontWeight.medium,
                          fontSize: 12,
                          fontColor: Color(0x8216393A),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: SvgPicture.asset(IconPath.routeSquare),
              onPressed: () {
                CommonFunctions.launchMap(
                  LatLng(
                    latitude: item.latitude,
                    longitude: item.longitude,
                  ),
                );
              },
            )
          ],
        ));
  }
}
