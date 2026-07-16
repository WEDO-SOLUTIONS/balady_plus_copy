import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class NeedLoginWidget extends StatefulWidget {
  final String? img;
  final String? title;
  final String? desc;
  final String? mainPage;
  final Function(bool isSuccess)? onSuccessLogin;
  final bool withoutActions;

  const NeedLoginWidget({
    super.key,
    this.desc,
    this.img,
    this.title,
    this.mainPage,
    this.onSuccessLogin,
    this.withoutActions = false,
  });

  @override
  State<NeedLoginWidget> createState() => _NeedLoginWidgetState();
}

class _NeedLoginWidgetState extends State<NeedLoginWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<EntryPointCubit, EntryPointState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated && widget.onSuccessLogin != null) {
          widget.onSuccessLogin!(true);
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Content
              Image.asset("assets/icons/png/lockv.webp", width: 73, height: 88, fit: BoxFit.cover),
              // const CustomSvgIconWidget(
              //   IconPath.lock,
              //   iconSize: 82,
              //   iconColor: AppColor.primary900Light,
              // ),
              const SizedBox(height: 16),
              CustomTextWidget(
                widget.title ?? ("not_registered").tr(),
                fontColor: AppColor.blackModern600Light,
                fontWeight: AppFontWeight.bold,
                fontSize: 20,
              ),

              const SizedBox(height: 8),
              CustomTextWidget(
                widget.desc ?? ('not_register_desc').tr(),
                fontColor: AppColor.blackModern500Light,
                fontWeight: AppFontWeight.bold,
                fontSize: 13,
                maxLines: null,
                textAlign: TextAlign.center,
                height: 1.5,
              ),
              const SizedBox(height: 16),

              /// Actions Buttons
              if (!widget.withoutActions) ...[
                EnhancedCustomElevatedButtonWidget(
                  btnPressed: () => CommonFunctions.onLogin(isMunicipality: true, mainPage: widget.mainPage),
                  btnText: ("signInButton").tr(),
                  btnTextSize: 18,
                  btnTextWeight: AppFontWeight.bold,
                  btnTextColor: AppColor.white,
                  btnHeight: 56,
                  btnRadius: 8,
                ),
                const SizedBox(height: 12),
                EnhancedCustomElevatedButtonWidget(
                  btnPressed: () {
                    //todo check if close mini app needed
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  btnText: ("notNow").tr(),
                  btnTextSize: 16,
                  btnTextWeight: AppFontWeight.bold,
                  btnTextColor: AppColor.primary900Light,
                  btnBorderWidth: 1,
                  btnColor: Colors.transparent,
                  btnBorderColor: AppColor.primary900Light,
                  btnHeight: 56,
                  btnRadius: 8,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyListWidget extends StatelessWidget {
  final String img;
  final String? title;
  final String? desc;
  final String btnText;
  final VoidCallback? btnPressed;
  final double imgHeight;
  final double imgWidth;

  const EmptyListWidget({
    super.key,
    this.desc,
    this.img = ImagePath.emptyDoc,
    this.title,
    this.btnText = "",
    this.btnPressed,
    this.imgHeight = 161,
    this.imgWidth = 190,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(img, width: imgWidth, height: imgHeight),
            const CustomVerticalSpace(height: 48),
            CustomTextWidget(title ?? "", fontSize: 17, fontColor: AppColor.black800, maxLines: 2),
            const CustomVerticalSpace(height: 13),
            CustomTextWidget(
              desc ?? "",
              fontSize: 13,
              height: 1.5,
              fontColor: AppColor.black500,
              fontWeight: AppFontWeight.medium,
            ),
            if (btnText.isNotEmpty && btnPressed != null) const CustomVerticalSpace(height: 30),
            if (btnText.isNotEmpty && btnPressed != null)
              EnhancedCustomElevatedButtonWidget(
                btnPressed: btnPressed,
                btnText: btnText,
                btnTextSize: 16,
                btnTextWeight: AppFontWeight.medium,
                btnHeight: 48,
                btnTextColor: AppColor.primary900Light,
                btnBorderColor: AppColor.primary900Light,
                btnColor: Colors.transparent,
                btnWidth: 176,
              ),
          ],
        ),
      ),
    );
  }
}
