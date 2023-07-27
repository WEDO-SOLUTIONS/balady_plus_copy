import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import 'buttons/custom_buttons_widgets.dart';
import 'custom_spaces_widgets.dart';

class NeedLoginWidget extends StatefulWidget {
  final String? img;
  final String? title;
  final String? desc;
  final Function(bool isSuccess)? onSuccessLogin;

  const NeedLoginWidget(
      {Key? key, this.desc, this.img, this.title, this.onSuccessLogin})
      : super(key: key);

  @override
  _NeedLoginWidgetState createState() => _NeedLoginWidgetState();
}

class _NeedLoginWidgetState extends State<NeedLoginWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              IconPath.needLogin, //MM
              width: 184,
              height: 190,
            ),
            const CustomVerticalSpace(height: 18),
            CustomTextWidget(
              widget.title ?? ("انت غير مسجل دخول").tr(),
              fontSize: 17.0,
              fontColor: AppColor.black800,
              fontWeight: AppFontWeight.bold,
            ),
            // if (widget.desc != null)
            const CustomVerticalSpace(height: 18),
            //if (widget.desc != null)
            CustomTextWidget(
              widget.desc ??
                  ("يجب عليك تسجيل الدخول حتى يتم عرض حتى يتم عرض بيانات هذه الصفحة")
                      .tr(),
              fontSize: 13.0,
              height: 1.6,
              fontColor: AppColor.black400,
              fontWeight: AppFontWeight.medium,
            ),
            Constants.verticalSpaceMedium,
            ElevatedButtonWidget.login(
              onPressed: () async {
                Navigator.pop(context);
                bool isSuccess = await CommonFunctions.onLogin();
                if (widget.onSuccessLogin != null)
                  widget.onSuccessLogin!(isSuccess);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyListWidget extends StatelessWidget {
  final String? img;
  final String? title;
  final String? desc;
  String btnText;
  VoidCallback? btnPressed;
  double imgHeight;
  double imgWidth;

  EmptyListWidget(
      {Key? key,
      this.desc,
      this.img = "noReports@3x.png",
      this.title,
      this.btnText = "",
      this.btnPressed,
      this.imgHeight = 161,
      this.imgWidth = 190})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              IconPath.needLogin,
              width: imgWidth,
              height: imgHeight,
            ),
            const CustomVerticalSpace(height: 48),
            CustomTextWidget(title ?? "",
                fontSize: 17, fontColor: AppColor.black800),
            const CustomVerticalSpace(height: 13),
            CustomTextWidget(
              desc ?? "",
              fontSize: 13,
              height: 1.5,
              fontColor: AppColor.black500,
              fontWeight: AppFontWeight.medium,
            ),
            if (btnText.isNotEmpty && btnPressed != null)
              const CustomVerticalSpace(height: 30),
            if (btnText.isNotEmpty && btnPressed != null)
              EnhancedCustomElevatedButtonWidget(
                btnPressed: btnPressed,
                btnText: btnText,
                btnTextSize: 16,
                btnTextWeight: AppFontWeight.medium,
                btnHeight: 48,
                btnTextColor: AppColor.darkTurquoise,
                btnBorderColor: AppColor.darkTurquoise,
                btnColor: Colors.transparent,
                btnWidth: 176,
              ),
          ],
        ),
      ),
    );
  }
}
