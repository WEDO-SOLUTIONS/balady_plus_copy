import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/expandable_card.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/fields/read_only_field.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/blocs/choose_muncipality_bloc.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class UserDataApplicantWidget extends StatelessWidget {
  final ChooseMuncipalityState state;

  const UserDataApplicantWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: 'user_data_applicant'.tr(),
      children: [
        const SizedBox(height: 20),
        ReadOnlyField(
          hieght: 55,
          title: "user_data_applicant_id".tr(),
          subTitle: CommonProperties.userInfo?.idNo,
          subTitleColor: AppColor.grey1000.withOpacity(0.5),
          decoration: BoxDecoration(
            color: AppColor.blackModern300Light.withOpacity(0.4),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        ReadOnlyField(
          hieght: 55,
          title: "mobile_number".tr(),
          subTitle: CommonProperties.userInfo?.phone,
          subTitleColor: AppColor.grey1000.withOpacity(0.5),
          decoration: BoxDecoration(
            color: AppColor.blackModern300Light.withOpacity(0.4),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        ReadOnlyField(
          hieght: 55,
          title: "cemetry_dob_hijri".tr(),
          subTitle: CommonProperties.userInfo?.getHijriBirthDate(),
          subTitleColor: AppColor.grey1000.withOpacity(0.5),
          decoration: BoxDecoration(
            color: AppColor.blackModern300Light.withOpacity(0.4),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        ReadOnlyField(
          hieght: 55,
          title: "sex".tr(),
          subTitle: CommonProperties.userInfo?.getGender(),
          subTitleColor: AppColor.grey1000.withOpacity(0.5),
          decoration: BoxDecoration(
            color: AppColor.blackModern300Light.withOpacity(0.4),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        ReadOnlyField(
          hieght: 55,
          title: "user_data_applicant_name".tr(),
          subTitle: CommonProperties.userInfo?.arName,
          subTitleColor: AppColor.grey1000.withOpacity(0.5),
          decoration: BoxDecoration(
            color: AppColor.blackModern300Light.withOpacity(0.4),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }
}
