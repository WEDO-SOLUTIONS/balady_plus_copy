import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';

import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import 'requir_item/conditions_model.dart';

class BuildingRequirementsPage extends StatefulWidget {
  const BuildingRequirementsPage({super.key});

  @override
  State<BuildingRequirementsPage> createState() =>
      _BuildingRequirementsPageState();
}

class _BuildingRequirementsPageState extends State<BuildingRequirementsPage> {
  List<ConditionsModel> data2 = [];

  @override
  void initState() {
    super.initState();
    //  CommonFunctions.sendEventToAnalytics(AppEvents.buildingCompliance);

    // CommonFunctions.sendUXCamEvent(UXCamEvents.complianceCondition);
    readComplianceData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(
        right: 18,
        left: 18,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              //  padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: Colors.transparent,
              ),
              child: Column(
                children: [
                  MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data2.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return BuildingReqCard(
                          title: data2[index].desc,
                          imgPath: data2[index].photo,
                        );
                      },
                    ),
                  ),
                  //  const SizedBox(height: 32),
                  Container(
                    height: 60,
                    padding: const EdgeInsets.all(12),
                    decoration: ShapeDecoration(
                      color: const Color(0x7FE6EFEF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      "building_requirements_warning".tr(),
                      //   fontColor: const Color(0xFF52525B),
                      //  fontSize: 14,
                      maxLines: 5,
                      //   fontWeight: AppFontWeight.bold,
                    ),
                  )
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
    String qa = await rootBundle.loadString(
        "packages/smart_advisor/smart_advisor_assets/files/compliance_pdf/text/conditions.json");
    if (!CommonFunctions.isAppAR) {
      qa = await rootBundle.loadString(
          "packages/smart_advisor/smart_advisor_assets/files/compliance_pdf/text/conditions_en.json");
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
  const BuildingReqCard({
    super.key,
    required this.title,
    this.imgPath,
  });

  final String title;
  final String? imgPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              /*  const CustomSvgIconWidget(
                "assets/icons/svg/flag.svg",
                iconSize: 14,
              ),
              const SizedBox(width: 4),*/
              Flexible(
                child: Text(
                  title,
                  maxLines: null,
                  style: AppStyle.textRegularStyle
                      .copyWith(color: AppColor.textPrimaryColor, fontSize: 14),
                  /*height: 1.2,
                  fontWeight: AppFontWeight.bold,
                  fontSize: 14,
                  fontColor: AppColor.blackModern600Light,*/
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
                placeholder: (context, url) => const Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
        ],
      ),
    );
  }
}
