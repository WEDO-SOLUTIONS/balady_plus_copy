import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/pages/self_rating_section_page.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/widgets/self_rating_main_widgets/self_rating_main_title_widget.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_guide_select_widgets.dart/violation_options_select.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SelfRatingMainPage extends StatelessWidget {
  const SelfRatingMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xff2C6F83),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SelfRatingMainTitleWidget(),
              ViolationSelectOptionsWidget(
                title: 'review-building'.tr(),
                subtitle: 'review_building_subtitle'.tr(),
                color1: AppColor.lightOrange200,
                color2: AppColor.lightOrange100,
                logo: IconPath.selfRatingBuilding,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SelfRatingSectionPage()),
                  );
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
