import '../../../core/services/local/navigation_services.dart';
import '/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/core/utils/constants/paths/icon_paths.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function? onFilter;
  const CustomAppBar({super.key, required this.title, this.onFilter});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 114,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          bottom: 12,
          left: 12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                NavigationService.navigatorKey.currentState!.pop(context);
              },
              icon: SvgPicture.asset(
                IconPath.backIcon,
                width: 12,
                color: AppColor.statusAccentColor,
              ),
            ),
            Flexible(
              child: Text(title, maxLines: 1, style: AppStyle.calloutBoldStyle),
            ),
            const SizedBox(
              width: 40,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(114);
}
