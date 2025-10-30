import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class MapDetailsHeader extends StatelessWidget {
  final String name;
  final String address;
  final String type;
  final String image;
  final Color? color;
  const MapDetailsHeader(
      {super.key,
      this.color,
      required this.name,
      required this.address,
      required this.type,
      required this.image});

  @override
  Widget build(BuildContext context) {
    /* String img = "assets/images/station_background.png";
    if (type == "المقابر") img = "assets/images/grave_image.png";
    if (type == "المساجد") img = "assets/images/mosque_background.png";
    if (type == "محطات الوقود") img = "assets/images/station_background.png";*/

    return Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        height: 200,
        width: double.infinity,
        decoration: ShapeDecoration(
          color: color ?? Color(0xFFC8A83A),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),

          // image: DecorationImage(image: AssetImage())
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: image.endsWith(".svg")
                  ? SvgPicture.asset(
                      image,
                      width: 32,
                      height: 32,
                    )
                  : Image.asset(
                      image,
                      fit: BoxFit.contain,
                      width: 32,
                      height: 32,
                    ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: AppColor.white,
                  )),
            ),
          ],
        ));
  }
}
