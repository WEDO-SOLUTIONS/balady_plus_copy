import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'map_details_field.dart';
import 'map_details_sub_header.dart';

class MapDetailsHeader extends StatelessWidget {
  final String name;
  final String address;
  final String type;
  final String image;
  const MapDetailsHeader(
      {super.key,
      required this.name,
      required this.address,
      required this.type,
      required this.image});

  @override
  Widget build(BuildContext context) {
    String img = "assets/images/station_background.png";
    if (type == "المقابر") img = "assets/images/grave_image.png";
    if (type == "المساجد") img = "assets/images/mosque_background.png";
    if (type == "محطات الوقود") img = "assets/images/station_background.png";

    return Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        height: 200,
        width: double.infinity,
        decoration: ShapeDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                image,
              )),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),

          // image: DecorationImage(image: AssetImage())
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: AppColor.white,
                )),
          ],
        ));
  }
}
