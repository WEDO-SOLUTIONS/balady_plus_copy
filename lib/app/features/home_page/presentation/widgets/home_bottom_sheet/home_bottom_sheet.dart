import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor;
import '../../../home_exports.dart'
    show
        GameChallenge,
        ImportantServices,
        NewServices,
        PrayerTimes,
        ShareWithUs;

class HomeBottomSheet extends StatelessWidget {
  const HomeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 300),
        Container(
          decoration: BoxDecoration(
            color: AppColor.paleGrey,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(36),
              topRight: Radius.circular(36),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.blackModern900Light.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 32,
                height: 4,
                margin: const EdgeInsets.only(top: 16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  color: AppColor.lightSkyBlue,
                ),
              ),
              const ImportantServices(),
              const ShareWithUs(),
              const NewServices(),
              const GameChallenge(),
              const PrayerTimes(),
            ],
          ),
        ),
      ],
    );
  }
}
