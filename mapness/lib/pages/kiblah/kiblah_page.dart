import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/landing/landing_page.dart';
import 'package:mapness/_features/landing/providers/map_controls.dart';
import 'package:mapness/app/routes/home_shell.dart';
import 'package:mapness/pages/kiblah/ui/kiblah_compass.dart';
import 'package:mapness/pages/kiblah/ui/kiblah_header.dart';
import 'package:mapness/shared/config/package_config.dart';

class KiblahPage extends ConsumerWidget {
  const KiblahPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("KiblahPage rebuild");

    return Material(
      color: Colors.black.withOpacity(0.6),
      child: const Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
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
          Align(
            alignment: Alignment.center,
            child: SafeArea(
              top: false,
              child: KiblahCompass(),
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          //     child: Material(
          //       borderRadius: BorderRadius.circular(8),
          //       color: const Color(0xFF4CA5B4),
          //       child: InkWell(
          //         borderRadius: BorderRadius.circular(8),
          //         onTap: () {
          // ref.read(mapControlsProvider.notifier).update(
          //       MapControlsStateMosque(),
          //     );
          //           const LandingRoute(
          //             focusMaker: LangingFocusMaker.mosques,
          //           ).pushReplacement(context);
          //         },
          //         child: Padding(
          //           padding: const EdgeInsets.only(
          //             top: 12,
          //             bottom: 20,
          //             left: 18,
          //             right: 18,
          //           ),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Text(
          //                 "المساجد القريبة منك",
          //                 style: Theme.of(context)
          //                     .extension<ThemeTextStyles>()!
          //                     .accentM
          //                     .copyWith(color: Colors.white),
          //                 textAlign: TextAlign.center,
          //               ),
          //               const SizedBox(
          //                 width: 4,
          //               ),
          //               SvgPicture.asset(
          //                 "assets/icons/svg/ic_mosque.svg",
          //                 package: PackageConfig.packageName,
          //                 width: 24,
          //                 height: 24,
          //               ),
          //               // title: "المساجد القريبة منك",
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
