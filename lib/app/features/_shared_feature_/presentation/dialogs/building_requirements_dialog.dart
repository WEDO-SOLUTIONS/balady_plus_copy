import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/utils_exports.dart';
import '../../shared_feature_exports.dart';
import 'dialog_header.dart';

class BuildingRequirementsDialog extends StatelessWidget {
  const BuildingRequirementsDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.white,
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: AppColor.white,
              ),
              child: const Column(
                children: [
                  BuildingReqCard(
                    title: 'عدم تعديل استخدام المواقف المعتمدة في القبو',
                  ),
                  BuildingReqCard(
                    title:
                        'تنفيذ منحدر للأشخاص ذوي الإعاقة وفق (الدليل المبسط لمعايير الوصول الشامل للمنشآت)',
                    imgPath: ImagePath.buildingReq1,
                  ),
                  BuildingReqCard(
                    title:
                        'توفير مواقف للأشخاص ذوي الإعاقة أمام المنحدر الخاص لذوي الإعاقة وفق متطلبات رخصة البناء للمبنى. (للمباني التجارية)',
                    imgPath: ImagePath.buildingReq2,
                  ),
                  BuildingReqCard(
                    title: "تغطية خزانات الصرف الصحي بأغطية واقية وسليمة",
                    imgPath: ImagePath.buildingReq3,
                  ),
                  BuildingReqCard(
                    title:
                        "عدم وجود أرصفة متهالكة أو غير مكتملة جهة الشارع الرئيسي",
                    imgPath: ImagePath.buildingReq4,
                  ),
                  BuildingReqCard(
                    title: "عدم وجود أسوار متهالكة وغير مكتملة",
                  ),
                  BuildingReqCard(
                    title:
                        "عدم وجود حواجز مشوهة (أشاير حديد / شينكو ) على سور الارتداد أو السطح في المباني الواقعة   على الشوارع التجارية",
                    imgPath: ImagePath.buildingReq5,
                  ),
                  BuildingReqCard(
                    title:
                        "عدم وجود وحدات التكييف المنفصلة في الواجهات المطلة للمباني الواقعة على الشوارع التجارية",
                    imgPath: ImagePath.buildingReq6,
                  ),
                  BuildingReqCard(
                    title:
                        "عدم وجود تمديدات (كهربائية – صحية - ميكانيكية) ظاهرة الواجهة المطلة على الشوارع التجارية",
                    imgPath: ImagePath.buildingReq7,
                  ),
                  BuildingReqCard(
                    title:
                        "عدم وجود تشققات أو تلف في واجهات المباني (دهانات، تكسيات) أو وجود صدأ واضح على المواد المعدنية في الواجهات",
                    imgPath: ImagePath.buildingReq8,
                  ),
                  BuildingReqCard(
                    title:
                        "عدم وجود أطباق الأقمار الصناعية على الشرفات أو واجهات المباني المطلة على الشوارع التجارية",
                  ),
                  BuildingReqCard(
                    title: "عدم وجود مظلات او هناجر خارج حدود البناء",
                  ),
                  BuildingReqCard(
                    title:
                        "عدم تغطية الشرفات دون الحصول على  التراخيص اللازمة من الجهاز البلدي ، أو استخدامها لنشر الغسيل أو التخزين  ",
                    imgPath: ImagePath.buildingReq9,
                  ),
                  BuildingReqCard(
                    title: "عدم وجود كتابات مخالفة على جدران المباني",
                    imgPath: ImagePath.buildingReq10,
                  ),
                  BuildingReqCard(
                    title:
                        "عدم وضع المداخن على واجهة المبنى، وعدم تجاوز المداخن إرتفاع البناء بأكثر من (2)متر.",
                  ),
                  BuildingReqCard(
                    title: "مطابقة اللوحات التجارية الخاصة بالمحلات لاشتراطات",
                  ),
                  BuildingReqCard(
                    title:
                        "عدم وجود لوحات إعلانية لمحلات تجارية مغلقة بتراخيص غير سارية أو منتهية، أو الأساسات الحديدية لتثبيت اللوحات المزالة",
                    imgPath: ImagePath.buildingReq11,
                  ),
                  BuildingReqCard(
                    title:
                        "عدم وجود ملصقات إعلانية قديمة ومتهالكة على واجهة المباني والمحلات التجارية",
                  ),
                  BuildingReqCard(
                    title: "عدم وجود صناديق بريد أو صحف متهالكة وغير مستخدمة",
                    imgPath: ImagePath.buildingReq12,
                  ),
                  BuildingReqCard(
                    title:
                        "عدم وجود مخلفات ومواد بناء تعيق الحركة على الرصيف الخاص بالمبنى، مع الالتزام بنظافة الموقع والرصيف الأمامي للمبنى",
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
        color: AppColor.primary50Light.withOpacity(0.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CustomSvgIconWidget(
                IconPath.checked,
                iconSize: 9,
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
