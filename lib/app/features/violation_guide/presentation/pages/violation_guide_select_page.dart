import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/pages/violation_create_page.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_guide_select_widgets.dart/violation_guide_title.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_guide_select_widgets.dart/violation_options_select.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/ux_cam_events.dart';

class ViolationGuideSelectPage extends StatefulWidget {
  const ViolationGuideSelectPage({super.key});

  @override
  State<ViolationGuideSelectPage> createState() =>
      _ViolationGuideSelectPageState();
}

class _ViolationGuideSelectPageState extends State<ViolationGuideSelectPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommonFunctions.sendUXCamEvent(UXCamEvents.ViolationGuide_Open_Event);
  }

  @override
  Widget build(BuildContext context) {
    double top = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFFFFF),
              AppColor.primary800Light,
            ],
          ),
        ),
        child: Stack(
          children: [
            Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(top: top + 16.0),
                  child: IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 24,
                      ),
                      color: AppColor.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                )),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ViolationGuideSelectTitle(),
                      ViolationSelectOptionsWidget(
                        title: 'violotion_select_option1'.tr(),
                        subtitle: 'violation_subtitle_select_option1'.tr(),
                        color1: AppColor.lightOrange200,
                        color2: AppColor.lightOrange100,
                        logo: IconPath.magicStar,
                        onPressed: () {
                          Navigator.pushNamed(
                              context, RouteName.violationCreatePage);
                        },
                      ),
                      /* const SizedBox(
                    height: 16,
                  ),
                  ViolationSelectOptionsWidget(
                    logo: IconPath.calculator,
                    onPressed: () {},
                    title: 'violation_select_option2'.tr(),
                    subtitle: 'violation_subtitle_select_option2'.tr(),
                    color1: AppColor.secondary400Light,
                    color2: AppColor.blue100,
                  ),*/
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
