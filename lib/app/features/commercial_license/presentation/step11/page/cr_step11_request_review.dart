import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../vd/presentation/widgets/summery_widgets/field_data.dart';
import '../../../commercial_license_exports.dart';

class CRStep11RequestReview extends StatelessWidget {
  const CRStep11RequestReview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CRHeaderDesc(header: "مراجعه الطلب"),
                  const SizedBox(height: 16),
                  CustomExpansionPanelWidget(
                    title: "بيانات النشاط",
                    leading: SvgPicture.asset(
                      IconPath.clipboard,
                      color: AppColor.primary900Light,
                    ),
                    children: const [
                      FieldData(
                        title: "شاط أيزيك",
                        subTitle: "بيع بالتجزئه",
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  CustomExpansionPanelWidget(
                    title: "بيانات الموقع الجغرافي",
                    leading: SvgPicture.asset(
                      IconPath.qrLocationIcon,
                      width: 20,
                      height: 20,
                      color: AppColor.primary900Light,
                    ),
                    children: const [],
                  ),
                  const SizedBox(height: 14),
                  CustomExpansionPanelWidget(
                    title: "بيانات المحل واللوحات",
                    leading: SvgPicture.asset(IconPath.shopData),
                    children: const [],
                  ),
                  const SizedBox(height: 14),
                  CustomExpansionPanelWidget(
                    title: "بيانات المرفقات",
                    leading: SvgPicture.asset(IconPath.vdSummuryDesc),
                    children: const [],
                  ),
                  const SizedBox(height: 14),
                  CustomExpansionPanelWidget(
                    title: "بيانات المنشأة",
                    leading: SvgPicture.asset(IconPath.building),
                    children: const [],
                  ),
                  const SizedBox(height: 14),
                  CustomExpansionPanelWidget(
                    title: "بيانات تواصل المنشأة",
                    leading: SvgPicture.asset(
                      IconPath.qrCallIcon,
                      width: 20,
                      height: 20,
                      color: AppColor.primary900Light,
                    ),
                    children: const [],
                  ),
                  const SizedBox(height: 14),
                  CustomExpansionPanelWidget(
                    title: "بيانات العاملين",
                    leading: SvgPicture.asset(IconPath.vdSummuryUserInfo),
                    children: const [],
                  ),
                  const SizedBox(height: 14),
                  CustomExpansionPanelWidget(
                    title: "مواعيد العمل",
                    leading: SvgPicture.asset(
                      IconPath.qrClockIcon,
                      width: 20,
                      height: 20,
                      color: AppColor.primary900Light,
                    ),
                    children: const [],
                  ),
                  const SizedBox(height: 14),
                  CustomExpansionPanelWidget(
                    title: "البيانات الاضافية والمرفقات",
                    leading: SvgPicture.asset(IconPath.vdSummuryDesc),
                    children: const [],
                  ),
                  const SizedBox(height: 24),
                  UndertakingWidget(
                    desc:
                        "أقر وأتعهد بصحة كافة البيانات والمرفقات التي تم رفعها على التطبيق وأتحمل كامل المسؤولية القانونية حيال البلاغات الكاذبة والكيدية وفقاً للأنظمة والتعليمات في حال تبين خلاف ذلك",
                    text: "أقر وأتعهد على جميع ماتم ذكره اعلاه",
                    onChange: (value) {},
                    initialValue: false,
                  ),
                ],
              ),
            ),
          ),
        ),
        const CRPreviousNextButtons(isBtnDisabled: false),
      ],
    );
  }
}
