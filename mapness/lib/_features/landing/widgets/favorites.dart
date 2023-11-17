import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/app/routes/favourites.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/config/package_fonts.dart';

// TODO: rewrite this (wi/mo)cked widget
class Favorites extends StatelessWidget {
  const Favorites({
    super.key,
    required this.background,
    this.horizontalPadding = 8,
    this.promotedTab,
    this.promotedTabIcon,
    this.promotedTap,
  });

  final Color background;
  final double horizontalPadding;

  final String? promotedTab;
  final Function()? promotedTap;
  final String? promotedTabIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          if (promotedTab != null) {
            index = index - 1;
          }

          if (index == -1) {
            return Padding(
              padding: EdgeInsets.only(
                left: 8.0,
                right: promotedTab != null ? 8.0 : 0,
              ),
              child: Material(
                color: const Color(0xFF4CA5B4),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                child: InkWell(
                  onTap: promotedTap,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Text(
                          promotedTab!,
                          style: PackageFonts.frutigerArabic(
                            fontSize: 12,
                            color: const Color(0xFFFFFFFF),
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        if (promotedTabIcon != null)
                          SvgPicture.asset(
                            promotedTabIcon!,
                            package: PackageConfig.packageName,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else if (index == 0) {
            return Padding(
              padding: EdgeInsets.only(
                left: 8.0,
                right: promotedTab == null ? 8.0 : 0,
              ),
              child: InkWell(
                onTap: () => const FavouritesRoute().push(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/svg/ic_fav.svg",
                    semanticsLabel: 'MinApps Screen',
                    package: "mapness",
                  ),
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: background,
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Row(
                children: [
                  Text(
                    '12 دقيقة',
                    style: PackageFonts.frutigerArabic(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  SvgPicture.asset(
                    index % 2 == 1
                        ? "assets/icons/svg/ic_fav_home.svg"
                        : "assets/icons/svg/ic_fav_work.svg",
                    semanticsLabel: 'MinApps Screen',
                    package: "mapness",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
