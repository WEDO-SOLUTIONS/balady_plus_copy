import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/app/routes/home_shell.dart';
import 'package:mapness/app/routes/search.dart';
import 'package:mapness/pages/kiblah/ui/kiblah_compass.dart';
import 'package:mapness/pages/kiblah/ui/kiblah_header.dart';
import 'package:mapness/shared/config/package_config.dart';

class KiblahPage extends StatelessWidget {
  const KiblahPage({super.key});

  @override
  Widget build(BuildContext context) {
    print("KiblahPage rebuild");

    return Material(
      color: Colors.black.withOpacity(0.6),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const SafeArea(
            bottom: false,
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  KiblahHeader(),
                  Spacer(),
                ],
              ),
            ),
          ),
          const Align(
            alignment: Alignment.center,
            child: SafeArea(
              top: false,
              child: KiblahCompass(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: Material(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xFF4CA5B4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    const LandingRoute().go(context);
                    const SearchRoute(
                      initialQuery: "المساجد القريبة منك",
                      withClustering: true,
                    ).push(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      bottom: 20,
                      left: 18,
                      right: 18,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "المساجد القريبة منك",
                          style: Theme.of(context)
                              .extension<ThemeTextStyles>()!
                              .accentM
                              .copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        SvgPicture.asset(
                          "assets/icons/svg/ic_mosque.svg",
                          package: PackageConfig.packageName,
                          width: 24,
                          height: 24,
                        ),
                        // title: "المساجد القريبة منك",
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
