import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, CommonProperties, IconPath;
import '../../../home_exports.dart' show HomeAppBar, CircleIcon;

import '../../../../map_page/screen/map_screen_urbi.dart';

class HomeMap extends StatelessWidget {
  const HomeMap({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Stack(
        children: [
          SizedBox(
            child: MapScreenUrbi(),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                HomeAppBar(),
                SizedBox(height: 16),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: CircleIcon(
                    icon: IconPath.search,
                    iconColor: AppColor.black,
                  ),
                ),
              ],
            ),
          ),
          Positioned.directional(
            bottom: 120,
            end: 16,
            textDirection: TextDirection.rtl,
            child: const CircleIcon(
              icon: IconPath.layers,
              iconColor: AppColor.white,
              backgroundColor: AppColor.primary900Light,
            ),
          ),
          Positioned.directional(
            bottom: 60,
            end: 16,
            textDirection: TextDirection.rtl,
            child: const CircleIcon(
              icon: IconPath.currentLocation,
              iconColor: AppColor.white,
              backgroundColor: AppColor.primary900Light,
            ),
          ),
        ],
      ),
    );
  }
}
