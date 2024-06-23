import 'package:balady_plus/app/features/entry_point/entry_point_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/app_analytics_events.dart';
import '../../../../../core/utils/utils_exports.dart'
    show CommonFunctions, IconPath, ImagePath;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CardParameter, DefaultAppBarWidget;
import '../../personal_information_exports.dart' show PersonalInfoCard;

class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({
    super.key,
  });

  @override
  State<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  @override
  void initState() {
    super.initState();
    CommonFunctions.sendEventToAnalytics(AppEvents.profile);
  }

  @override
  Widget build(BuildContext context) {
    SsoUserInfo userInfo =
        ModalRoute.of(context)!.settings.arguments as SsoUserInfo;
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
                  CardParameter(
                    title: "full_name".tr(),
                    value: userInfo.arName ?? '',
                  ),
                  CardParameter(
                    title: "identity".tr(),
                    value: userInfo.idNo ?? '',
                  ),
                  CardParameter(
                    title: "date_of_birth".tr(),
                    value: userInfo.getFormattedBirthDate(),
                  ),
                  CardParameter(
                    title: "nationality".tr(),
                    value: userInfo.nationality ?? '',
                  ),
                  CardParameter(
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
                  CardParameter(
                    title: "phone_number".tr(),
                    value: userInfo.getPhone(),
                  ),
                  CardParameter(
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
