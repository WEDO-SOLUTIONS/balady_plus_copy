import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/utils_exports.dart' show CommonFunctions, IconPath;
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../home_page/home_exports.dart' show CircleIcon;

class FormAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentStep;
  final int pageLength;
  final VoidCallback backOnPress;
  final VoidCallback onClose;
  const FormAppBar({
    super.key,
    required this.currentStep,
    required this.backOnPress,
    required this.pageLength,
    required this.onClose,
  });

  @override
  Size get preferredSize => const Size.fromHeight(120);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leadingWidth: 200,
      leading: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: backOnPress,
        child: Container(
          margin: const EdgeInsetsDirectional.only(start: 10),
          child: Row(
            children: [
              CustomTextIconButtonWidget(
                text: ('back').tr(),
                icon: SvgPicture.asset(IconPath.vdAppBarBack),
                iconTextTweenSpace: 5,
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColor.blackModern700Light,
                  fontFamily: Constants.appFontType,
                ),
                onPressed: backOnPress,
              ),
            ],
          ),
        ),
      ),
      // leadingWidth: 32,
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 10),
          child: InkWell(
            onTap: () => onClose(),
            child: CircleIcon(
              icon: Icons.close,
              iconColor: AppColor.primary600Light,
              backgroundColor: AppColor.geyser.withValues(alpha: 0.4),
              iconSize: 18,
            ),
          ),
        ),
      ],
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(statusBarBrightness: Brightness.light),

      flexibleSpace: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 40, left: 16, right: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(image: AssetImage(ImagePath.appBarBackground), fit: BoxFit.fill),
              boxShadow: Constants.appBarBoxShadow,
            ),
            alignment: AlignmentDirectional.bottomCenter,
            child: LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 32,
              addAutomaticKeepAlive: false,
              lineHeight: 6.7,
              isRTL: CommonFunctions.isAppAR ? true : false,
              animationDuration: 0,
              restartAnimation: false,
              percent: currentStep / pageLength,
              barRadius: const Radius.circular(33),
              backgroundColor: AppColor.primary100Light,
              linearGradient: LinearGradient(colors: [AppColor.primary900Light, Color(0xff159EBB)]),
            ),
          ),
        ],
      ),
    );
  }
}
