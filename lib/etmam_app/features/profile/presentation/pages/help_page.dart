import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, CommonFunctions, IconPath, trans;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CardSectionWidget,
        CustomAppBar,
        CustomTextWidget,
        CustomVerticalSpace,
        DrawLineWidget;
import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  _HelpPage createState() => _HelpPage();
}

class _HelpPage extends State<HelpPage> {
  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(AppEvents.HelpPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: trans('help_page_header'),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 20, right: 16, left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWidget(
                  trans('help_page_desc'),
                  fontColor: AppColor.greyText,
                  fontSize: 16,
                  fontWeight: AppFontWeight.regular,
                  textAlign: TextAlign.start,
                ),
                const CustomVerticalSpace(height: 16),
                Container(
                  padding: const EdgeInsetsDirectional.only(start: 16, end: 16),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: AppColor.white,
                      boxShadow: [
                        BoxShadow(
                            color: Color(0x14d1d5db),
                            offset: Offset(-4, 8),
                            blurRadius: 8,
                            spreadRadius: 0)
                      ]),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CardSectionWidget(
                        icon: IconPath.helpTwitter,
                        label: "Balady_CS@",
                        onPressed: () {
                          CommonFunctions.launch(
                              'https://twitter.com/Balady_CS');
                        },
                      ),
                      const DrawLineWidget(
                        lineColor: AppColor.lightGray,
                        lineHeight: 0.5,
                      ),
                      CardSectionWidget(
                        icon: IconPath.helpCall,
                        label: "199040",
                        onPressed: () {
                          CommonFunctions.call('199040');
                        },
                      ),
                      const DrawLineWidget(
                        lineColor: AppColor.lightGray,
                        lineHeight: 0.5,
                      ),
                      CardSectionWidget(
                        icon: IconPath.helpEmail,
                        label: "infoCS@balady.gov.sa",
                        onPressed: () {
                          CommonFunctions.launch('mailto:infoCS@balady.gov.sa');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
