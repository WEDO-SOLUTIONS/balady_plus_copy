import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/app_style.dart';
import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/features/fees_calculator/presentation/widgets/calculator_drop_down.dart';
import '/app/features/fees_calculator/presentation/widgets/calculator_text_field.dart';
import '/app/features/shared_features/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class BoardDialog extends StatefulWidget {
  final Function((LookUpItem, String)) onAdd;
  const BoardDialog({super.key, required this.onAdd});

  @override
  State<BoardDialog> createState() => _BoardDialogState();
}

class _BoardDialogState extends State<BoardDialog> {
  String? area;
  LookUpItem? board;
  List<LookUpItem> boardsItems = [
    LookUpItem(
      id: 1,
      name: "لوحة ارشادية",
    ),
    LookUpItem(
      id: 2,
      name: "لوحة إعلانية",
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 620,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16, right: 16, left: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: AppColor.surfaceMidContrast,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "اللوحات",
                  style: AppStyle.heading2BoldStyle,
                ),
                GestureDetector(
                  onTap: () {
                    NavigationService.navigatorKey.currentState!.pop();
                  },
                  child: SvgPicture.asset(
                      "packages/smart_advisor/smart_advisor_assets/icons/svg/Button.svg"),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            CalculatorDropdown(
              title: "نوع اللوحة",
              onSelect: (LookUpItem item) {
                board = item;
              },
              list: boardsItems,
            ),
            const SizedBox(
              height: 16,
            ),
            CalculatorCustomTextField(
              onChanged: (String? text) {
                area = text;
              },
              title: "المساحة",
              suffix: "متر مربع",
              color: AppColor.surfaceSecondaryColor,
            ),
            const SizedBox(
              height: 32,
            ),
            CustomButton(
                onPress: () {
                  print(area);
                  if (board != null && (area?.isNotEmpty ?? false)) {
                    widget.onAdd((board!, area!));

                    NavigationService.navigatorKey.currentState!.pop(
                      context,
                    );
                  } else {
                    CommonFunctions.showError("يجب إدخال المساحة ونوع اللوحة");
                  }
                },
                text: "إضافة")
          ],
        ),
      ),
    );
  }
}
