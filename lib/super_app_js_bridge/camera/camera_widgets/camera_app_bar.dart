import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../app/core/utils/constants/constants.dart';
import '../../../app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';

class CameraAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback flashOnPress;
  final bool isFlashOn;
  final bool showFlashIcon;

  const CameraAppBar(
      {super.key,
      required this.flashOnPress,
      required this.isFlashOn,
      required this.showFlashIcon});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: true,
      leading: Container(
        margin: EdgeInsetsDirectional.only(start: 16),
        child: CustomTextButtonWidget(
          text: ('vd_cancel').tr(),
          btnTextSize: 13,
          btnAlignment: AlignmentDirectional.center,
          btnTextColor: AppColor.baladyDarkGreen2,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      leadingWidth: 50,
      actions: [
        if (showFlashIcon)
          Container(
            margin: EdgeInsetsDirectional.only(end: !isFlashOn ? 18 : 16),
            child: CustomIconButtonWidget(
              icon:
                  !isFlashOn ? IconPath.vdFlashOffIcon : IconPath.vdFlashOnIcon,
              onPressed: flashOnPress,
              btnHeight: !isFlashOn ? 20 : 20,
              btnWidth: !isFlashOn ? 12 : 16,
            ),
          ),
      ],
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarBrightness: Brightness.light,
      ),
      flexibleSpace: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: Constants.appBarBoxShadow,
            ),
            alignment: AlignmentDirectional.topStart,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: LinearProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColor.baladyDarkGreen2,
              ),
              value: 1,//1 / (getPageList().length + 1),
            ),
          ),
        ],
      ),
    );
  }
}
