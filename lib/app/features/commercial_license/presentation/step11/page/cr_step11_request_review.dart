import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
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
                  CRHeaderDesc(header: 'step11title'.tr()),
                  const SizedBox(height: 16),
                  CustomExpansionPanelWidget(
                    title: 'step11expTitle'.tr(),
                    leading: SvgPicture.asset(
                      IconPath.clipboard,
                      color: AppColor.primary900Light,
                    ),
                    children: [
                      FieldData(
                        title: 'step11field1'.tr(),
                        subTitle: 'step11field2'.tr(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  CustomExpansionPanelWidget(
                    title: 'step11title1'.tr(),
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
                    title: 'step11title2'.tr(),
                    leading: SvgPicture.asset(IconPath.shopData),
                    children: const [],
                  ),
                  const SizedBox(height: 14),
                  CustomExpansionPanelWidget(
                    title: 'step11title3'.tr(),
                    leading: SvgPicture.asset(IconPath.vdSummuryDesc),
                    children: const [],
                  ),
                  const SizedBox(height: 14),
                  CustomExpansionPanelWidget(
                    title: 'step11title4'.tr(),
                    leading: SvgPicture.asset(IconPath.building),
                    children: const [],
                  ),
                  const SizedBox(height: 14),
                  CustomExpansionPanelWidget(
                    title: 'step11title5'.tr(),
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
                    title: 'step11title6'.tr(),
                    leading: SvgPicture.asset(IconPath.vdSummuryUserInfo),
                    children: const [],
                  ),
                  const SizedBox(height: 14),
                  CustomExpansionPanelWidget(
                    title: 'step11title7'.tr(),
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
                    title: 'step11title8'.tr(),
                    leading: SvgPicture.asset(IconPath.vdSummuryDesc),
                    children: const [],
                  ),
                  const SizedBox(height: 24),
                  UndertakingWidget(
                    desc: 'step11desc'.tr(),
                    text: 'step11text'.tr(),
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
