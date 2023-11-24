import 'package:flutter/material.dart';
import 'package:mapness/_features/landing/widgets/favorites.dart';
import 'package:mapness/app/routes/search.dart';
import 'package:mapness/pages/kiblah/ui/kiblah_compass.dart';
import 'package:mapness/pages/kiblah/ui/kiblah_header.dart';

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
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 75 + 16,
                ),
                child: Favorites(
                  background: Colors.white,
                  promotedTab: "المساجد القريبة منك",
                  promotedTabIcon: "assets/icons/svg/ic_mosque.svg",
                  promotedTap: () {
                    const SearchRoute(
                      initialQuery: "المساجد القريبة منك",
                      withClustering: true,
                    ).pushReplacement(context);
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
