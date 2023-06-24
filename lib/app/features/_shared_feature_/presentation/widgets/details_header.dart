import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/constants/paths/image_paths.dart';
import 'buttons/custom_buttons_widgets.dart';

class DetailsHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const DetailsHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leadingWidth: 200,
      leading: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          margin: const EdgeInsetsDirectional.only(start: 10),
          child: Row(
            children: [
              CustomTextIconButtonWidget(
                text: title,
                icon: SvgPicture.asset(IconPath.vdAppBarBack),
                iconTextTweenSpace: 5,
                textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColor.blackModern700Light,
                    fontFamily: Constants.appFontType),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
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
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(119);
}
