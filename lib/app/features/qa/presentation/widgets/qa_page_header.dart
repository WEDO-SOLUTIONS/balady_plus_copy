import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/icons/general_icon.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/constants/paths/image_paths.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';

class QADetailsHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function? onPress;
  final Function? procedures;
  const QADetailsHeader(
      {super.key, required this.title, this.procedures, this.onPress});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      actions: [
        if (onPress != null)
          CustomTextIconButtonWidget(
            icon: Icon(
              Icons.add,
              size: 30,
              color: AppColor.primary900Light,
            ),
            text: "",
            onPressed: () => onPress != null ? onPress!() : null,
          )
      ],
      leadingWidth: 0,
      automaticallyImplyLeading: false,
      title: Container(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Row(children: [
            Icon(
              Icons.arrow_back_ios,
              color: AppColor.blackModern700Light,
              size: 20,
            ),
            CustomTextWidget(title,
                fontSize: 20,
                fontWeight: AppFontWeight.bold,
                fontColor: AppColor.blackModern700Light,
                fontFamily: Constants.appFontType)
          ]),
        ),
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarBrightness: Brightness.light,
      ),
      flexibleSpace: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 40, left: 16, right: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage(ImagePath.appBarBackground),
                fit: BoxFit.fill,
              ),
              boxShadow: Constants.appBarBoxShadow,
            ),
          ),
          /* Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Container(
              height: 34,
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(8),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                CustomTextWidget(
                  "الإمتثال",
                  fontSize: 11,
                  fontWeight: AppFontWeight.bold,
                ),
              ]),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: AppColor.primary900Light,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0F0C243C),
                    blurRadius: 32,
                    offset: Offset(0, 8),
                    spreadRadius: 0,
                  )
                ],
              ),
            ),
          )*/
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100);
}
