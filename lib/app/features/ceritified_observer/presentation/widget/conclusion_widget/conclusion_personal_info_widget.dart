import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/card_parameter.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/blocs/choose_muncipality_bloc.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/widget/expandable_with_controller_widget.dart';
import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class PersonalInfoConclusionWidget extends StatelessWidget {
  final ChooseMuncipalityState state;

  const PersonalInfoConclusionWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ExpandableWithControllerWidget(
        controller: ExpandableController(),
        title: 'vd_user_info'.tr(),
        expanded: Column(
          children: [
            CardParameter(
              title: 'mobile_number'.tr(),
              value: state.requestData?.mobileNumber ?? "",
            ),
            CardParameter(
              title: 'email'.tr(),
              value: state.requestData?.email ?? "",
            ),
            CardParameter(
              title: 'degree'.tr(),
              value: state.requestData?.academicQualification?.name ?? "",
            ),
            CardParameter(
              title: 'marital_status'.tr(),
              value: state.requestData?.maritalStatus?.name ?? "",
            ),
          ],
        ));
  }
}
