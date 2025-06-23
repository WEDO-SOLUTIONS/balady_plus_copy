import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/services/local/navigation_services.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/core/utils/constants/paths/icon_paths.dart';

class NewAppBar extends StatelessWidget {
  final String title;
  final bool showClose;
  const NewAppBar({super.key, required this.title, this.showClose = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            bottom: 12,
            right: showClose ? 45 : 0,
            left: showClose ? 14 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!showClose)
                  IconButton(
                    onPressed: () {
                      NavigationService.navigatorKey.currentState!.pop(context);
                    },
                    icon: SvgPicture.asset(
                      IconPath.newBackIcon,
                      width: 24,
                      height: 24,
                      color: AppColor.textPrimaryColor, //statusAccentColor,
                    ),
                  ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          maxLines: 1,
                          style: AppStyle.callout1BoldStyle
                              .copyWith(color: AppColor.textPrimaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
                if (showClose)
                  IconButton(
                      onPressed: () {
                        NavigationService.navigatorKey.currentState!
                            .pop(context);
                      },
                      icon: SvgPicture.asset(
                        IconPath.close,
                        width: 14,
                        height: 14,
                        color: AppColor.textPrimaryColor, //statusAccentColor,
                      )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // Size get preferredSize => const Size.fromHeight(120);
}
