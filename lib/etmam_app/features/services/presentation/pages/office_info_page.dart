import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        AboutOfficeWidget,
        CustomAppBar,
        CustomTextWidget,
        CustomVerticalSpace,
        WorkingDayListWidget;
import 'package:balady_plus/etmam_app/features/services/presentation/widgets/info_card.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show Provider, ProviderNameAndLogoWidget;
import 'package:balady_plus/etmam_app/features/submit_request/submit_request_exports.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart'
    show AppFontWeight, CommonFunctions, IconPath, trans;

class OfficeInfoPage extends StatefulWidget {
  Provider provider;

  OfficeInfoPage({Key? key, required this.provider}) : super(key: key);

  @override
  State<OfficeInfoPage> createState() => _OfficeInfoPageState();
}

class _OfficeInfoPageState extends State<OfficeInfoPage> {
  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(AppEvents.OfficeInfoPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DefaultAppBarWidget(
          title: trans('office_info'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const CustomTextWidget(
                  "بيانات المكتب",
                  fontColor: AppColor.blackModern800Light,
                  fontWeight: AppFontWeight.bold,
                  fontSize: 16,
                ),
                const SizedBox(height: 16),
                WorkingDayListWidget(
                  workingHours: widget.provider.wrokDays,
                ),
                const SizedBox(height: 8),
                InfoCard(
                  onTap: () =>
                      CommonFunctions.launch(widget.provider.website ?? ""),
                  iconPath: IconPath.websiteIcon,
                  title: trans('office_website'),
                  value: widget.provider.website,
                ),
                InfoCard(
                  onTap: () =>
                      CommonFunctions.call(widget.provider.mainBranchContact),
                  iconPath: IconPath.call,
                  title: trans('office_mobile'),
                  value: widget.provider.mainBranchContact,
                  leading: const Row(
                    children: [
                      CustomSvgIconWidget(IconPath.call),
                      SizedBox(width: 4),
                      CustomTextWidget("اتصال" , textStyle: TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary900Light,
                      ),)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
