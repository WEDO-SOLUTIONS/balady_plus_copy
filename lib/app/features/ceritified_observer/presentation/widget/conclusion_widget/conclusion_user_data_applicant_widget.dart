import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/card_parameter.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/expandable_card.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/fields/read_only_field.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/blocs/choose_muncipality_bloc.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class UserDataApplicantConclusionWidget extends StatelessWidget {
  final ChooseMuncipalityState state;

  const UserDataApplicantConclusionWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: 'user_data_applicant'.tr(),
      children: [
        CardParameter(
          title: 'user_data_applicant_id'.tr(),
          value: CommonProperties.userInfo?.idNo ?? "",
        ),
        CardParameter(
          title: 'cemetry_dob_hijri'.tr(),
          value: CommonProperties.userInfo?.getHijriBirthDate() ?? "",
        ),
        CardParameter(
          title: 'sex'.tr(),
          value: CommonProperties.userInfo?.getGender() ?? "",
        ),
        CardParameter(
          title: 'user_data_applicant_name'.tr(),
          value: CommonProperties.userInfo?.arName ?? "",
        ),
      ],
    );
  }
}
