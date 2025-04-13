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

class BankInfoConclusionWidget extends StatelessWidget {
  final ChooseMuncipalityState state;

  const BankInfoConclusionWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ExpandableWithControllerWidget(
      controller: ExpandableController(),
      title: "bank_info".tr(),
      expanded: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CardParameter(
              title: 'bank_name'.tr(),
              value: state.requestData?.bankInfo?.name ?? "",
            ),
            CardParameter(
              title: 'bank_iban'.tr(),
              value: state.requestData?.iban ?? "",
            ),
          ],
        ),
      ),
    );
  }
}
