import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppColorsTheme, AppFontWeight, CommonProperties, IconPath;
import 'package:balady_plus/etmam_app/features/home/home_exports.dart';
import 'package:balady_plus/etmam_app/features/providers/providers_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../app/core/utils/debouncer.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/search_text_field_widget.dart';
import '../../shared_feature_exports.dart'
    show CustomSvgIconWidget, CustomTextWidget;

class CustomAppBarProvidersList extends StatefulWidget
    implements PreferredSizeWidget {
  final String? title;
  final bool withCloseImg;
  final bool withBackImg;
  final String? actionImg;
  final VoidCallback? actionOnPress;
  final double fontSize;
  final double actionImgSize;
  final Widget? bottomWidget;

  const CustomAppBarProvidersList({
    Key? key,
    this.title,
    this.bottomWidget,
    this.withCloseImg = false,
    this.withBackImg = true,
    this.fontSize = 18,
    this.actionImg,
    this.actionImgSize = 24,
    this.actionOnPress,
  }) : super(key: key);

  @override
  State<CustomAppBarProvidersList> createState() => _CustomAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBar extends State<CustomAppBarProvidersList> {
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
      centerTitle: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePath.appbarBg),
            fit: BoxFit.cover,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,

      elevation: 0,
      titleSpacing: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: widget.bottomWidget ?? SizedBox.fromSize(),
      ),
      leading: (widget.withCloseImg || widget.withBackImg)
          ? IconButton(
              icon: Icon(
                widget.withCloseImg ? Icons.close : Icons.arrow_back_ios,
                color: Color(0xff18181b),
                size: widget.withCloseImg ? 28 : null,
              ),
              onPressed:
                  widget.actionOnPress ?? () => Navigator.of(context).pop(),
            )
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
