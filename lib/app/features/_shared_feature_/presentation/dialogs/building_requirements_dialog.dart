import 'dart:convert';

import 'package:balady_plus/app/core/utils/app_analytics_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../core/utils/utils_exports.dart';
import '../../../create_compliance/presentation/pdf/list/list_item/requir_item/conditions_model.dart';
import '../../shared_feature_exports.dart';
import 'dialog_header.dart';

class BuildingRequirementsDialog extends StatefulWidget {
  const BuildingRequirementsDialog({
    super.key,
  });

  @override
  State<BuildingRequirementsDialog> createState() =>
      _BuildingRequirementsDialogState();
}

class _BuildingRequirementsDialogState
    extends State<BuildingRequirementsDialog> {
  List<ConditionsModel> data2 = [];

  @override
  void initState() {
    super.initState();
    CommonFunctions.sendEventToAnalytics(AppEvents.buildingCompliance);

    CommonFunctions.sendUXCamEvent(UXCamEvents.complianceCondition);
    readComplianceData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF5F8FA),
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
            const DrawLineWidget(
              lineWidth: 53,
              lineHeight: 5,
              lineColor: AppColor.white5,
              radius: 46.0,
            ),
            const SizedBox(height: 32),
            DialogHeader(
              title: "buildingRequirements".tr(),
            ),
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
                  /* BuildingReqCard(
                    title:
                        "تعديل استخدام المواقف المعتمدة في قبو  المبنى، وفق الترخيص الصادر له من الأمانة/البلدية",
                    imgPath: ImagePath.buildingReq4,
                  ),
                  BuildingReqCard(
                    title:
                        'عدم تنفيذ منحدر للأشخاص ذوي الإعاقة وفق (الدليل المبسط لمعايير الوصول الشامل للمنشآت)',
                    imgPath: ImagePath.buildingReq1,
                  ),
                  BuildingReqCard(
                    title:
                        'عدم توفير ممر الوصول الجانبي أمام المنحدر الخاص لذوي الإعاقة وفق (الدليل المبسط لمعايير الوصول الشامل للمنشآت) للمباني التجارية',
                    imgPath: ImagePath.buildingReq2,
                  ),
                  BuildingReqCard(
                    title:
                        "عدم تغطية خزانات الصرف الصحي بأغطية واقية وسليمة وفق الاشتراطات البلدية",
                    imgPath: ImagePath.buildingReq8,
                  ),
                  BuildingReqCard(
                    title:
                        "وجود أرصفة منفذة من قبل مالك المبنى أو مالك حق الانتفاع به متهالكة أو غير مكتملة -جهة الشارع التجاري",
                    imgPath: ImagePath.buildingReq9,
                  ),
                  BuildingReqCard(
                    title: "وجود أسوار متهالكة أو غير مكتملة",
                    imgPath: ImagePath.buildingReq13,
                  ),
                  BuildingReqCard(
                    title:
                        "وجود حواجز مشوهه (أشاير حديد / شينكو) على سور الارتداد أو السطح",
                    imgPath: ImagePath.buildingReq7,
                  ),
                  BuildingReqCard(
                    title:
                        "وجود وحدات تكييف منفصلة في كامل واجهة المبنى المطل على الشـــارع التجاري",
                    imgPath: ImagePath.buildingReq3,
                  ),
                  BuildingReqCard(
                    title:
                        "وجود تمديدات (كهربائية – صحية - ميكانيكية) ظاهرة في كامل واجهة المبنى المطل على الشارع التجاري",
                    imgPath: ImagePath.buildingReq5,
                  ),
                  BuildingReqCard(
                    title:
                        "وجود تشققات أو تلف (دهانات، تكسيات) أو صدأ على المواد المعدنية في كامل واجهة المبنى بإجمالي مساحة تزيد عن متر مربع",
                    imgPath: ImagePath.buildingReq12,
                  ),
                  BuildingReqCard(
                    title:
                        "وجود أطباق الأقمار الصناعية على الشرفات أو كامل واجهة المبنى المطل على الشارع التجاري",
                    imgPath: ImagePath.buildingReq14,
                  ),
                  BuildingReqCard(
                    title: "وجود مظلات أو هناجر خارج حدود الملكية",
                    imgPath: ImagePath.buildingReq15,
                  ),
                  BuildingReqCard(
                    title:
                        "تغطية الشرفات دون الحصول على التراخيص اللازمة من الأمانة/البلدية",
                    imgPath: ImagePath.buildingReq6,
                  ),
                  BuildingReqCard(
                    title:
                        "وجود كتابات مخالفة على كامل واجهة المبنى المطل على الشارع التجاري",
                    imgPath: ImagePath.buildingReq11,
                  ),
                  BuildingReqCard(
                    title:
                        "وضع المداخن على واجهة المبنى من دون أن تكون في جانب المبنى، أو أن يتجاوز ارتفاعها في جانب المبنى عن البناء أكثر من (2) متر",
                    imgPath: ImagePath.buildingReq16,
                  ),
                  BuildingReqCard(
                    title:
                        "عدم مطابقة اللوحات التجارية الخاصة بالمحلات للاشتراطات البلدية",
                    imgPath: ImagePath.buildingReq17,
                  ),
                  BuildingReqCard(
                    title:
                        "وجود لوحات إعلانية لمحلات تجارية مغلقة بتراخيص غير سارية أو منتهية، أو وجود الأساسات الحديدية لتثبيت اللوحات المزاله",
                    imgPath: ImagePath.buildingReq19,
                  ),
                  BuildingReqCard(
                    title:
                        "وجود ملصقات إعلانية قديمة أو متهالكة على واجهة المبنى",
                    imgPath: ImagePath.buildingReq10,
                  ),
                  BuildingReqCard(
                    title:
                        "وجود مخلفات ومواد بناء تعيق الحركة على الرصيف الخاص بالمبنى",
                    imgPath: ImagePath.buildingReq18,
                  ),*/

                  ListView.builder(
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
                  const SizedBox(height: 32),
                  Container(
                    height: 60,
                    padding: const EdgeInsets.all(12),
                    decoration: ShapeDecoration(
                      color: const Color(0x7FE6EFEF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: CustomTextWidget(
                      "building_requirements_warning".tr(),
                      fontColor: Color(0xFF52525B),
                      fontSize: 14,
                      maxLines: 5,
                      fontWeight: AppFontWeight.bold,
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
    String qa = await rootBundle
        .loadString("assets/compliance_pdf/text/conditions.json");
    if (!CommonFunctions.isAppAR) {
      String qa = await rootBundle
          .loadString("assets/compliance_pdf/text/conditions_en.json");
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
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: Color(0xFFE6EFEF).withOpacity(0.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CustomSvgIconWidget(
                "assets/icons/svg/flag.svg",
                iconSize: 14,
              ),
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
              child: Image.asset(
                imgPath!,
                width: MediaQuery.sizeOf(context).width,
                height: 190,
              ),
            ),
        ],
      ),
    );
  }
}

// class BuildingRequirementsCard extends StatelessWidget {
//   const BuildingRequirementsCard({
//     super.key,
//     required this.requirements,
//     required this.title,
//     required this.iconPath,
//   });
//
//   final List<String> requirements;
//   final String title;
//   final String iconPath;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         borderRadius: const BorderRadius.all(Radius.circular(8)),
//         color: AppColor.primary50Light.withOpacity(0.5),
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               CustomSvgIconWidget(
//                 iconPath,
//                 iconSize: 24,
//                 iconColor: AppColor.primary700Light,
//               ),
//               const SizedBox(width: 6),
//               CustomTextWidget(
//                 title,
//                 fontSize: 15,
//                 fontWeight: AppFontWeight.bold,
//                 fontColor: AppColor.blackModern600Light,
//               ),
//             ],
//           ),
//           const SizedBox(height: 14),
//           ListView.separated(
//             itemCount: requirements.length,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             separatorBuilder: (_, __) => const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
//               child: Divider(
//                 color: AppColor.white5,
//               ),
//             ),
//             itemBuilder: (_, index) => Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   const CustomSvgIconWidget(
//                     IconPath.checked,
//                     iconSize: 10,
//                     iconColor: AppColor.primary700Light,
//                   ),
//                   const SizedBox(width: 4),
//                   Flexible(
//                     child: CustomTextWidget(
//                       requirements[index],
//                       fontSize: 12,
//                       maxLines: null,
//                       height: 1.5,
//                       fontWeight: AppFontWeight.bold,
//                       fontColor: AppColor.blackModern600Light,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
