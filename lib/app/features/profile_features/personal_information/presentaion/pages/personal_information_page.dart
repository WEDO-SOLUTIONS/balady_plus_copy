import 'package:balady_plus/app/features/entry_point/entry_point_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart' show IconPath;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show DefaultAppBarWidget;
import '../../personal_information_exports.dart'
    show PersonalInfoCard, PersonalInfoParameter;

class PersonalInformationPage extends StatelessWidget {
  final SsoUserInfo userInfo;

  const PersonalInformationPage({
    super.key,
    required this.userInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(
        title: 'personal_information'.tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              PersonalInfoCard(
                title: "personal_information".tr(),
                icon: IconPath.requests,
                children: [
                  const SizedBox(height: 8),
                  PersonalInfoParameter(
                    title: "full_name".tr(),
                    value: userInfo.arName ?? '',
                  ),
                  PersonalInfoParameter(
                    title: "identity".tr(),
                    value: userInfo.idNo ?? '',
                  ),
                  PersonalInfoParameter(
                    title: "date_of_birth".tr(),
                    value: userInfo.getFormattedBirthDate(),
                  ),
                  PersonalInfoParameter(
                    title: "nationality".tr(),
                    value: userInfo.nationality ?? '',
                  ),
                  PersonalInfoParameter(
                    title: "sex".tr(),
                    value: userInfo.getGender(),
                  ),
                ],
              ),
              PersonalInfoCard(
                title: "contact_information".tr(),
                icon: IconPath.contactInfo,
                children: [
                  const SizedBox(height: 8),
                  PersonalInfoParameter(
                    title: "phone_number".tr(),
                    value: userInfo.getPhone(),
                  ),
                  PersonalInfoParameter(
                    title: "email".tr(),
                    value: userInfo.getEmail(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
