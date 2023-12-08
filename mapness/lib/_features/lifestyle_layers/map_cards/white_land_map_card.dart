import 'package:flutter/material.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';

class WhiteLandMapCard extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? subSubTitle;
  final String? municipality;
  final String? subMunicipality;
  final String? area;
  final String? parcelNo;
  final String? stageNo;

  final Function onClose;

  const WhiteLandMapCard(
      {super.key,
      this.subSubTitle,
      this.subTitle,
      this.title,
      this.municipality,
      this.subMunicipality,
      this.area,
      this.parcelNo,
      this.stageNo,
      required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 160,
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x1C77758D),
                blurRadius: 22,
                offset: Offset(0, 4),
                spreadRadius: 0,
              )
            ],
          ),
          child: Stack(
            children: [
              Column(
                textDirection: TextDirection.ltr,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "land_info",
                    // fontColor: AppColor.blackModern800Light,
                    // fontSize: 16,
                    // fontWeight: AppFontWeight.bold,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$municipality,  $subMunicipality",
                    // fontColor: AppColor.blackModern500Light,
                    // fontSize: 12,
                    // fontWeight: AppFontWeight.semiBold,
                    // height: 1.3,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    area ?? "",
                    // fontColor: AppColor.blackModern500Light,
                    // fontSize: 12,
                    // fontWeight: AppFontWeight.semiBold,
                    // height: 1.3,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "القطعة: $parcelNo",
                    // fontColor: AppColor.blackModern500Light,
                    // fontSize: 12,
                    // fontWeight: AppFontWeight.semiBold,
                    // height: 1.3,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "المرحلة: $stageNo",
                    // fontColor: AppColor.blackModern500Light,
                    // fontSize: 12,
                    // fontWeight: AppFontWeight.semiBold,
                    // height: 1.3,
                    maxLines: 3,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    onClose();
                  },
                  child: const CustomCloseButton(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
