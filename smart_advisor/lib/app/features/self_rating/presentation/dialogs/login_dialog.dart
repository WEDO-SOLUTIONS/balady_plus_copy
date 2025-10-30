import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/services/local/navigation_services.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';
import 'package:smart_advisor/app/features/home_page/presentation/widgets/area_widget.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/pages/guest/renwe_license_page.dart';
import 'package:smart_advisor/app/features/shared_features/widgets/custom_button.dart';
import 'package:balady_plus/app/features/_shared_feature_/balady_features/services/services.dart';

class LoginDialog extends StatefulWidget {
  final Function(bool isLogin) onSelection;
  const LoginDialog({
    super.key,
    required this.onSelection,
  });

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  bool isGuest = true;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
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
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
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
                            "متابعة الرحلة",
                            style: AppStyle.heading2BoldStyle,
                          ),
                          GestureDetector(
                            onTap: () {
                              NavigationService.navigatorKey.currentState!
                                  .pop();
                            },
                            child: SvgPicture.asset(
                                "packages/smart_advisor/smart_advisor_assets/icons/svg/Button.svg"),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Image.asset(
                          "packages/smart_advisor/smart_advisor_assets/icons/png/track_journey.png"),
                      const SizedBox(
                        height: 24,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "أمامك مساران في رحلة إدارة الرخصة، اختر ما يناسبك:",
                          style:
                              AppStyle.textRegularStyle.copyWith(fontSize: 14),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      AreaWidget(
                        height: 120,
                        onSelect: () {
                          setState(() {
                            isGuest = true;
                          });
                        },
                        title: "إكمال كضيف",
                        description:
                            "يمكنك استعراض خطوات إدارة الرخصة بشكل عام دون الحاجة لتسجيل الدخول.",
                        isSelected: isGuest,
                        isActive: true,
                        hasBorder: true,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      AreaWidget(
                        height: 120,
                        onSelect: () async {
                          setState(() {
                            isGuest = false;
                          });
                        },
                        title: "تسجيل الدخول",
                        description:
                            "ستتمكن من استعراض إرشادات مخصصة باستخدام بيانات رخصتك وأنشطتك لتسهيل بدء الخدمة.",
                        isSelected: !isGuest,
                        isActive: true,
                        hasBorder: true,
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: CustomButton(
                      onPress: () async {
                        bool isLogin = false;

                        if (!isGuest) {
                          isLogin = await BaladyServices.login();
                          if (isLogin) {
                            widget.onSelection(isLogin);

                            return;
                          }
                        }
                        print("HEREEE11 22");

                        if (!isGuest && isLogin == false) {
                          widget.onSelection(false);
                        } else {
                          widget.onSelection(false);
                        }
                      },
                      text: "التأكيد"),
                ),
              ],
            )),
      ),
    );
  }
}
