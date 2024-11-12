import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/features/shared_features/widgets/custom_button.dart';

class FilterDialog extends StatefulWidget {
  final int? selection;
  const FilterDialog({super.key, this.selection});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  int? selection;

  @override
  void initState() {
    super.initState();
    selection = widget.selection;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 445,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تصفية ',
                    style: AppStyle.heading2BoldStyle,
                  ),
                  GestureDetector(
                    onTap: () {
                      // NavigationService.navigatorKey.currentState!.pop();
                    },
                    child: SvgPicture.asset(
                        "packages/smart_advisor/smart_advisor_assets/icons/svg/Button.svg"),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selection = 0;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xffE1E1E2).withOpacity(0.40),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(selection == 0
                          ? 'packages/smart_advisor/smart_advisor_assets/icons/svg/Radio.svg'
                          : 'packages/smart_advisor/smart_advisor_assets/icons/svg/Radionotselected.svg'),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'الكل',
                          style: AppStyle.footNoteMediumStyle.copyWith(
                              color: AppColor.textPrimaryColor, fontSize: 16),
                        ),
                      ),
                      SvgPicture.asset(
                        '',
                        color: AppColor.textPrimaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selection = 1;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xffE1E1E2).withOpacity(0.40),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(selection == 1
                          ? 'packages/smart_advisor/smart_advisor_assets/icons/svg/Radio.svg'
                          : 'packages/smart_advisor/smart_advisor_assets/icons/svg/Radionotselected.svg'),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'جسيمة',
                          style: AppStyle.footNoteMediumStyle.copyWith(
                              color: AppColor.textPrimaryColor, fontSize: 16),
                        ),
                      ),
                      SvgPicture.asset(
                        '',
                        color: AppColor.textPrimaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selection = 2;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xffE1E1E2).withOpacity(0.40),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(selection == 2
                          ? 'packages/smart_advisor/smart_advisor_assets/icons/svg/Radio.svg'
                          : 'packages/smart_advisor/smart_advisor_assets/icons/svg/Radionotselected.svg'),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'غير جسيمة',
                          style: AppStyle.footNoteMediumStyle.copyWith(
                              color: AppColor.textPrimaryColor, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              CustomButton(
                btnWidth: 361,
                btnColor: AppColor.primary,
                text: "تصفية",
                onPress: () {
                  Navigator.pop(context, selection);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
