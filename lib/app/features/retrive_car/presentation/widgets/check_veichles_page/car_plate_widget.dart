import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class CarPlateWidget extends StatelessWidget {
  final String? plate;
  final String? type;
  final String? currentId;
  final String? id;
  final Function onChange;
  const CarPlateWidget(
      {super.key,
      this.plate,
      this.type,
      this.currentId,
      this.id,
      required this.onChange});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChange(id);
      },
      child: Container(
          height: 72,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: new BoxDecoration(
            // color: currentId == id ? AppColor.primary50Light50 : Colors.white,
            color: AppColor.primary50Light50,
            borderRadius: BorderRadius.circular(4),
            /* border: Border.all(
                color: currentId == id
                    ? AppColor.primary900Light
                    : AppColor.kGray230),*/
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      type ?? "",
                      fontSize: 14,
                      fontWeight: AppFontWeight.medium,
                      fontColor: AppColor.black,
                      maxLines: 2,
                      height: 1.3,
                      textAlign: TextAlign.start,
                    ),
                    CustomVerticalSpace(height: 10),
                    CustomTextWidget(
                      plate ?? "",
                      fontSize: 14,
                      fontWeight: AppFontWeight.medium,
                      fontColor: AppColor.black,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Radio<String>(
                  value: id ?? "",
                  groupValue: currentId,
                  activeColor: AppColor.primary900Light,
                  onChanged: (v) {},
                ),
              ),
            ],
          )),
    );
  }
}
