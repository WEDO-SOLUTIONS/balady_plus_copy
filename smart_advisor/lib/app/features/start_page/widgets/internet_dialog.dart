import '../../../core/services/local/navigation_services.dart';
import '../../home_page/presentation/pages/new_home_page.dart';
import '/app/core/utils/utils_exports.dart';
import '/app/features/shared_features/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InternetDialog extends StatelessWidget {
  const InternetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 415,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'عزيزي المستثمر',
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
                height: 8,
              ),
              Column(
                children: [
                  Image.asset(
                    'packages/smart_advisor/smart_advisor_assets/images/laptop.png',
                    height: 147,
                  ),
                  Text(
                    'اذا كان العمل الجديد عبر الانترنت بشكل كامل',
                    style: AppStyle.textRegularStyle
                        .copyWith(color: AppColor.textPrimaryColor),
                  ),
                  Text(
                    ' فلا يوجد اي اشتراطات بلديه للعمل عبر الانترنت ',
                    style: AppStyle.calloutBoldStyle
                        .copyWith(color: AppColor.textPrimaryColor),
                  )
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              CustomButton(
                  btnHeight: 52,
                  //  btnWidth: 170,
                  btnColor: AppColor.primary,
                  textColor: AppColor.white,
                  onPress: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NewHomePage()),
                    );
                  },
                  text: 'حسناً فهمت'),
            ],
          ),
        ),
      ),
    );
  }
}
