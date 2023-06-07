import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor, IconPath;
import '../../../home_exports.dart' show HomeAppBar, CircleIcon;

class HomeMap extends StatelessWidget {
  const HomeMap({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        SizedBox(
          height: 340,
          child: Placeholder(
            fallbackHeight: 340,
          ),
        ),
        Padding(
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
      ],
    );
  }
}
