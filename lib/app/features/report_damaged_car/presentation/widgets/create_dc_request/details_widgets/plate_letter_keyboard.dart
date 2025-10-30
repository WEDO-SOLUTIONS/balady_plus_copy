import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';

import '../../../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';

class PlateNumberKeyBoard extends StatelessWidget {
  final Function onSelect;
  const PlateNumberKeyBoard({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    var plates =
        CommonFunctions.isAppAR ? carPlateLettersList : carPlateLettersListEn;
    return Container(
      color: Color(0xFFA0A5A9),
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const DrawLineWidget(
            lineWidth: 70.0,
            lineHeight: 6.0,
            lineColor: Color(0xFFE5E5E5),
            radius: 46.0,
          ),
          CustomVerticalSpace(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: plates.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  onSelect(plates[index]);
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 42,
                  width: 58,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColor.white),
                  child: CustomTextWidget(
                    plates[index],
                    fontColor: AppColor.blackModern700Light,
                    fontSize: 22,
                    fontWeight: AppFontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
