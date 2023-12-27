import 'package:balady_plus/app/core/utils/app_analytics_events.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/pages/self_rating_section_page.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/widgets/self_rating_main_widgets/self_rating_main_title_widget.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_guide_select_widgets.dart/violation_options_select.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/paths/image_paths.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';

class SelfRatingMainPage extends StatefulWidget {
  const SelfRatingMainPage({super.key});

  @override
  State<SelfRatingMainPage> createState() => _SelfRatingMainPageState();
}

class _SelfRatingMainPageState extends State<SelfRatingMainPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendEventToAnalytics(AppEvents.selfRating);
    CommonFunctions.sendUXCamEvent(UXCamEvents.mainServicePremisesAssessment);
    CommonFunctions.sendUXCamEvent(
        UXCamEvents.PremisesAssessment_Main_Page_Event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/balady_bg.png"),
                fit: BoxFit.cover)),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: 16, top: MediaQuery.of(context).padding.top),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: AppColor.white,
                  )),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SelfRatingMainTitleWidget(),
                      ViolationSelectOptionsWidget(
                        title: 'review-building'.tr(),
                        subtitle: 'review_building_subtitle'.tr(),
                        color1: AppColor.lightOrange200,
                        color2: AppColor.lightOrange100,
                        logo: IconPath.selfRatingBuilding,
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            RouteName.SelfRatingSectionPage,
                          );
                        },
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
