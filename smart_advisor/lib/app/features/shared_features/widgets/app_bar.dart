import '../../../core/services/local/navigation_services.dart';
import '/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '/app/core/utils/constants/paths/icon_paths.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function? onFilter;
  const CustomAppBar({super.key, required this.title, this.onFilter});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          bottom: 12,
          left: 12,
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColor.gray),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    NavigationService.navigatorKey.currentState!.pop(context);
                  },
                  icon: SvgPicture.asset(
                    IconPath.newBackIcon,
                    width: 24,
                    height: 24,
                    color: AppColor.black, //statusAccentColor,
                  ),
                ),
                Flexible(
                  child: Text(title,
                      maxLines: 1, style: AppStyle.callout1BoldStyle),
                ),
                const SizedBox(
                  width: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);
}
