import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/paths/icon_paths.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../../shared_features/widgets/custom_icon.dart';
import 'custom_widgets/customTextField.dart';

class CustomImageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Function onSearch;
  final String title;

  CustomImageAppBar(
      {this.height = 195.0,
      required this.onSearch,
      required this.title}); // Adjusted height for search bar

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Stack(
        children: [
          Container(
            height: 175, // Adjust for search bar height
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF6BA278), // #6BA278
                  Color(0xFF558F62), // #558F62
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                          IconPath.backIcon,
                          width: 12,
                          color: AppColor.white, //statusAccentColor,
                        ),
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CustomButtonIcon(
                        icon: IconPath.QRCode,
                        onPress: () {
                          NavigationService.navigatorKey.currentState!
                              .pushNamed(RouteName.qrDetails);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Search bar

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(top: 30, left: 16, right: 16),
              child: Textfield(
                onChanged: (String? str) {
                  onSearch(str);
                  /*  setState(() {
                      query = str ?? "";
                    });*/
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
