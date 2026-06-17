import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/icons/general_icon.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/constants/paths/image_paths.dart';
import 'buttons/custom_buttons_widgets.dart';

class DetailsHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;

  final Function? onPress;
  final Function? onPrint;
  final Function? procedures;
  const DetailsHeader(
      {super.key,
      this.title,
      this.onPrint,
      this.procedures,
      this.onPress,
      this.titleWidget});

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
        child: Semantics(
          label: 'a11yBack'.tr(),
          button: true,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: ExcludeSemantics(
              child: Row(children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: AppColor.blackModern700Light,
                  size: 20,
                ),
                titleWidget ??
                    CustomTextWidget(title ?? "",
                        fontSize: 20,
                        fontWeight: AppFontWeight.bold,
                        fontColor: AppColor.blackModern700Light,
                        fontFamily: Constants.appFontType)
              ]),
            ),
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
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onPrint != null)
                  GeneralIcon(onTap: () => onPrint!(), icon: IconPath.printer),
                if (procedures != null)
                  GeneralIcon(
                      onTap: () => procedures!(), icon: IconPath.settings),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(100);
}
