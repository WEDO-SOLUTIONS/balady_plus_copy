import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppColorsTheme, AppFontWeight, IconPath;
import 'package:flutter/material.dart';

import '../../../../../../app/core/utils/common_functions.dart';
import '../../shared_feature_exports.dart'
    show CustomSvgIconWidget, CustomTextWidget;

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final bool withCloseImg;
  final bool withBackImg;
  final String? actionImg;
  final VoidCallback? actionOnPress;
  final double fontSize;
  final double actionImgSize;

  const CustomAppBar({
    Key? key,
    this.title,
    this.withCloseImg = false,
    this.withBackImg = true,
    this.fontSize = 18,
    this.actionImg,
    this.actionImgSize = 24,
    this.actionOnPress,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBar extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: widget.title != null && widget.title!.isNotEmpty
          ? CustomTextWidget(
              widget.title ?? "",
              fontColor: Colors.black,
              fontSize: widget.fontSize,
              fontWeight: AppFontWeight.w600,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
            )
          : const Center(),
      centerTitle: true,
      backgroundColor: AppColor.white,
      leading: (widget.withCloseImg || widget.withBackImg)
          ? IconButton(
              iconSize: 24,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: RotatedBox(
                quarterTurns: CommonFunctions.isAppAR ? 0 : 2,
                child: CustomSvgIconWidget(
                  widget.withCloseImg
                      ? IconPath.close
                      : IconPath.appbarBackArrow,
                  iconSize: widget.withCloseImg ? 16 : 24,
                  //  iconColor: AppColorsTheme.primary700, //MM
                ),
              ))
          : null,
      actions: [
        if (widget.actionImg != null && widget.actionImg != "")
          IconButton(
              iconSize: widget.actionImgSize,
              onPressed: widget.actionOnPress!,
              icon: CustomSvgIconWidget(
                widget.actionImg ?? "",
                iconSize: widget.actionImgSize,
                // iconColor: AppColorsTheme.primary700,
              ))
      ],
      shadowColor: const Color(0xffD1D5DB).withOpacity(0.08),
      // shape: const UnderlineInputBorder(
      //     borderRadius: BorderRadius.only(
      //         bottomLeft: Radius.circular(12),
      //         bottomRight: Radius.circular(12)),
      //     borderSide: BorderSide(color: AppColor.white, width: 0.05)),
      automaticallyImplyLeading: widget.withCloseImg || widget.withBackImg,
    );
  }
}
