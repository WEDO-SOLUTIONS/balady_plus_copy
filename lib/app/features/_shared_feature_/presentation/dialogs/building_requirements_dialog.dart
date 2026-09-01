import 'dart:convert';

import 'package:balady_plus/app/core/utils/app_analytics_events.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/conditions_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/analytics_events.dart';
import '../../../../core/utils/utils_exports.dart';
import '../../shared_feature_exports.dart';
import 'dialog_header.dart';

class BuildingRequirementsDialog extends StatefulWidget {
  const BuildingRequirementsDialog({super.key});

  @override
  State<BuildingRequirementsDialog> createState() => _BuildingRequirementsDialogState();
}

class _BuildingRequirementsDialogState extends State<BuildingRequirementsDialog> {
  List<ConditionsModel> data2 = [];

  @override
  void initState() {
    super.initState();
    CommonFunctions.sendEventToAnalytics(AppEvents.buildingCompliance);

    CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.complianceCondition);
    readComplianceData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F8FA),
      padding: EdgeInsets.only(
        right: UIHelper.mediumPadding,
        left: UIHelper.mediumPadding,
        top: UIHelper.smallPadding,
        bottom: context.bottomPadding,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DrawLineWidget(lineWidth: 53, lineHeight: 5, lineColor: AppColor.white5, radius: 46.0),
            const SizedBox(height: 32),
            DialogHeader(title: "buildingRequirements".tr()),
            const SizedBox(height: 12),
            Flexible(
              child: CustomTextWidget(
                "buildingRequirements_desc".tr(),
                fontWeight: AppFontWeight.bold,
                fontSize: 14,
                maxLines: 3,
                height: 1.4,
                textAlign: TextAlign.start,
                fontColor: AppColor.blackModern600Light,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: AppColor.white,
              ),
              child: Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data2.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return BuildingReqCard(title: data2[index].desc, imgPath: data2[index].photo);
                    },
                  ),
                  const SizedBox(height: 32),
                  Container(
                    height: 60,
                    padding: const EdgeInsets.all(12),
                    decoration: ShapeDecoration(
                      color: const Color(0x7FE6EFEF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: CustomTextWidget(
                      "building_requirements_warning".tr(),
                      fontColor: const Color(0xFF52525B),
                      fontSize: 14,
                      maxLines: 5,
                      fontWeight: AppFontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Future<void> readComplianceData() async {
    String qa = await rootBundle.loadString("assets/compliance_pdf/text/conditions.json");
    if (!CommonFunctions.isAppAR) {
      qa = await rootBundle.loadString("assets/compliance_pdf/text/conditions_en.json");
    }

    var r = json.decode(qa);
    {
      List<ConditionsModel>? model = r != null
          ? List<ConditionsModel>.from(r.map((x) => ConditionsModel.fromMap(x)))
          : null;
      data2 = model ?? [];
      setState(() {});
    }
  }
}

class BuildingReqCard extends StatelessWidget {
  const BuildingReqCard({super.key, required this.title, this.imgPath});

  final String title;
  final String? imgPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: const Color(0xFFE6EFEF).withOpacity(0.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CustomSvgIconWidget("assets/icons/svg/flag.svg", iconSize: 14),
              const SizedBox(width: 4),
              Flexible(
                child: CustomTextWidget(
                  title,
                  maxLines: null,
                  height: 1.2,
                  fontWeight: AppFontWeight.bold,
                  fontSize: 14,
                  fontColor: AppColor.blackModern600Light,
                ),
              ),
            ],
          ),
          if (imgPath != null) const SizedBox(height: 12),
          if (imgPath != null)
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: imgPath!,
                width: MediaQuery.sizeOf(context).width,
                height: 190,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      // colorFilter: const ColorFilter.mode(
                      //   Colors.red,
                      //   BlendMode.colorBurn,
                      // ),
                    ),
                  ),
                ),
                placeholder: (context, url) =>
                    const Center(child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator())),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
        ],
      ),
    );
  }
}
