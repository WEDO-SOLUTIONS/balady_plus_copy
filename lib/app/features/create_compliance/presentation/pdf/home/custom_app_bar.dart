import 'package:balady_plus/app/core/utils/constants/constants.dart';

import '../list/list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String icon;
  final String name;
  final String listicon;
  final bool showList;
  const CustomAppBar({
    super.key,
    required this.icon,
    required this.name,
    required this.listicon,
    this.showList = true,
  });

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
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: SvgPicture.asset(
                    icon,
                    width: 18,
                  ),
                ),
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF3F3F46),
                    fontSize: 20,
                    fontFamily: Constants.appFontType,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            if (showList)
              CircleAvatar(
                backgroundColor: const Color(0x66CDE0E0),
                radius: 24,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListPage(),
                      ),
                    );
                  },
                  icon: SvgPicture.asset(
                    listicon,
                    width: 24,
                    height: 24,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(114);
}
