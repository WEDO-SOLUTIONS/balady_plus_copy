import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/features/_shared_feature_/presentation/widgets/custom_widgets/customTextField.dart';
import 'package:smart_advisor/app/features/shared_features/widgets/custom_button.dart';

class DistrictsDialog extends StatefulWidget {
  final int? selection;
  const DistrictsDialog({super.key, this.selection});

  @override
  State<DistrictsDialog> createState() => _DistrictsDialogState();
}

class _DistrictsDialogState extends State<DistrictsDialog> {
  int? selection;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 545,
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
                    'اختر الحي ',
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
              const Textfield(),
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
                          'العليا',
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
                          'المربع',
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
                          'الورود',
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
                text: "تاكيد",
                onPress: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
